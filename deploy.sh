#!/usr/bin/env bash
set -euo pipefail

# Configuration
# Required: set these or pass as env vars before running, e.g.:
#   PROJECT_ID=my-project REGION=europe-west1 SERVICE_NAME=callback ./deploy.sh
PROJECT_ID=intense-plate-472904-r9
REGION=us-west1
SERVICE_NAME=keycloak-test-login
APIGEE_URL=https://34-160-172-219.nip.io/

if [[ -z "${PROJECT_ID}" ]]; then
  echo "Error: PROJECT_ID is required (export PROJECT_ID=...)" >&2
  exit 1
fi

if ! command -v gcloud >/dev/null 2>&1; then
  echo "Error: gcloud CLI not found. Install from https://cloud.google.com/sdk" >&2
  exit 1
fi

echo "Using project: ${PROJECT_ID}" 
gcloud config set project "${PROJECT_ID}" >/dev/null

echo "Deploying service '${SERVICE_NAME}' to Cloud Run (region: ${REGION})..."

# Deploy from source using Cloud Build and Dockerfile in the repo
gcloud run deploy "${SERVICE_NAME}" \
  --source . \
  --region "${REGION}" \
  --platform managed \
  --allow-unauthenticated \
  --quiet \
  --set-env-vars APIGEE_URL="${APIGEE_URL}"

echo "Deployment completed. Fetching service URL..."

SERVICE_URL=$(gcloud run services describe "${SERVICE_NAME}" \
  --region "${REGION}" \
  --format='value(status.url)')

echo "Service URL: ${SERVICE_URL}"


