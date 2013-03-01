class linux_node {

	if ($operatingsystem == '' or $operating_system == 'CentOS') {
		include 'redhat_node.pp'
	} # End if.

} # End class.
