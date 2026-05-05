# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# Resolve the real location of this file (works even when symlinked)
DOTFILES="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# Environment variables
source "$DOTFILES/envs"

# Shell settings (history, PATH, completion)
source "$DOTFILES/shell"

# --- oh-my-bash ---
export OSH="$HOME/.oh-my-bash"
OSH_THEME="powerline"
OMB_USE_SUDO=true

completions=(
  git
  composer
  ssh
)

aliases=(
  general
)

plugins=(
  git
  bashmarks
)

if [ "$DISPLAY" ] || [ "$SSH" ]; then
  plugins+=(tmux-autoattach)
fi

source "$OSH/oh-my-bash.sh"
# ------------------

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Rust/Cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Aliases and functions
source "$DOTFILES/aliases"
source "$DOTFILES/functions"

# Tool initializations (mise, starship, zoxide, fzf)
# Note: starship in init will override the oh-my-bash prompt if installed
source "$DOTFILES/init"
