# zsh config stuff
autoload -U colors && colors
autoload -U compinit && compinit

setopt promptsubst
setopt histignoredups
setopt noclobber
setopt append_history
setopt auto_cd

setopt auto_menu # show completion menu after second tab press

# not sure I like this option
# setopt menu_complete # insert first match for multiple matches

zstyle ':completion:*' special-dirs true # complete . and ..

# case insensitive autocompletion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

# Why should this be any smaller
# It's not the 90s anymore
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# vi mode
# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[6 q"
}
zle -N zle-line-init
echo -ne '\e[6 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.

# Aliases
alias nn='nnn -C'
alias v='nvim'
alias vim='nvim'
alias svim="sudo nvim"
alias top="htop"
alias ptop="sudo powertop"
alias a="augr"
alias tmn='tmux new -s'
alias tma='tmux attach -t'
alias tmk='tmux kill-session -t'
ls_cmd='ls'
type exa &> /dev/null && ls_cmd='exa'
# shellcheck disable=SC2139
alias ls="$ls_cmd"
# shellcheck disable=SC2139
alias la="$ls_cmd -lga"
# shellcheck disable=SC2139
alias ll="$ls_cmd -lgh"
type bat &> /dev/null && alias less='bat'
alias duhd='du -hd 1 | sort -h'
alias duh='du -ahld 1 | sort -h'
alias .j='just --justfile=$HOME/.justfile --working-directory=.'
alias j='just'
alias ssh='TERM=xterm-color ssh'
alias doco='docker compose'
alias poco='podman compose'
alias cm='chezmoi'
alias vd='vdirsyncer'
alias vimdiff='nvim -d'
alias cp='cp --reflink=auto'
alias mbsync='mbsync --config ~/.config/mbsync/config'

## todoman
alias do-today='todo edit --due today'
alias tn='td new'
alias tl='todo list actions'
alias tlt='todo list actions --due "$(qalc -t 23 - $(date +%H))"'

function td() {
    todo "$@" && systemctl --user start --no-block vdirsyncer
}

## trans
alias :en='trans :en'
alias :de='trans :de'

# I can't type
alias maek="make"
alias makemake="make"
alias mak="make"

# Git
alias glg="git lg"
alias gls="git status"
alias gd="git diff"
alias gbd='gd $(git merge-base HEAD main)' 
alias ga="git add --all"
alias gc="git commit"
alias gds="git diff --staged"
alias gch="git checkout"
alias gcm="gc -m"
alias gcp="ga . && gc -m 'auto-commit' && git push"
alias gca="ga . && git commit -am"
alias gsm="git submodule"
alias gres="git restore"
alias gsw="git switch"
alias gpl="git pull"
alias gps="git push"
alias gpf="git push --force-with-lease"
alias gf="git fetch"

# Pacman
alias pacman="pacman --color auto"
alias spacman="sudo pacman --color auto"
alias fuck="spacman -Rns"
alias get="spacman -S"

# pueue
alias pq="pueue"
alias pqa="pueue add --"
alias pqs="pueue status"

# Systemd clusterfuck
alias sc="sudo systemctl"
alias scu="systemctl --user"
alias sus="systemctl suspend"
alias hib="systemctl hibernate"
alias jc="sudo journalctl"
alias jcu="journalctl --user"

# fzf
# shellcheck source=/dev/null
[ -f "/usr/share/fzf/key-bindings.zsh" ] && source "/usr/share/fzf/key-bindings.zsh"
# shellcheck source=/dev/null
[ -f "/usr/share/fzf/completion.zsh" ] && source "/usr/share/fzf/completion.zsh"

# fuzzy multi-select modified file
gfls() {
  git ls-files -m -o -d --exclude-standard | uniq \
      | fzf -m --preview 'git diff --color {}' \
          --bind=ctrl-d:preview-page-down,ctrl-u:preview-page-up
}

zle -N gfls
bindkey "^g" gfls

# stage files multi-selected modified files
gfa() {
   gfls | git add --pathspec-from-file=-
}

# For programs that ignore $EDITOR
alias vi="vim"

# Other tools
type "zoxide" &> /dev/null && eval "$(zoxide init zsh)"
type "starship" &> /dev/null && eval "$(starship init zsh)"

# Initialize ssh key agent
type "keychain" &> /dev/null && eval "$(keychain --eval --quiet id "$ADDITIONAL_KEYCHAIN_KEYS")"

# shellcheck source=/dev/null
source "$HOME/.zshrc.local"
