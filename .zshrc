zmodload zsh/zprof
# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"
# Enable the completion system (skip if you already have it / use a framework)
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# User configuration

eval "$(starship init zsh)"

# `ls -al` annotated with the current branch of every git repo listed
gs() {
  emulate -L zsh
  local dir=${1:-.} d name branch line width=0
  local -A branches
  local -a lines

  _gs_branch() {
    local top=$(git -C $1 rev-parse --show-toplevel 2>/dev/null)
    [[ $top == ${1:A} ]] || return 1
    git -C $1 symbolic-ref --quiet --short HEAD 2>/dev/null \
      || git -C $1 rev-parse --short HEAD 2>/dev/null
  }

  for d in $dir/*(N-/) $dir/.*(N-/); do
    branch=$(_gs_branch $d) && branches[${d:t}]=$branch
  done
  branch=$(_gs_branch $dir) && print -P "%F{cyan}${dir:A:t}%f on %F{magenta}$branch%f"
  unfunction _gs_branch

  lines=("${(@f)$(ls -al $dir)}")
  for line in $lines; do (( ${#line} > width )) && width=${#line}; done
  for line in $lines; do
    name=
    [[ $line =~ '^([^ ]+ +){8}(.*)$' ]] && name=${match[2]%% -> *}
    if [[ -n ${branches[$name]-} ]]; then
      printf '%-*s  ' $width $line
      print -P "%F{magenta}${branches[$name]}%f"
    else
      print -r -- $line
    fi
  done
}

# Created by `pipx` on 2026-04-22 22:49:54
export PATH="$PATH:/Users/devin/.local/bin"
unsetopt CASE_GLOB

# Added by get-aspire-cli.sh
export PATH="$HOME/.aspire/bin:$PATH"
