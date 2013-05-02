class linux_node {

	if ($operatingsystem == '' or $operating_system == 'CentOS') {
		include 'redhat_node.pp'
	} # End if.

	include "linux_selinux"

} # End class.
