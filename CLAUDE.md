# CLAUDE.md

## SELF-LEARNING

### Principe
Claude apprend de ses erreurs au fil des sessions grâce à un journal de leçons.

### Règles

1. **Après chaque correction** : dès qu'une correction est apportée par l'utilisateur, ajouter immédiatement une entrée dans `tasks/lessons.md` au format :
   ```
   [YYYY-MM-DD] | ce qui s'est mal passé | règle à suivre la prochaine fois
   ```

2. **Au début de chaque session** : lire `tasks/lessons.md` en entier avant toute action sur le code.

3. **Avant de toucher au code** : appliquer chaque règle listée dans `tasks/lessons.md`.

## SKILLS RUFLO

Les plugins RuFlo (`ruflo-core`, `ruflo-swarm`, `ruflo-rag-memory`) sont
installés et activés dans ce projet.

**Règle permanente** : dès qu'un skill RuFlo serait pertinent pour la tâche en
cours, le **proposer** (sans l'imposer ni l'invoquer d'office). Attention
particulière à :

- **swarm** (`/ruflo-swarm:swarm`, `swarm-init`, `watch`) — proposer pour les
  tâches grosses, parallélisables ou décomposables en sous-tâches confiables à
  une équipe d'agents.
- **memory / recall** (`/ruflo-rag-memory:recall`, `ruflo-memory`,
  `memory-search`) — proposer pour stocker ou retrouver du contexte
  (décisions, patterns, historique) entre sessions.
- Les autres skills RuFlo (`ruflo-doctor`, `ruflo-status`, `init-project`,
  `discover-plugins`, `witness`, `monitor-stream`, `memory-bridge`…) — proposer
  celui qui colle au besoin du moment.

## STYLE — PARLER COMME UN HUMAIN

Toujours appliquer le skill `stop-slop` (voir `.claude/skills/stop-slop/SKILL.md`)
à chaque réponse : aller droit au but, bannir les formules d'IA et la flatterie,
éviter le hedging et les listes à puces systématiques, garder un ton humain et direct.
