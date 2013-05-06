AASC (AAF Automated Software Configurator)
==========================================

PRERQUISITES

Currently the only supported platforms are:

- Red Hat Enterprise Linux Server 6
- CentOS 6

Note:

You must have yum configured to be able to download packages from the base and extras Red Hat/CentOS channels for the install script to function correctly.

INSTALLATION

1) Download the bootstrap script to your server.

If you have wget installed:

    wget --no-check-certificate https://raw.github.com/ausaccessfed/aasc/master/go-redhat

Or, point you web browser here:

    https://raw.github.com/ausaccessfed/aasc/master/go-redhat

And then cut and paste the script into a file called go-redhat on your server.

2.) Run the bootstrap script.

As root:

    sh go-redhat


