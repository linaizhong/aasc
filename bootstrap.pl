#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use File::Path;

my $EXIT_SUCCESS = 0;
my $EXIT_FAILURE = 1;


my $REQUIRED_PACKAGES = {
	'CentOS' => {
		'6' => [ 'git', 'puppet' ],
	},
	'Red Hat Enterprise Linux' => {
		'6' => [ 'git', 'puppet' ],
	},
};

my $CHECK_PACKAGE_COMMAND = {
	'CentOS' => {
		'6' => 'rpm -qi %s',
	},
	'Red Hat Enterprise Linux' => {
		'6' => 'rpm -qi %s',
	},
};

my $INSTALL_PACKAGE_COMMAND = {
	'CentOS' => {
		'6' => '/usr/bin/yum -y install %s',
	},
	'Red Hat Enterprise Linux' => {
		'6' => '/usr/bin/yum -y install %s',
	},
};

# The default environment type.
my $DEFAULT_ENVIRONMENT_TYPE = 'test';

# The deffault service provider software.
my $DEFAULT_SP_SOFTWARE_TYPE = 'shibboleth';

# The default web server software.
my $DEFAULT_WEB_SERVER_SOFTWARE_TYPE = 'apache';

# A list of valid values for the environment type.
my @VALID_ENVIRONMENT_TYPES = ( 'prod', 'test' );

# A list of valid values for the service provider software type.
my @VALID_SP_SOFTWARE_TYPES = ( 'shibboleth' );

# A list of valid values for the web server software type.
my @VALID_WEB_SERVER_SOFTWARE_TYPES = ( 'apache' );

# Location where the script will pull down configs to and run them (temporarily).
my $DEFAULT_WORKING_DIR = '/tmp/automatesp';

# Get the hostname of the system to use in default values later.
my $hostname = `hostname`;
if ($? != 0) {
	printf(STDERR "ERROR: Unable to get hostname of the system.\n");
	exit($EXIT_FAILURE);
}
chomp($hostname);

# Set the default entity id based on the hostname of the server.
my $default_entity_id = "https://$hostname/shibboleth";

# Use a completely separate Puppet var directory so we don't clobber existing Puppet installs. 
my $puppet_var_dir = '/var/lib/puppet-aaf';

my $operating_system_name = '';
my $operating_system_release = '';

my %opts;
getopt('d:e:i:s:w:"', \%opts);
my $working_dir = $opts{'d'} || $DEFAULT_WORKING_DIR;
my $environment_type = $opts{'e'} || $DEFAULT_ENVIRONMENT_TYPE;
my $entity_id = $opts{'i'} || $default_entity_id;
my $sp_software_type = $opts{'s'} || $DEFAULT_SP_SOFTWARE_TYPE;
my $web_server_software_type = $opts{'w'} || $DEFAULT_WEB_SERVER_SOFTWARE_TYPE;
#print("\$working_dir:$working_dir:\n");
#print("\$environment_type:$environment_type:\n");
#print("\$entity_id:$entity_id:\n");
#print("\$sp_software_type:$sp_software_type:\n");
#print("\$web_server_software_type:$web_server_software_type:\n");

# Check the script is being run as root.
# TODO: Not portable to Windows!
my $uid = $<;
if ($< != 0) {
	printf(STDERR "This script must be run as root.\n");
	exit($EXIT_FAILURE);
} # End if.

# If working directory does not exist, create it.
if (! -e $working_dir) {
	mkpath([$working_dir],1,0700);
} else {
	my $command = "rm -rf $working_dir/*";
	my $stdout = `$command`;
	my $return = $?;
} # End if.

# Check that environment type is valid.
if (! &is_in($environment_type, @VALID_ENVIRONMENT_TYPES)) {
	printf(STDERR "ERROR: Invalid environment type. Valid types are: ");
	foreach (sort(@VALID_ENVIRONMENT_TYPES)) {
		printf(STDERR "$_ ");
	} # End foreach.
	printf(STDERR "\n");
	exit($EXIT_FAILURE);
} # End if.

