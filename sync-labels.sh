#!/usr/bin/env bash
# Crea o actualiza en todos los repos de la organización las etiquetas de labels.json. No borra ninguna.
# Uso: ./sync-labels.sh [repo ...]   (sin argumentos: todos los repos no archivados). Necesita gh y python3.
set -euo pipefail
ORG=ELITE-SPORTS-17-PROJECTS
cd "$(dirname "$0")"
repos=("$@")
[ ${#repos[@]} -eq 0 ] && mapfile -t repos < <(gh repo list $ORG --no-archived --limit 200 --json name --jq '.[].name')
mapfile -t labels < <(python3 -c 'import json; [print(l["name"], l["color"], l["description"], sep="\t") for l in json.load(open("labels.json"))]')
for r in "${repos[@]}"; do
  for l in "${labels[@]}"; do
    IFS=$'\t' read -r name color desc <<<"$l"
    gh label create "$name" -R "$ORG/$r" --force --color "$color" --description "$desc" >/dev/null
  done
  echo "$r"
done
