AASC (AAF Automated Software Configurator)
------------------------------------------

Prerequisites
=============

Currently the only supported platforms are:

- Red Hat Enterprise Linux Server 6
- CentOS 6

**Note:**

If you are using RedHat Enterprise Linux 6, you need to enable the Optional channel for your host by logging into Red Hat Network (RHN) or your organisation's Satellite server.

Installation
============

1) Download the bootstrap script to your server.

If you have wget installed:

    wget --no-check-certificate https://raw.github.com/ausaccessfed/aasc/master/go-redhat

Or, point you web browser here:

    https://raw.github.com/ausaccessfed/aasc/master/go-redhat

And then cut and paste the script into a file called go-redhat on your server.

2.) Run the bootstrap script.

As root:

    sh go-redhat

Support
=======

AASC is currently beta software.  If you encounter any issues when using the software, or you have feature requests, please contact [support@aaf.edu.au](mailto:support@aaf.edu.au).  Our development team will respond to all requests, but be aware that priority will be given to support, bug fixes and enhancement to production software.
