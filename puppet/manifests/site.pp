# Preload tags so they can be used in all other configuration files.
import "tags/*"
# Preload other configuration files.
import "classes/*"
import "library/*"
import "nodes.pp"

# The filebucket option allows for file backups to the server.
filebucket {
	main: server => 'puppet.aaf.edu.au'
}

# Set global defaults - including backing up all files to the main filebucket and adds a global path.
File {
	backup => main
}
Exec {
	path => "/usr/bin:/usr/sbin/:/bin:/sbin"
}

