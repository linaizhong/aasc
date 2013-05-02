class linux_selinux {

	file {
		"/etc/selinux/config":
			owner   => root,
			group   => root,
			mode    => 644,
			source  => "puppet:///modules/linux_selinux/config";
	} # End file.
	
	exec {

	}

} # End class.
