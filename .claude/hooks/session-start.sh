#!/bin/bash
set -euo pipefail

# Only run in remote Claude Code environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Ensure tasks directory and lessons.md exist
mkdir -p "$CLAUDE_PROJECT_DIR/tasks"

if [ ! -f "$CLAUDE_PROJECT_DIR/tasks/lessons.md" ]; then
  cat > "$CLAUDE_PROJECT_DIR/tasks/lessons.md" << 'LESSONS'
# Lessons Learned

Format : `[YYYY-MM-DD] | ce qui s'est mal passé | règle à suivre la prochaine fois`

<!-- Les entrées sont ajoutées ici après chaque correction de l'utilisateur. -->
LESSONS
fi

echo "Session start hook completed."
