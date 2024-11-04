# Load local configuration if it exists
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi
# Source git prompt script - Windows Git Bash path
if [ -f "/mingw64/share/git/completion/git-prompt.sh" ]; then
    source "/mingw64/share/git/completion/git-prompt.sh"
fi

# Git autocompletion for Windows
if [ -f "/mingw64/share/git/completion/git-completion.bash" ]; then
    source "/mingw64/share/git/completion/git-completion.bash"
fi

# Optional: Add bash completion for git aliases if you use them
if [ -f "/mingw64/share/bash-completion/completions/git" ]; then
    source "/mingw64/share/bash-completion/completions/git"
fi

# Check if running on Windows
is_windows() {
    [[ "$(uname)" =~ MINGW|MSYS|CYGWIN ]] && return 0 || return 1
}

# Windows-specific paths (convert to Unix-style)
if is_windows; then
    # Common Windows directories
    export USERPROFILE="$(cygpath "$USERPROFILE")"
    export DOWNLOADS="$(cygpath "$USERPROFILE/Downloads")"
    export DOCUMENTS="$(cygpath "$USERPROFILE/Documents")"
    export DESKTOP="$(cygpath "$USERPROFILE/Desktop")"
fi

# System aliases - Windows compatible
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ll='ls -alh'
alias la='ls -A'
alias l='ls -CF'
alias c='clear'
alias h='history'
alias mkdir='mkdir -p'

# Windows-specific aliases
if is_windows; then
    # Open Windows Explorer in current directory
    alias explorer='explorer.exe .'

    # Launch VS Code
    alias code='code'

    # Common Windows programs
    alias notepad='notepad.exe'
    alias chrome='start chrome'
    alias edge='start microsoft-edge:'

    # Windows system commands
    alias ipconfig='ipconfig.exe'
    alias tasklist='tasklist.exe'
    alias taskkill='taskkill.exe'
    alias systeminfo='systeminfo.exe'

    # Network commands
    alias netstat='netstat.exe'
    alias ping='ping.exe'

    # Open command prompt or PowerShell
    alias cmd='cmd.exe /c'
    alias pwsh='powershell.exe'
fi

# Directory shortcuts - Windows compatible
if is_windows; then
    alias downloads="cd \"$DOWNLOADS\""
    alias documents="cd \"$DOCUMENTS\""
    alias desktop="cd \"$DESKTOP\""
    alias home="cd \"$USERPROFILE\""
else
    alias downloads='cd ~/Downloads'
    alias documents='cd ~/Documents'
    alias desktop='cd ~/Desktop'
    alias home='cd ~'
fi

# Git aliases
alias gs='git st'
alias ga='git aa'
alias gcm='git cm'
alias gp='git po'
alias gl='git ll'
alias gd='git diff'
alias gb='git branch'
alias gco='git co'
alias gcob='git cob'
alias gpl='git pull'
alias gf='git fetch'
alias grb='git rebase'
alias gst='git stash'

# Docker aliases - Windows compatible
if is_windows; then
    alias dk='docker.exe'
    alias dkps='docker.exe ps'
    alias dki='docker.exe images'
    alias dkrm='docker.exe rm'
    alias dkrmi='docker.exe rmi'
    alias dkc='docker-compose.exe'
    alias dkcu='docker-compose.exe up -d'
    alias dkcd='docker-compose.exe down'
else
    alias dk='docker'
    alias dkps='docker ps'
    alias dki='docker images'
    alias dkrm='docker rm'
    alias dkrmi='docker rmi'
    alias dkc='docker-compose'
    alias dkcu='docker-compose up -d'
    alias dkcd='docker-compose down'
fi

# Docker cleanup function
dkclean() {
    docker container prune -f
    docker image prune -f
    docker network prune -f
    docker volume prune -f
}

# Enhanced history configuration
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:ll:cd:pwd:exit:date:* --help"
HISTTIMEFORMAT="%F %T "

# Extract function - Windows compatible
extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Enhanced find functions - Windows compatible
function f() { find . -iname "*$1*" 2>/dev/null; }
function ff() { find . -type f -iname "*$1*" 2>/dev/null; }
function fd() { find . -type d -iname "*$1*" 2>/dev/null; }

# Create directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Quick backup of a file
backup() {
    cp "$1" "$1.bak-$(date +%Y%m%d-%H%M%S)";
}

# System monitoring functions - Windows compatible
if is_windows; then
    # Windows process list
    processes() {
        tasklist.exe /FO TABLE /NH | sort
    }

    # Windows system info
    sysinfo() {
        systeminfo.exe
    }

    # Check Windows services
    services() {
        net.exe start
    }

    # Kill process by name
    killproc() {
        taskkill.exe /IM "$1" /F
    }
else
    # Unix process monitoring
    processes() {
        ps aux | sort -nr -k 3 | head -10
    }
fi

# Generate random password
genpass() {
    local length="${1:-16}"
    tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c "$length"; echo
}

# Better directory navigation
shopt -s autocd 2>/dev/null
shopt -s cdspell 2>/dev/null
shopt -s dirspell 2>/dev/null
shopt -s globstar 2>/dev/null

# More convenient history searching
if is_windows; then
    # Check if running in mintty (Git Bash)
    if [[ "$TERM" == "xterm" ]]; then
        bind '"\e[A": history-search-backward'
        bind '"\e[B": history-search-forward'
    fi
else
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
fi


# Enable git information
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=1

# Enable case-insensitive autocompletion
bind "set completion-ignore-case on"

# Display all matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

# Add colors to the completion
bind "set colored-stats on"
bind "set visible-stats on"
bind "set mark-symlinked-directories on"
bind "set colored-completion-prefix on"
bind "set menu-complete-display-prefix on"

function git_prompt_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local git_status="$(git branch 2>/dev/null | grep '^*' | cut -d' ' -f2)"
        local status_symbols=""

        # Check for various git states and add emojis
        git diff --quiet 2>/dev/null || status_symbols+="📝 "
        git diff --cached --quiet 2>/dev/null || status_symbols+="📦 "
        [ -n "$(git ls-files --others --exclude-standard)" ] && status_symbols+="❓"
        [ -n "$(git stash list)" ] && status_symbols+="📋 "

        # Check for ahead/behind status
        local ahead="$(git rev-parse @{u} >/dev/null 2>&1 && git rev-list --count @{u}.. 2>/dev/null || echo 0)"
        local behind="$(git rev-parse @{u} >/dev/null 2>&1 && git rev-list --count ..@{u} 2>/dev/null || echo 0)"
        [ "$ahead" -gt 0 ] && status_symbols+="⬆️ $ahead "
        [ "$behind" -gt 0 ] && status_symbols+="⬇️ $behind "

        echo " 🌿 $git_status $status_symbols"
    fi
}

# Windows-specific path shortening (optional)
function shorten_path() {
    pwd | sed "s|$HOME|~|" | sed 's|\([^/]\)[^/]*/|\1/|g'
}

# Define PROMPT_COMMAND for Windows Git Bash
PROMPT_COMMAND='PS1="\[\033[38;5;39m\]💻 \h\[\033[0m\] ➜ \[\033[38;5;76m\]📂 $(shorten_path)\[\033[0m\]\[\033[38;5;183m\]$(git_prompt_info)\[\033[0m\]\n\[\033[38;5;183m\]➜\[\033[0m\] "'