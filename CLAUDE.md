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
