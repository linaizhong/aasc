class linux_selinux {

	file {
		"/etc/selinux/config":
			owner   => root,
			group   => root,
			mode    => 644,
			source  => "puppet:///modules/linux_selinux/config";
	} # End file.
	
	exec { "disable-selinux":
		cwd     => "/",
		path    => ["/bin", "/usr/sbin"],
		command => "setenforce 0 || echo -n"
	} # End exec.

} # End class.
