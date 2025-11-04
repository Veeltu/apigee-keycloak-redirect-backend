#!/bin/bash

AUTH_CODE=""
CLIENT_ID="apigee-test-client"
CLIENT_SECRET=""
KEYCLOAK_URL=""
REALM="MCP"
    
# 1. get token
RESPONSE=$(curl -sk \
  "${KEYCLOAK_URL}/keycloak-test/callback?auth-code=${AUTH_CODE}&client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}")

ACCESS_TOKEN=$(echo "$RESPONSE" | jq -r '.token_response.access_token')

# 2. use token to call /backend
BACKEND_RESPONSE=$(curl -sk \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  "${KEYCLOAK_URL}/keycloak-test/backend") # "/verify" is also available for only token validation

echo "Backend raw response: $BACKEND_RESPONSE"

echo "Parsed backend response:"
echo "$BACKEND_RESPONSE" | jq

