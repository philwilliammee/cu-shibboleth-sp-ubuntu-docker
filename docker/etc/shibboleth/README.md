# The cert files in this folder were created with the following command:


```bash
shib-keygen -h localhost && openssl x509 -text -noout -in /etc/shibboleth/sp-cert.pem

RUN shib-keygen -u _shibd -h localhost -e https://localhost/shibboleth -n sp-signing
RUN shib-keygen -u _shibd -h localhost -e https://localhost/shibboleth -n sp-encrypt
```

see https://confluence.cornell.edu/display/SHIBBOLETH/Install+Shibboleth+Service+Provider+on+Linux#expander-control-875416119 for more details.
