class redhat_ntp_client {

	package { "ntp":
		ensure => installed,
	} # End package.

	service { "ntpd":
		enabled => true,
		running => true,
		require => Package["ntp"],
	} # End service.

} # End if.
