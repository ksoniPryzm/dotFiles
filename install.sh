#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)"
BACKUP_CREATED=0

joinHomePath() {
    local prefix="$1"
    local suffix="$2"

    if [ -z "$suffix" ]; then
        printf '%s/%s\n' "$HOME" "$prefix"
    else
        printf '%s/%s/%s\n' "$HOME" "$suffix" "$prefix"
    fi
}

ensureBackupDir() {
    if [ "$BACKUP_CREATED" -eq 0 ]; then
        mkdir -p "$BACKUP_DIR"
        BACKUP_CREATED=1
        echo "[INFO] Backing up replaced files to $BACKUP_DIR"
    fi
}

backupExisting() {
    local destination="$1"
    local relative_path backup_path

    ensureBackupDir

    relative_path="${destination#"$HOME"/}"
    backup_path="$BACKUP_DIR/$relative_path"

    mkdir -p "$(dirname "$backup_path")"
    mv "$destination" "$backup_path"
    echo "[BACKUP] $destination -> $backup_path"
}

symlinkFile() {
    local source_rel="$1"
    local destination_root="$2"
    local filename destination

    filename="$SCRIPT_DIR/$source_rel"
    destination="$(joinHomePath "$source_rel" "$destination_root")"

    mkdir -p "$(dirname "$destination")"

    if [ -L "$destination" ]; then
        if [ "$(readlink "$destination")" = "$filename" ]; then
            echo "[WARNING] $destination already points to $filename"
            return
        fi

        backupExisting "$destination"
    elif [ -e "$destination" ]; then
        backupExisting "$destination"
    fi

    ln -s "$filename" "$destination"
    echo "[OK] $filename -> $destination"
}

deployManifest() {
    local manifest_path="$SCRIPT_DIR/$1"
    local row filename operation destination

    while IFS= read -r row || [ -n "$row" ]; do
        if [[ -z "$row" || "$row" =~ ^#.* ]]; then
            continue
        fi

        IFS='|' read -r filename operation destination <<< "$row"

        case "$operation" in
            symlink)
                symlinkFile "$filename" "$destination"
                ;;

            *)
                echo "[WARNING] Unknown operation $operation. Skipping..."
                ;;
        esac
    done < "$manifest_path"
}

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <MANIFEST>"
    echo "ERROR: no MANIFEST file is provided"
    exit 1
fi

deployManifest "$1"
