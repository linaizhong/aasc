class shibboleth_sp {

	notice("Installing Shibboleth SP.")
notice("${AAF_METADATA_CERTIFICATE_URL}")

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
			notify  => [Exec['generate-new-shib-ssl-cert'], Exec['initialise-aaf-metadata-document']],
		} # End package.

		package { "wget":
			ensure  => installed,
		} # End package.

		# Ensure apache is running and will start at boot.
		service { "shibd":
			enable  => true,
			ensure  => running,
			notify  => Service['httpd'],
			require => Package["shibboleth"],
		} # End if.

		# Generate SSL cert.
		exec { "generate-new-shib-ssl-cert":
			cwd         => "/etc/shibboleth",
			path        => ["/etc/shibboleth", "/bin", "/usr/bin"],
			command     => "./keygen.sh -f -h $SERVICE_PROVIDER_SSL_CERT_CN -e $SERVICE_PROVIDER_ENTITY_ID",
			refreshonly => true,
			notify      => Exec["fix-key-permissions"],
			require     => Package["shibboleth"],
		} # End exec.

		# Download AAF metadata document.
		exec { "initialise-aaf-metadata-document":
			cwd         => "/etc/shibboleth",
			path        => ["/bin", "/usr/bin"],
			command     => "wget $AAF_METADATA_CERTIFICATE_URL -O /etc/shibboleth/aaf-metadata-cert.pem",
			refreshonly => true,
			require     => Package["wget"],
		} # End exec.

		exec { "fix-key-permissions":
			cwd         => "/etc/shibboleth",
			path        => ["/bin", "/usr/bin"],
			command     => "chown shibd.shibd /etc/shibboleth/sp-key.pem",
			refreshonly => true,
			notify      => Service['shibd'],
		} # End exec.

		# Service provider configuration files.
		file {
			"/etc/shibboleth/shibboleth2.xml":
				owner   => root,
				group   => root,
				mode    => 644,
				content => template("shibboleth_sp/shibboleth2.xml.erb"),
				# Enable once we are synching actively with Puppet, instead of one shot.
				# notify  => Service["shibd"],
				require => Package["shibboleth"];
		} # End file.

	} # End if.

} # End if.

