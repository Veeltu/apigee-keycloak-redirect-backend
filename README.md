## Callback demo (Flask + Cloud Run)

A minimal Flask app exposing endpoints: `/`, `/healthz`, `/login`, `/callback`. The `/login` endpoint issues a 302 redirect to Keycloak/Apigee based on the `APIGEE_URL` environment variable.

### Required environment variables
- **APIGEE_URL**: Base URL of Apigee/Keycloak, without a trailing slash.
  - Example: `https://34-160-172-219.nip.io`

### Run locally
1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
2. Set `APIGEE_URL` and start the app:
   ```bash
   export APIGEE_URL="https://34-160-172-219.nip.io"
   python app.py
   ```
3. Endpoints:
   - `GET /` → OK
   - `GET /healthz` → ok
   - `GET /login` → 302 to `${APIGEE_URL}/keycloak-test/login`
   - `GET /callback?code=...` → echoes the authorization code

### Docker
```bash
docker build -t callback:local .
docker run --rm -p 8080:8080 -e APIGEE_URL="https://34-160-172-219.nip.io" callback:local
```

### Deploy to Cloud Run (GCP)
The `deploy.sh` script builds and deploys the service.

- Variables (can be overridden via environment):
  - `PROJECT_ID` – GCP project ID
  - `REGION` – Cloud Run region (e.g., `us-west1`)
  - `SERVICE_NAME` – Cloud Run service name
  - `APIGEE_URL` – see above (no trailing `/`)

Run:
```bash
./deploy.sh
```

After deployment, take the service URL from the script output and:
- add it in Keycloak under `Clients → Apigee-test-client → Settings → Valid Redirect URIs` (e.g., `https://<service-url>/callback`),
- update the redirect in Apigee (policy `AM-login-keycloack.xml`, `redirect_uri` should point to `/callback`).

Example `Location` header (excerpt):
```
<Header name="Location">
  https://34.132.87.216:8443/auth/realms/MCP/protocol/openid-connect/auth?response_type=code&client_id=apigee-test-client&redirect_uri=https%3A%2F%2Fkeycloak-test-login-908295356148.us-west1.run.app%2Fcallback&scope=openid%20Auc.FullAccess&state=someRandomCsrfToken
</Header>
```

### Troubleshooting
- Double slash in redirect (`//keycloak-test/login`): remove the trailing `/` from `APIGEE_URL` or ensure the app trims it.
- 404 after login: verify `Valid Redirect URIs` in Keycloak and `redirect_uri` in Apigee — both must target the Cloud Run service `/callback`.

### Changelog
- 2025-11-04: Expanded README with `APIGEE_URL` config, local/Docker/Cloud Run instructions, and integration notes. 