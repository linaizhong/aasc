class shibboleth_sp {

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
#			notify  => Exec['generate-new-shib-ssl-cert'],
		} # End package.

		package { "wget":
			ensure  => installed,
		} # End package.

		# Ensure apache is running and will start at boot.
		service { "shibd":
			enable  => true,
			ensure  => running,
			notify  => Service['httpd'],
			require => [Package["shibboleth"], Exec["initialise-aaf-metadata-document"], Exec["generate-new-shib-ssl-cert"], Exec["fix-key-permissions"]],
		} # End if.

		# Generate SSL cert.
		exec { "generate-new-shib-ssl-cert":
			unless      => "openssl x509 -noout -text -in sp-cert.pem | grep 'Subject: CN=$SERVICE_PROVIDER_ENTITY_ID",
			cwd         => "/etc/shibboleth",
			path        => ["/etc/shibboleth", "/bin", "/usr/bin"],
			command     => "./keygen.sh -f -h $SERVICE_PROVIDER_SSL_CERT_CN -e $SERVICE_PROVIDER_ENTITY_ID",
			refreshonly => true,
			notify      => Exec["fix-key-permissions"],
			require     => Package["shibboleth"],
		} # End exec.

		# Download AAF metadata document.
		exec { "initialise-aaf-metadata-document":
			onlyif      => "test ! -f /etc/shibboleth/aaf-metadata-cert.pem",
			cwd         => "/etc/shibboleth",
			path        => ["/bin", "/usr/bin"],
			command     => "wget $AAF_METADATA_CERTIFICATE_URL -O /etc/shibboleth/aaf-metadata-cert.pem",
			require     => [Package["wget"], Package["shibboleth"]],
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
				require => Package["shibboleth"];
			"/etc/shibboleth/attribute-map.xml":
				owner   => root,
				group   => root,
				mode    => 644,
				source  => "puppet:///modules/shibboleth_sp/attribute-map.xml",
				require => Package["shibboleth"];
		} # End file.

	} # End if.

} # End if.

