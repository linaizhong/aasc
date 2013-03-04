class shibboleth_sp {

	notice("Installing Shibboleth SP.")

	if (($operatingsystem == 'Red Hat') or ($operatingsystem == 'CentOS')) {

		# Yum repo set up.
		file { "/etc/yum.repos.d/security-shibboleth.repo":
			owner  => "root",
			group  => "root",
			mode   => 600,
			source => "puppet:///modules/shibboleth_sp/security-shibboleth.repo"
		} # End file.

		# Install packages.
		package { "shibboleth":
			ensure  => installed,
			require => File["/etc/yum.repos.d/security-shibboleth.repo"],
			notify  => Exec['clean-default-shib-ssl-cert'],
		} # End package.

		# Ensure apache is running and will start at boot.
		service { "shibd":
			enable  => true,
			ensure  => running,
			require => Package["shibboleth"],
		} # End if.

		# Generate SSL cert.
		exec { "clean-default-shib-ssl-cert":
			cwd     => "/etc/shibboleth",
			path    => ["/bin"],
			command => "rm -f /etc/shibboleth/sp-cert.pem",
			require => Package["shibboleth"],
		} # End exec.

		# Generate SSL cert.
		exec { "generate-new-shib-ssl-cert":
			cwd     => "/etc/shibboleth",
			path    => ["/etc/shibboleth", "/bin", "/usr/bin"],
			command => "./keygen.sh -f -h $SERVICE_PROVIDER_SSL_CERT_CN -e $SERVICE_PROVIDER_ENTITY_ID",
			onlyif  => "test ! -e /etc/shibboleth/sp-key.pem",
			require => Package["shibboleth"],
		} # End exec.

		# Service provider configuration file.
		file { "/etc/shibboleth2.xml":
			owner   => root,
			group   => root,
			mode    => 644,
			content => template("shibboleth_sp/shibboleth2.xml.erb"),
			require => Package["shibboleth"],
# Enable once we are synching actively with Puppet, instead of one shot.
#			notify  => Service["shibd"],
		} # End file.

	} # End if.

} # End if.
