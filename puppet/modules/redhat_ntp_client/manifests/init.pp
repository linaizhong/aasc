class redhat_ntp_client {

	package { "ntp":
		ensure => installed,
	} # End package.

	service { "ntpd":
		enable  => true,
		ensure  => running,
		require => Package["ntp"],
	} # End service.

} # End if.
