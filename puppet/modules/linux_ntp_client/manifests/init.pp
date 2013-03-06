class linux_ntp_client {

	# Red Hat like systems.
	if (($operatingsystem == 'Red Hat') or ($operatingsystem == 'CentOS')) {
		include 'redhat_ntp_client'
	} # End if.

} # End class.
