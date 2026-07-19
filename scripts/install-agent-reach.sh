#!/usr/bin/env bash
#
# install-agent-reach.sh — installe Agent Reach sur TA machine (macOS ou Linux).
#
# À lancer sur ton laptop ou un VPS à egress ouvert — PAS dans un conteneur
# Claude Code distant (github.com y est bloqué, l'install échoue).
#
# Usage :
#   bash install-agent-reach.sh                 # install de base
#   bash install-agent-reach.sh twitter,reddit  # + canaux optionnels
#   CHANNELS=all bash install-agent-reach.sh     # tout
#
set -euo pipefail

# Canaux optionnels : 1er argument, ou variable CHANNELS, sinon aucun.
CHANNELS="${1:-${CHANNELS:-}}"

say()  { printf '\n\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; exit 1; }

# ── 1. Python 3.10+ ─────────────────────────────────────────────
say "Vérification de Python 3.10+"
PY=""
for c in python3.12 python3.11 python3.10 python3 python; do
  if command -v "$c" >/dev/null 2>&1; then
    if "$c" -c 'import sys; raise SystemExit(0 if sys.version_info>=(3,10) else 1)' 2>/dev/null; then
      PY="$c"; break
    fi
  fi
done
[ -n "$PY" ] || die "Python 3.10+ introuvable. Installe-le (brew install python / apt install python3) puis relance."
echo "Python OK : $("$PY" --version)"

# ── 2. pipx (isole le CLI, recommandé par le projet) ────────────
say "Vérification de pipx"
if ! command -v pipx >/dev/null 2>&1; then
  warn "pipx absent — installation dans l'espace utilisateur"
  "$PY" -m pip install --user --upgrade pipx
  "$PY" -m pipx ensurepath
  # Rendre pipx dispo dans CE shell sans rouvrir un terminal.
  export PATH="$HOME/.local/bin:$PATH"
fi
command -v pipx >/dev/null 2>&1 || die "pipx toujours introuvable. Ouvre un nouveau terminal (PATH mis à jour) et relance."
echo "pipx OK : $(pipx --version)"

# ── 3. Installer le CLI agent-reach ─────────────────────────────
# Pas sur PyPI → on installe depuis l'archive GitHub (main).
say "Installation d'agent-reach (depuis GitHub)"
if command -v agent-reach >/dev/null 2>&1; then
  warn "Déjà installé — mise à jour"
  pipx install --force "https://github.com/Panniantong/agent-reach/archive/main.zip"
else
  pipx install "https://github.com/Panniantong/agent-reach/archive/main.zip"
fi
echo "agent-reach OK : $(agent-reach --version)"

# ── 4. Install auto (gh CLI, node/mcporter, Exa, yt-dlp…) ───────
# --env=auto détecte local vs serveur. Ajoute --safe si tu veux
# qu'il te dise quoi faire au lieu de modifier le système lui-même.
say "agent-reach install --env=auto"
if [ -n "$CHANNELS" ]; then
  echo "Canaux optionnels demandés : $CHANNELS"
  agent-reach install --env=auto --channels="$CHANNELS"
else
  agent-reach install --env=auto
fi

# ── 5. Bilan santé (les fameux checks verts) ────────────────────
say "agent-reach doctor"
agent-reach doctor || true

# ── 6. Rappels cookies (à faire TOI, navigateur connecté) ───────
cat <<'EOF'

──────────────────────────────────────────────────────────────
Canaux qui marchent sans login : Web, YouTube, GitHub, LinkedIn
public, RSS, et Twitter/X en lecture basique.

Canaux qui demandent un cookie de session (navigateur connecté) :

  Twitter/X   Cookie-Editor sur x.com → Export → Header String →
              agent-reach configure twitter-cookies "<collé>"
  Reddit      rdt login   (extrait le cookie du navigateur tout seul)
  XiaoHongShu xhs login    (ou agent-reach configure xhs-cookies "<collé>")
  Xueqiu      Cookie-Editor sur xueqiu.com → Export → coller
  Bilibili    Cookie-Editor sur bilibili.com → Export → coller

Facebook / Instagram : passent par OpenCLI, qui pilote ton Chrome
de BUREAU déjà connecté (desktop uniquement, pas de cookie collé).

Astuce : sur ta machine locale avec Chrome connecté, l'extraction
des cookies est automatique :
  agent-reach configure --from-browser chrome
──────────────────────────────────────────────────────────────
EOF

say "Terminé."
