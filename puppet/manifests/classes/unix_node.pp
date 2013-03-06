# Configuration applied to all UNIX-like servers.
class unix_node {

	include 'unix_ntp_client'

	# Linux specific configuration.
	if ($kernel == 'Linux') {
		include 'linux_node'
	} # End if.

} # End class.
