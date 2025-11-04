

# Setup
1. edit deploy.sh, add env variables
2. run ./deploy.sh
3. add CloudRun path to keycloack => path: Clients - Apigee-test-client - Setting -  Valid Redirect URIs 
4. add CloudRun payh to Apigee-proxy - policy: AM-login-keycloack.xml, redirect_uri:

```
      <Header name="Location">
        https://34.132.87.216:8443/auth/realms/MCP/protocol/openid-connect/auth?response_type=code&amp;client_id=apigee-test-client&amp;redirect_uri=https%3A%2F%2Fkeycloak-test-login-908295356148.us-west1.run.app%2Fcallback&amp;scope=openid%20Auc.FullAccess&amp;state=someRandomCsrfToken
      </Header>
```
    