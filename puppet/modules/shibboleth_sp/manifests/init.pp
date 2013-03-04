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
		} # End package.

		# Config.

		# Generate SSL cert.
		exec { "shib-ssl-cert":
			cwd     => "/etc/shibboleth",
			path    => ["/bin"],
			command => "./keygen.sh -f -h $SERVICE_PROVIDER_SSL_CERT_CN -e $SERVICE_PROVIDER_ENTITY_ID",
			require => Package["shibboleth"],
		} # End exec.

	} # End if.

} # End if.