# Check that service provider software type is valid.
if (! &is_in($sp_software_type, @VALID_SP_SOFTWARE_TYPES)) {
	printf(STDERR "ERROR: Invalid service provider software type. Valid types are: ");
	foreach (sort(@VALID_SP_SOFTWARE_TYPES)) {
		printf(STDERR "$_ ");
	} # End foreach.
	printf(STDERR "\n");
	exit($EXIT_FAILURE);
} # End if.

# Check that web server software type is valid.
if (! &is_in($web_server_software_type, @VALID_WEB_SERVER_SOFTWARE_TYPES)) {
	printf(STDERR "ERROR: Invalid web server software type. Valid types are: ");
	foreach (sort(@VALID_WEB_SERVER_SOFTWARE_TYPES)) {
		printf(STDERR "$_ ");
	} # End foreach.
	printf(STDERR "\n");
	exit($EXIT_FAILURE);
} # End if.

# Get the CN for the SSL cert based on the entity ID of the service provider.
my $ssl_cert_common_name = $entity_id;
$ssl_cert_common_name =~ s/^http:\/\///;
$ssl_cert_common_name =~ s/^https:\/\///;
$ssl_cert_common_name =~ s/\/.+//g;

# Check current operating environment.

# Attempt to determine current operating system.
# Are we running CentOS?
if ( `cat /etc/redhat-release 2>/dev/null` =~ /^CentOS release (\d+)\.\d+ \(Final\)$/ ) {
	$operating_system_name = 'CentOS';
	$operating_system_release = $1;
} # End if.

# Error checking for operating system name.
if ( $operating_system_name eq '' ) {
	printf(STDERR "ERROR: Unable to determine operating system.\n");
	exit($EXIT_FAILURE);
} # End if.

# Error checking for operating system release.
if ( $operating_system_release eq '' ) {
	printf(STDERR "ERROR: Unable to determine operating system release.\n");
} # End if.

# Exclude unsupported operating systems and releases.
if ( $operating_system_name eq 'CentOS' and $operating_system_release eq '6' ) {
	print("Operating system is $operating_system_name release $operating_system_release\n");
} elsif ( $operating_system_name eq 'Red Hat' and $operating_system_release eq '6' ) {
	print("Operating system is $operating_system_name release $operating_system_release\n");
} else {
	printf(STDERR "ERROR: Operating system '$operating_system_name' and/or release '$operating_system_release' is not supported.\n");
} # End if. 

# Check currently installed packages.
my $check_package_command = ${$CHECK_PACKAGE_COMMAND}{$operating_system_name}{$operating_system_release};
my @required_packages = @{${$REQUIRED_PACKAGES}{$operating_system_name}{$operating_system_release}};
my @packages_to_install;
foreach my $required_package (@required_packages) {
	my $command = sprintf($check_package_command, $required_package);
	my $stdout = `$command`;
	my $return = $?;
	if ($return != 0) {
		print("Package '$required_package' not installed.\n");
		push(@packages_to_install, $required_package);
	} # End if.
} # End foreach.

# . Configure Yum repositories.
# - foreach required repo
# -- check if already configured
# -- if not already configured, configure it

# . Install all required packages.
my $install_package_command = ${$INSTALL_PACKAGE_COMMAND}{$operating_system_name}{$operating_system_release};
foreach my $package_to_install (sort(@packages_to_install)) {
	print("Installing required package '$package_to_install'.\n");
	my $command = sprintf($install_package_command, $package_to_install);
	my $stdout = `$command`;
	my $return = $?;
	if ($return != 0) {
		printf("ERROR: Could not install required package '$package_to_install'.  Exiting...\n");
		exit($EXIT_FAILURE);
	} # End if.
} # End foreach.

