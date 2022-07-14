[[ -f ~/.aliases ]] && . ~/.aliases

# set emacs mode as default
bindkey -e

source $ZPLUG_HOME/init.zsh

zplug "spaceship-prompt/spaceship-prompt"
zplug "zsh-users/zsh-autosuggestions"
zplug "Valiev/almostontop"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load


if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/nav/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;
function gi() { curl -sLw n https://www.toptal.com/developers/gitignore/api/$@ ;}

setopt autocd autopushd

function pomo() {
    arg1=$1
    shift
    args="$*"

    min=${arg1:?Example: pomo 15 Take a break}
    sec=$((min * 60))
    msg="${args:?Example: pomo 15 Take a break}"

    while true; do
        sleep "${sec:?}" && echo "${msg:?}" && say "${msg:?}"
    done
}

[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

function take() {
  mkdir $1; cd $1;
}
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# bun completions
[ -s "/Users/nav/.bun/_bun" ] && source "/Users/nav/.bun/_bun"

