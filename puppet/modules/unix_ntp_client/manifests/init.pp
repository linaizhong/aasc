class unix_ntp_client {

	# Include Linux 
	if ($kernel == 'Linux') {
		include 'linux_ntp_client'
	} # End if.

} # End class.
