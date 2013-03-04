class apache_web_server {

	if (($operatingsystem == 'Red Hat') or ($operatingsystem == 'CentOS')) {

		# Install apache package.
		$packages  = [ 'httpd', 'mod_ssl' ]
		package { $packages:
			ensure => installed,
		} # End package.

		# Ensure apache is running and will start at boot.
		service { "httpd":
			enable  => true,
			ensure  => running,
			require => Package["httpd"],
		} # End if.
	} # End if.

} # End class.
