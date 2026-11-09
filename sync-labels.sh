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
    for try in 1 2 3; do  # la API devuelve algún 500 suelto
      gh label create "$name" -R "$ORG/$r" --force --color "$color" --description "$desc" >/dev/null && break
      [ $try = 3 ] && exit 1; sleep 3
    done
  done
  echo "$r"
done
