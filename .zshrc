set -o noclobber
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions you-should-use zsh-bat)
source $ZSH/oh-my-zsh.sh

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/tokyo-nebula.omp.json)"

# ── Homebrew ──────────────────────────────────────────────────────────────────
eval "$(/opt/homebrew/bin/brew shellenv)"

# ── node version manager (nvm) ────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# ── pyenv ─────────────────────────────────────────────────────────────────────
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# ── Go ────────────────────────────────────────────────────────────────────────
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

# ── Bun ───────────────────────────────────────────────────────────────────────
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ── Rust / Cargo ──────────────────────────────────────────────────────────────
export PATH="$HOME/.cargo/bin:$PATH"

# ── Local bin ─────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Antigravity ───────────────────────────────────────────────────────────────
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# ── Ghostty ───────────────────────────────────────────────────────────────────
export PATH="/Applications/Ghostty.app/Contents/MacOS:$PATH"

# ── Package managers ──────────────────────────────────────────────────────────
export PATH="/opt/pkg/env/active/bin:/opt/pmk/env/global/bin:$PATH"

# ── OrbStack ──────────────────────────────────────────────────────────────────
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# ── zoxide (replaces cd) ──────────────────────────────────────────────────────
eval "$(zoxide init zsh --cmd cd)"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ── Ghostty per-project tab tinting ───────────────────────────────────────────
# [[ -f ~/.config/ghostty/ghostty-colors.zsh ]] && source ~/.config/ghostty/ghostty-colors.zsh


# Added by Antigravity CLI installer
export PATH="/Users/juppy/.local/bin:$PATH"

# Use the Nplus Claude Code config when inside ~/Nplus (any subdir); default elsewhere
claude() {
  case "$PWD/" in
    "$HOME"/Nplus/*)
      CLAUDE_CONFIG_DIR="$HOME/.claude-nplus" command claude "$@" ;;
    *)
      command claude "$@" ;;
  esac
}
