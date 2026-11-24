#!/usr/bin/env bash
# Deploy der Seite (site/) auf den Staging-Server.
# Aufruf: ./deploy.sh
# Konfiguration per Umgebungsvariablen, Defaults siehe unten.
set -euo pipefail

cd "$(dirname "$0")"

DEPLOY_HOST="${DEPLOY_HOST:-staging.nca-demo.internal}"
DEPLOY_USER="${DEPLOY_USER:-deploy}"
DEPLOY_PATH="${DEPLOY_PATH:-/var/www/nca-demo}"
DEPLOY_KEY="${DEPLOY_KEY:-$HOME/.ssh/deploy_key}"

log()  { printf '[deploy] %s\n' "$*"; }
fail() { printf '[deploy] FEHLER: %s\n' "$*" >&2; exit 1; }

log "Prüfe Build-Verzeichnis"
[ -d site ] || fail "Verzeichnis site/ fehlt"
[ -f site/index.html ] || fail "site/index.html fehlt"

log "Prüfe Deploy-Key ${DEPLOY_KEY}"
if ! head -c 1 "$DEPLOY_KEY" >/dev/null 2>&1; then
  fail "Deploy-Key nicht lesbar: ${DEPLOY_KEY}"
fi

log "Übertrage site/ nach ${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH}"
rsync -az --delete \
  -e "ssh -i ${DEPLOY_KEY} -o BatchMode=yes -o ConnectTimeout=5" \
  site/ "${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH}/"

log "Fertig"
