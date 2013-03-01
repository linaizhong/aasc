class apache_web_server {

	if (($operatingsystem == 'Red Hat') or ($operatingsystem == 'CentOS')) {
		$packages  = [ 'httpd', 'mod_ssl' ]
		package { $packages:
			ensure => installed,
		} # End package.
	} # End if.

} # End class.
