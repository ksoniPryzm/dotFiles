# dotFiles

Personal dotfiles managed through a simple manifest-driven installer.

## Install

Clone the repo and run the installer with the included manifest:

```bash
git clone <repo-url> ~/dotFiles
cd ~/dotFiles
bash install.sh MANIFEST
```

The installer creates symlinks from files in this repo into your home directory.

## Windows Setup

If you want to use this setup on Windows, use a Unix-like environment instead of running the installer directly in native Windows shell tools.

Recommended setup:

- Install `WSL` and use that as the environment where you clone this repo and run `install.sh`.
- Install `Alacritty` as the terminal emulator on the Windows side.
- Install `Kinto` if you want more consistent keyboard mappings between macOS, Windows, and Linux.

Suggested flow:

1. Install `WSL` and your preferred Linux distribution.
2. Open the WSL shell and clone this repo there.
3. Run `bash install.sh MANIFEST` from inside WSL.
4. Use `Alacritty` to launch into your WSL environment.

## Backups

If the installer finds an existing config at a target path, it now moves that file or directory into a timestamped backup directory before creating the symlink.

Backup directories are created under:

```bash
~/.dotfiles-backups/<timestamp>
```

This keeps the install non-destructive while preserving the previous state for manual rollback if needed.
