# Configuration applied to all UNIX-like servers.
class unix_node {

	# Only install NTP client if the user has opted to.
	if ($INSTALL_NTP_CLIENT == true) {
		include 'unix_ntp_client'
	}

	# Linux specific configuration.
	if ($kernel == 'Linux') {
		include 'linux_node'
	} # End if.

} # End class.
