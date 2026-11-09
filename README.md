# .github

Plantillas y etiquetas comunes a todos los repos de ELITE-SPORTS-17-PROJECTS.

- `ISSUE_TEMPLATE/` y `pull_request_template.md`: GitHub las usa en cualquier repo de la organización que no tenga las
  suyas. Solo funciona si este repo es **público**, así que aquí no va nada privado.
- `labels.json` y `sync-labels.sh`: etiquetas comunes. Tras cambiar `labels.json` o crear un repo, `./sync-labels.sh`
  (o `./sync-labels.sh <repo>`). Crea o actualiza; nunca borra.
- El tablero de la organización se sincroniza desde `qa-hub` (`tools/board_sync.py`).
