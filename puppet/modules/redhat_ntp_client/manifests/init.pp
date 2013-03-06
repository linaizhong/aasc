class redhat_ntp_client {

	Package { "ntp":
		ensure => installed,
	} # End package.

	Service { "ntpd":
		enabled => true,
		running => true,
		required => Package["ntp"];
	} # End service.

} # End if.
