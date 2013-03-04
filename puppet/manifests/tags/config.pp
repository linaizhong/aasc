# The type of environment.
# Currently supported options are: test, prod
$ENVIRONMENT_TYPE = 'prod'

# The entity ID of the service provider.
$SERVICE_PROVIDER_ENTITY_ID = 'https://asdfsad/shib'

# The common name for use in the backend SSL certificate for the service provider.
$SERVICE_PROVIDER_SSL_CERT_CN = 'asdfsad'

# The service provider software to install.
# Currently supported options are: shibboleth
$SERVICE_PROVIDER_SOFTWARE_TYPE = 'shibboleth'

# The web server to install the service provider software on.
# Currently supported options are: apache
$WEB_SERVER_SOFTWARE_TYPE = 'apache'

# Set tags based on environment.
if ($ENVIRONMENT_TYPE == 'prod') {
	$AAF_METADATA_CERTIFICATE_URL="https://ds.aaf.edu.au/distribution/metadata/aaf-metadata-cert.pem"
	$DISCOVERY_SERVICE_URL="https://ds.aaf.edu.au/discovery/DS"
} elsif ($ENVIRONMENT_TYPE == 'test') {
	$AAF_METADATA_CERTIFICATE_URL="https://ds.test.aaf.edu.au/distribution/metadata/aaf-metadata-cert.pem"
	$DISCOVERY_SERVICE_URL="https://ds.test.aaf.edu.au/discovery/DS"
} else {
	$AAF_METADATA_CERTIFICATE_URL="FIX_ME"
	$DISCOVERY_SERVICE_URL="FIX_ME"
} # End if.

