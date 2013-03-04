class apache_web_server {

notice("ROAR#1")

	if (($operatingsystem == 'Red Hat') or ($operatingsystem == 'CentOS')) {
notice("ROAR#2")
		# Install apache package.
		$packages  = [ 'httpd', 'mod_ssl' ]
		package { $packages:
			ensure => installed,
		} # End package.

		# Ensure apache is running and will start at boot.
		service { "httpd":
			enable => true,
			start =>  true,
		} # End if.
	} # End if.



} # End class.
