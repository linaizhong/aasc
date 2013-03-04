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

		# Configure Apache for Shibboleth.
		if ($SERVICE_PROVIDER_SOFTWARE_TYPE == 'shibboleth') {

                	file { "/etc/httpd/conf.d/shib.conf":
                        	owner   => root,
                        	group   => root,
                        	mode    => 644,
                        	content => template("apache_web_server/shib.conf.erb"),
                        	require => Package["httpd"],
				notify  => Service["httpd"],
                	} # End file.

		} # End if

	} # End if.

} # End class.
