#!/usr/bin/env bash
set -Eeuo pipefail

IMAGE_REF="${1:?Usage: deploy_prod.sh <image-ref>}"
CONTAINER_NAME="${CONTAINER_NAME:-intranet-newdeal}"
HOST_PORT="${HOST_PORT:-80}"
CONTAINER_PORT="${CONTAINER_PORT:-80}"

echo "[deploy] Pull de l'image ${IMAGE_REF}"
docker pull "${IMAGE_REF}"

if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}$"; then
  echo "[deploy] Suppression de l'ancien conteneur ${CONTAINER_NAME}"
  docker rm -f "${CONTAINER_NAME}"
fi

echo "[deploy] Démarrage du nouveau conteneur ${CONTAINER_NAME}"
docker run -d \
  --name "${CONTAINER_NAME}" \
  --restart unless-stopped \
  -p "${HOST_PORT}:${CONTAINER_PORT}" \
  "${IMAGE_REF}"

echo "[deploy] Vérification de l'état du conteneur"
docker ps --filter "name=${CONTAINER_NAME}" --filter "status=running"
