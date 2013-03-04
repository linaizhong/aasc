# Configuration applied to all service providers servers.
class service_provider_node {

notice("asdf ${WEB_SERVER_SOFTWARE_TYPE}")

	# Include class for UNIX vs Windows.
	# TODO: Change to reliable check for Windows/*nix.
	if (true) {
		include 'unix_node'
	} else {
		include 'windows_node'
	} # End if.

	# Select the web server software to install.
	if ($WEB_SERVER_SOFTWARE_TYPE == 'apache') {
		include 'apache_web_server'
	} elsif ($WEB_SERVER_SOFTWARE_TYPE == 'other') {
		include 'null'
	} # End if.

	# Select the service provider software to install.
	if ($SERVICE_PROVIDER_SOFTWARE_TYPE == 'shibboleth') {
		include 'shibboleth_sp'
	} elsif ($SERVICE_PROVIDER_SOFTWARE_TYPE == 'simplesaml') {
		include 'simplesaml_sp'
	} # End if.

} # End class.
