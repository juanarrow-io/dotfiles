# ghostty-colors.zsh — Auto-tint Ghostty tabs by project or SSH host
#
# zsh port of ewilderj's ghostty-colors.bash.
# Projects under any root in _GTC_ROOTS get cool-toned background tints.
# SSH sessions get warm-toned tints. Colors are deterministic.
#
# Only activates inside Ghostty (or a capable terminal / remote session).

# Activate in Ghostty (local) or any capable terminal (remote/SSH)
case "$TERM" in
  xterm-ghostty|xterm*|screen*|tmux*) ;;
  *) [[ -z "$GHOSTTY_RESOURCES_DIR" ]] && return ;;
esac

# ---------------------------------------------------------------------------
# Project roots — any dir BELOW one of these gets a per-project tint,
# keyed by "<root-name>/<top-level-folder>" so same-named folders in
# different roots get distinct colors.
# ---------------------------------------------------------------------------

_GTC_ROOTS=(
  "$HOME/projects"
  "$HOME/nplus"
  "$HOME/pacsafe"
  "$HOME/tools"
)

# ---------------------------------------------------------------------------
# Palette — subtle dark tints that pair well with Dracula
# ---------------------------------------------------------------------------

_GTC_PROJECT_COLORS=(
  "#1e2535"  "#1e2d2d"  "#261e35"  "#1e3526"
  "#2d1e2d"  "#1e2d35"  "#2d2d1e"  "#1e352d"
  "#2d1e35"  "#1e3535"  "#241e35"  "#1e3530"
)

_GTC_SSH_COLORS=(
  "#352222"  "#352d1e"  "#35261e"  "#2d2222"
  "#352c1e"  "#2d1e1e"  "#352d24"  "#351e1e"
)

_GTC_PROJECT_DOTS=( 🔷 🍀 🔮 🌰 ⭐ 💎 🌿 🌕 🪻 🧊 🎯 🍃 )
_GTC_SSH_DOTS=(    🔥 🍊 🌅 🌹 🌻 🍒 🥧 ♦️ )

_GTC_DEFAULT_BG="#282a36"
_GTC_CURRENT_TITLE=""
_GTC_SSH_ACTIVE=""

# ---------------------------------------------------------------------------
# Internals
# ---------------------------------------------------------------------------

# djb-ish hash: h = (h*31 + char) % 65536. Matches the bash version.
# NOTE: relies on default zsh 1-based string indexing (no KSH_ARRAYS).
_gtc_hash() {
  local s="$1" h=0 i c
  for (( i=1; i<=${#s}; i++ )); do
    c=$(printf '%d' "'${s[i]}")
    h=$(( (h * 31 + c) % 65536 ))
  done
  echo $h
}

# Which root (if any) contains $PWD? Echoes the root path, or nothing.
_gtc_match_root() {
  local r
  for r in $_GTC_ROOTS; do
    [[ "$PWD" == "$r"/* ]] && { echo "$r"; return 0; }
  done
  return 1
}

# Human-readable path for the tab title.
_gtc_short_cwd() {
  local r
  for r in $_GTC_ROOTS; do
    if [[ "$PWD" == "$r"/* ]]; then
      echo "${r:t}/${PWD#$r/}"
      return
    fi
  done
  if [[ "$PWD" == "$HOME" ]]; then
    echo "~"
  elif [[ "$PWD" == "$HOME"/* ]]; then
    echo "~${PWD#$HOME}"
  else
    echo "$PWD"
  fi
}

# Set background tint (OSC 11) + tab title (OSC 2).
_gtc_set() {
  printf '\033]11;%s\007' "$1"
  printf '\033]2;%s\007' "$2"
  _GTC_CURRENT_TITLE="$2"
}

# Prefix for tab titles — includes hostname when in an SSH session.
if [[ -n "$SSH_CONNECTION" ]]; then
  local _gtc_hn="${HOSTNAME:-$HOST}"
  _GTC_HOST_PREFIX="${_gtc_hn%%.*}: "
  unset _gtc_hn
else
  _GTC_HOST_PREFIX=""
fi

_gtc_reset() {
  local title="${_GTC_HOST_PREFIX}$(_gtc_short_cwd)"
  printf '\033]11;%s\007' "$_GTC_DEFAULT_BG"
  printf '\033]2;%s\007' "$title"
  _GTC_CURRENT_TITLE="$title"
}

# ---------------------------------------------------------------------------
# Project coloring — called from precmd
# ---------------------------------------------------------------------------

_gtc_prompt() {
  [[ -n "$_GTC_SSH_ACTIVE" ]] && return

  local root
  root="$(_gtc_match_root)"
  if [[ -n "$root" ]]; then
    local rel="${PWD#$root/}"
    local project="${root:t}/${rel%%/*}"
    local h idx dot
    h=$(_gtc_hash "$project")
    idx=$(( h % ${#_GTC_PROJECT_COLORS[@]} + 1 ))   # zsh arrays are 1-based
    dot="${_GTC_PROJECT_DOTS[idx]}"
    _gtc_set "${_GTC_PROJECT_COLORS[idx]}" "$dot ${_GTC_HOST_PREFIX}$(_gtc_short_cwd)"
  else
    _gtc_reset
  fi

  # Re-assert title (handles programs that overwrote it)
  [[ -n "$_GTC_CURRENT_TITLE" ]] && printf '\033]2;%s\007' "$_GTC_CURRENT_TITLE"
}

# ---------------------------------------------------------------------------
# SSH coloring — wraps ssh
# ---------------------------------------------------------------------------

ssh() {
  local host="" skip=false arg
  for arg in "$@"; do
    if $skip; then skip=false; continue; fi
    case "$arg" in
      -[bcDEeFIiJLlmOopQRSWw]) skip=true ;;
      -*) ;;
      *@*) host="${arg#*@}"; break ;;
      *)   [[ -z "$host" ]] && host="$arg"; break ;;
    esac
  done

  if [[ -n "$host" ]]; then
    local short="${host%%.*}"
    local h idx dot
    h=$(_gtc_hash "$short")
    idx=$(( h % ${#_GTC_SSH_COLORS[@]} + 1 ))       # zsh arrays are 1-based
    dot="${_GTC_SSH_DOTS[idx]}"
    _GTC_SSH_ACTIVE="$short"
    _gtc_set "${_GTC_SSH_COLORS[idx]}" "$dot $short"
  fi

  command ssh "$@"
  local ret=$?
  _GTC_SSH_ACTIVE=""
  _gtc_prompt
  return $ret
}

# ---------------------------------------------------------------------------
# Hook into precmd + initial apply
# ---------------------------------------------------------------------------

autoload -Uz add-zsh-hook
add-zsh-hook precmd _gtc_prompt
_gtc_prompt
