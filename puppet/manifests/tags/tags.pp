# Think of tags as global constants available to all other Puppet manifest files.

# The certificate used for signing the AAF metadata document.
$AAF_METADATA_SIGNING_CERT_PROD = 'https://ds.aaf.edu.au/distribution/metadata/aaf-metadata-cert.pem'
$AAF_METADATA_SIGNING_CERT_TEST = 'https://ds.test.aaf.edu.au/distribution/metadata/aaf-metadata-cert.pem'

# The URL of the AAF discovery service.
$AAF_DISCOVERY_SERIVCE_URL_PROD = 'https://ds.aaf.edu.au/discovery/DS'
$AAF_DISCOVERY_SERIVCE_URL_TEST = 'https://ds.test.aaf.edu.au/discovery/DS'
