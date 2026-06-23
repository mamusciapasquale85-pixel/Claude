#!/bin/bash
# SessionStart hook — relance l'infra RuFlo runtime à chaque démarrage.
#
# La VM cloud est éphémère : config et plugins reviennent via le dépôt
# (.claude/settings.json + .mcp.json + claude-flow.config.json), mais le
# daemon est un PROCESSUS et ne survit pas au snapshot. On le relance ici.
#
# Cloud uniquement : CLAUDE_CODE_REMOTE=true dans les sessions web.
# Le hook tourne aussi en local, où l'on ne veut rien démarrer d'office.

set -u

# Ne rien faire hors environnement cloud.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Daemon déjà actif ? On ne relance pas.
if npx --no-install @claude-flow/cli@latest daemon status >/dev/null 2>&1; then
  exit 0
fi

# Démarrage non bloquant : le téléchargement du modèle ONNX peut être long,
# on ne veut pas ralentir le démarrage de la session.
( npx -y @claude-flow/cli@latest daemon start >/dev/null 2>&1 & ) || true

exit 0
