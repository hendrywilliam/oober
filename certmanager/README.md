# cert-manager

Apply `test.yaml` resource to validate cert manager installation.

# ACME Challenge Solver

### http01
CA will validate the file that contains token, and thumbprint of account key. If validation fails we have to renew certificate.
Cant be used to issue wildcard certs (asterisk subdomains).
Easiest way to issue a certificate (without having an extra knowledge about domain configuration).

### dns01
Need to put a specific value in TXT Record under our domain.
Allow issue wildcard certificates.
Works on multiple web servers.
Need to work on security to handle API credentials.
