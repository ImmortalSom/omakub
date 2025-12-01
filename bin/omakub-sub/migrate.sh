#!/bin/bash

cd "$OMAKUB_PATH" || true
last_updated_at=$(git log -1 --format=%cd --date=unix)
git pull

for file in "$OMAKUB_PATH/migrations/"*.sh; do
    filename=$(basename "$file")
    migrate_at="${filename%.sh}"

    if [ "$migrate_at" -gt "$last_updated_at" ]; then
        echo "Running migration for $migrate_at"
        # shellcheck  source=/dev/null
        source "$file"
    fi
done

cd - || true
