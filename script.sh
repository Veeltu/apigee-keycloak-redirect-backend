#!/bin/bash

AUTH_CODE="440f851f-070c-4e61-b25b-df19f5a25ca1.1340ea63-0b6f-454e-8033-a0fa75ca375f.3e24b5bc-ec43-489f-85f0-fc2f3dcc57bb"
CLIENT_ID="apigee-test-client"
CLIENT_SECRET="14f80f62-dc74-4399-896f-3bbe06f5531b"

# 1. get token
RESPONSE=$(curl -sk \
  "https://34-160-172-219.nip.io/keycloak-test/callback?auth-code=${AUTH_CODE}&client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}")

ACCESS_TOKEN=$(echo "$RESPONSE" | jq -r '.token_response.access_token')

# 2. use token to call /backend
BACKEND_RESPONSE=$(curl -sk \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  "https://34-160-172-219.nip.io/keycloak-test/backend") # "/verify" is also available for only token validation

echo "Backend raw response: $BACKEND_RESPONSE"

echo "Parsed backend response:"
echo "$BACKEND_RESPONSE" | jq

