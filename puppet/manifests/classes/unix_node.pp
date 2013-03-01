# Configuration applied to all UNIX-like servers.
class unix_node {

	if ($kernel == 'Linux') {
		include 'linux_node'
	} # End if.

} # End class.
