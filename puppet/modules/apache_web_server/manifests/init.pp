class apache_web_server {

	if (($operatingsystem == 'Red Hat') or ($operatingsystem == 'CentOS')) {

		# Install apache package.
		$packages  = [ 'httpd', 'mod_ssl', 'mod_php' ]
		package { $packages:
			ensure => installed,
		} # End package.

		# Ensure apache is running and will start at boot.
		service { "httpd":
			enable  => true,
			ensure  => running,
			require => Package["httpd"],
		} # End if.

		# Configure Apache for Shibboleth.
		if ($SERVICE_PROVIDER_SOFTWARE_TYPE == 'shibboleth') {

                	file { "/etc/httpd/conf.d/shib.conf":
                        	owner   => root,
                        	group   => root,
                        	mode    => 644,
                        	content => template("apache_web_server/shib.conf.erb"),
                        	require => Package["httpd"],
# Enable once we are synching actively with Puppet, instead of one shot.
#				notify  => Service["httpd"],
                	} # End file.

		} # End if

		# Dummy web content.
               	file {
			"/var/www/html/index.html":
                       		owner  => root,
                       		group  => root,
                       		mode   => 644,
				source => "puppet:///modules/apache_web_server/index.html";
			"/var/www/html/index.php":
                       		owner  => root,
                       		group  => root,
                       		mode   => 755,
				source => "puppet:///modules/apache_web_server/index.php";
			"/var/www/html/secure":
                       		owner  => root,
                       		group  => root,
                       		mode   => 755,
				ensure => directory;
			"/var/www/html/secure/index.html":
                       		owner  => root,
                       		group  => root,
                       		mode   => 644,
				source => "puppet:///modules/apache_web_server/index.html";
			"/var/www/html/secure/index.php":
                       		owner  => root,
                       		group  => root,
                       		mode   => 755,
				source => "puppet:///modules/apache_web_server/index.php";
               	} # End file.
	

	} # End if.

} # End class.
