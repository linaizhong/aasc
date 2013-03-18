class sp_web_content {

	$DOCUMENT_ROOT = "/var/www/html/"

	file {
		"$DOCUMENT_ROOT":
			owner   => root,
			group   => root,
			mode    => 755,
			ensure  => directory;
		"$DOCUMENT_ROOT/index.html":
			owner   => root,
			group   => root,
			mode    => 644,
			content => template("sp_web_content/index.html.erb");
		"$DOCUMENT_ROOT/logo.jpg":
			owner   => root,
			group   => root,
			mode    => 644,
			source  => "puppet:///modules/sp_web_content/logo.jpg";
		"$DOCUMENT_ROOT/css":
			owner   => root,
			group   => root,
			mode    => 755,
			ensure  => directory;
		"$DOCUMENT_ROOT/js":
			owner   => root,
			group   => root,
			mode    => 755,
			ensure  => directory;
		"$DOCUMENT_ROOT/secure":
			owner   => root,
			group   => root,
			mode    => 755,
			ensure  => directory;
		"$DOCUMENT_ROOT/css/aaf_base_application.css":
			owner   => root,
			group   => root,
			mode    => 644,
			source  => "puppet:///modules/sp_web_content/aaf_base_application.css";
		"$DOCUMENT_ROOT/css/aaf_base_application.less":
			owner   => root,
			group   => root,
			mode    => 644,
			source  => "puppet:///modules/sp_web_content/aaf_base_application.less";
		"$DOCUMENT_ROOT/css/bootstrap.css":
			owner   => root,
			group   => root,
			mode    => 644,
			source  => "puppet:///modules/sp_web_content/bootstrap.css";
		"$DOCUMENT_ROOT/js/jquery-1.7.2.min.js":
			owner   => root,
			group   => root,
			mode    => 644,
			source  => "puppet:///modules/sp_web_content/jquery-1.7.2.min.js";
		"$DOCUMENT_ROOT/js/modernizr-2.6.2.js":
			owner   => root,
			group   => root,
			mode    => 644,
			source  => "puppet:///modules/sp_web_content/modernizr-2.6.2.js";
		"$DOCUMENT_ROOT/secure/index.php":
			owner   => root,
			group   => root,
			mode    => 644,
			source  => "puppet:///modules/sp_web_content/index.php";
	} # End file.

} # End class.