# Download Puppet manifests
my $command;
my $stdout;
my $return;
# Clone from git.
$command = "cd $working_dir && git clone git://github.com/ausaccessfed/automatesp.git";
$stdout = `$command`;
$return = $?;
if ($return != 0) {
	printf("ERROR: Error running command '$command'. Return code '$return'.\n");
	exit($EXIT_FAILURE);
} # End if.

# Clean up git metadata files.
$command = "cd $working_dir/automatesp && rm -rf .git"; 
$stdout = `$command`;
$return = $?;
if ($return != 0) {
	printf("ERROR: Error running command '$command'. Return code '$return'.\n");
	exit($EXIT_FAILURE);
} # End if.

# Full path to the Puppet config to edit in place so we can feed user parameters into the Puppet configuration.
my $puppet_manifest_config_file = "$working_dir/automatesp/puppet/manifests/tags/config.pp";

# Read Puppet manifest config file and munge.
open(FP, $puppet_manifest_config_file) || die("ERROR: Could not open '$puppet_manifest_config_file' for reading.\n");
my @lines = <FP>;
close(FP);
for (my $i = 0; $i < scalar(@lines); $i++) {
	$lines[$i] =~ s/^\$ENVIRONMENT_TYPE = '.+$/\$ENVIRONMENT_TYPE = '$environment_type'/;
	$lines[$i] =~ s/^\$SERVICE_PROVIDER_ENTITY_ID = '.+$/\$SERVICE_PROVIDER_ENTITY_ID = '$entity_id'/;
	$lines[$i] =~ s/^\$SERVICE_PROVIDER_SSL_CERT_CN = '.+$/\$SERVICE_PROVIDER_SSL_CERT_CN = '$ssl_cert_common_name'/;
	$lines[$i] =~ s/^\$SERVICE_PROVIDER_SOFTWARE_TYPE = '.+$/\$SERVICE_PROVIDER_SOFTWARE_TYPE = '$sp_software_type'/;
	$lines[$i] =~ s/^\$WEB_SERVER_SOFTWARE_TYPE = '.+$/\$WEB_SERVER_SOFTWARE_TYPE = '$web_server_software_type'/;
} # End for.

# Pass in user specified parameters to Puppet manifests.
open(FP, "> $puppet_manifest_config_file") || die("ERROR: Could not open '$puppet_manifest_config_file' for writing.\n");
foreach (@lines) {
	print(FP "$_");
} # End foreach.
close(FP);

# Run puppet on downloaded manifests.
my $puppet_dir = "$working_dir/automatesp/puppet";
$command = "puppet apply --debug --verbose --color=false --vardir=$puppet_var_dir --modulepath=$puppet_dir/modules --libdir=$puppet_dir/lib $puppet_dir/manifests/site.pp";
$stdout = `$command`;
$return = $?;
if ($return != 0) {
	printf("ERROR: Puppet command failed.  Return code '$return'.\n");
	exit($EXIT_FAILURE);
} # End if.

print("$command\n");
print("$stdout\n");

# Clean up
# $working dir
# $puppet_var_dir


# Display program usage to standard error.
sub usage {
	printf(STDERR "$0 [ -d working_dir ] [ -e environment_type ] [ -i entity_id ] [ -s sp_software ] [ -w web_server_software ]\n\n");
	printf(STDERR "working_dir - the directory where this script will copy files it needs to install the SP.\n");
	printf(STDERR "environment_type - the environment type that this service provider will run under.\n");
	printf(STDERR "entity_id - the entity ID for this service provider.\n");
	printf(STDERR "sp_software - the service provider software type.\n");
	printf(STDERR "web_server_software - the web server software type.\n");
} # End sub.


# Return true if the item is in the list.
sub is_in {
	my $item = shift;
	my @list = @_;

	foreach (@list) {
		return 1 if ($_ eq $item);
	} # End foreach.
	return(0);
} # End sub.
