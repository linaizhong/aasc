SCOVER_SERVICE_HOST
# Currently supported options are: test, prod
$ENVIRONMENT_TYPE = ''

# The entity ID of the service provider.
$SERVICE_PROVIDER_ENTITY_ID = ''

# The common name for use in the backend SSL certificate for the service provider.
$SERVICE_PROVIDER_SSL_CERT_CN = ''

# The service provider software to install.
# Currently supported options are: shibboleth
$SERVICE_PROVIDER_SOFTWARE_TYPE = ''

# The web server to install the service provider software on.
# Currently supported options are: apache
$WEB_SERVER_SOFTWARE_TYPE = ''

# Install NTP client or not.
# Currently support options are: true, false
$INSTALL_NTP_CLIENT = 

# Set tags based on environment.
if ($ENVIRONMENT_TYPE == 'prod') {
	$DISCOVER_SERVICE_HOST="ds.aaf.edu.au"
	$AAF_METADATA_CERTIFICATE_URL="https://$DISCOVER_SERVICE_HOST/distribution/metadata/aaf-metadata-cert.pem"
	$AAF_METADATA_DOCUMENT_URL="https://$DISCOVER_SERVICE_HOST/distribution/metadata/metadata.aaf.signed.minimal.xml"
	$DISCOVERY_SERVICE_URL="https://$DISCOVER_SERVICE_HOST/discovery/DS"
	$FR_CREATE_SP_LINK = "https://manager.aaf.edu.au/federationregistry/registration/sp"
} elsif ($ENVIRONMENT_TYPE == 'test') {
	$DISCOVER_SERVICE_HOST="ds.test.aaf.edu.au"
	$AAF_METADATA_CERTIFICATE_URL="https://$DISCOVER_SERVICE_HOST/distribution/metadata/aaf-metadata-cert.pem"
	$AAF_METADATA_DOCUMENT_URL="https://$DISCOVER_SERVICE_HOST/distribution/metadata/metadata.aaf.signed.minimal.xml"
	$DISCOVERY_SERVICE_URL="https://$DISCOVER_SERVICE_HOST/discovery/DS"
	$FR_CREATE_SP_LINK = "https://manager.test.aaf.edu.au/federationregistry/registration/sp"
} else {
	$DISCOVER_SERVICE_HOST="FIX_ME"
	$AAF_METADATA_CERTIFICATE_URL="FIX_ME"
	$AAF_METADATA_DOCUMENT_URL="FIX_ME"
	$DISCOVERY_SERVICE_URL="FIX_ME"
	$FR_CREATE_SP_LINK="FIX_ME"
} # End if.


# Set tags based on service provider software type.
if ($SERVICE_PROVIDER_SOFTWARE_TYPE == 'shibboleth') {
	$SP_SSL_CERT_PATH = "/etc/shibboleth/sp-cert.pem"
	$SP_SOFTWARE_TYPE_STRING = "Shibboleth Service Provider (2.4.x)"
} else {
	# Unsupported sp software type.
} # End if.

# Handy client debugging output.
notify{"ENVIRONMENT_TYPE:${ENVIRONMENT_TYPE}": }
notify{"SERVICE_PROVIDER_ENTITY_ID:${SERVICE_PROVIDER_ENTITY_ID}": }
notify{"SERVICE_PROVIDER_SSL_CERT_CN:${SERVICE_PROVIDER_SSL_CERT_CN}": }
notify{"SERVICE_PROVIDER_SOFTWARE_TYPE:${SERVICE_PROVIDER_SOFTWARE_TYPE}": }
notify{"WEB_SERVER_SOFTWARE_TYPE:${WEB_SERVER_SOFTWARE_TYPE}": }
notify{"INSTALL_NTP_CLIENT:${INSTALL_NTP_CLIENT}": }
notify{"DISCOVER_SERVICE_HOST:${DISCOVER_SERVICE_HOST}": }
notify{"AAF_METADATA_CERTIFICATE_URL:${AAF_METADATA_CERTIFICATE_URL}": }
notify{"AAF_METADATA_DOCUMENT_URL:${AAF_METADATA_DOCUMENT_URL}": }
notify{"DISCOVERY_SERVICE_URL:${DISCOVERY_SERVICE_URL}": }
notify{"FR_CREATE_SP_LINK:${FR_CREATE_SP_LINK}": }
