#!/usr/bin/env bash
# Crea o actualiza en todos los repos de la organización las etiquetas de labels.json. No borra ninguna.
# Uso: ./sync-labels.sh [repo ...]   (sin argumentos: todos los repos no archivados)
set -euo pipefail
ORG=ELITE-SPORTS-17-PROJECTS
cd "$(dirname "$0")"
repos=("$@")
[ ${#repos[@]} -eq 0 ] && mapfile -t repos < <(gh repo list $ORG --no-archived --limit 200 --json name --jq '.[].name')
for r in "${repos[@]}"; do
  jq -c '.[]' labels.json | while read -r l; do
    gh label create "$(jq -r .name <<<"$l")" -R "$ORG/$r" --force \
      --color "$(jq -r .color <<<"$l")" --description "$(jq -r .description <<<"$l")" >/dev/null
  done
  echo "$r"
done
