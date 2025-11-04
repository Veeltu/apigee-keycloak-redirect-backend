from flask import Flask, request, redirect, Response, jsonify
import os
import requests
import datetime

app = Flask(__name__)

# Opcjonalny login redirect - APIGEE_URL możesz ustawić przez zmienne środowiskowe
APIGEE_URL = os.environ.get("APIGEE_URL")
KEYCLOAK_JWKS_URL = os.environ.get(
    "KEYCLOAK_JWKS_URL",
    "https://34.132.87.216:8443/auth/realms/MCP/protocol/openid-connect/certs"
)

@app.route("/backend", methods=["POST", "GET"])
def check_token():
    token = request.headers.get('Authorization', 'not_provided')
    # Just as demonstration, extract IP address
    client_ip = request.headers.get('X-Forwarded-For', request.remote_addr)
    now = datetime.datetime.utcnow().isoformat() + "Z"
    payload = {
        "token_validated": True,
        "received_token": token,
        "request_method": request.method,
        "client_ip": client_ip,
        "timestamp": now,
        "backend_info": "This is a Google Cloud Run mock backend for token checking. All data is synthetic."
    }
    return jsonify(payload)

@app.route('/jwks')
def jwks_proxy():
    resp = requests.get(KEYCLOAK_JWKS_URL, verify=False)
    return Response(resp.content, status=resp.status_code, content_type=resp.headers.get("content-type", "application/json"))

@app.route('/login')
def login():
    return redirect(f"{APIGEE_URL}/keycloak-test/login", code=302)

@app.route('/')
def root():
    return "OK", 200

@app.route('/healthz')
def healthz():
    return "ok", 200

@app.route('/callback')
def callback():
    code = request.args.get('code')
    return f"Authorization code: {code}"

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 8080))
    app.run(host='0.0.0.0', port=port)
