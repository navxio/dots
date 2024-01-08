#  zmodload zsh/zprof
[[ -f ~/.aliases ]] && . ~/.aliases

# set emacs mode as default
bindkey -e

# cd into directory by typing their name
setopt autocd autopushd

# load zinit
source /opt/homebrew/opt/zinit/zinit.zsh

# Enable alias expansion for auto-completion
zstyle ':completion:*' completer _expand_alias _complete _ignored _approximate
zstyle ':completion:*' expand 'yes'

### init turbo mode
zinit ice wait lucid

## ZSH History

# Set the location where the history file will be stored
HISTFILE=~/.zsh_history

# Set the number of commands to remember in the history file (optional)
HISTSIZE=10000

# Set the number of lines to save in the history file (optional)
SAVEHIST=10000

# Append history to the history file instead of overwriting it
setopt append_history

## #
zinit light zdharma-continuum/history-search-multi-word
zinit light sindresorhus/pure
zinit ice wait"0" lucid atload"!_zsh_highlight_bind_widgets" blockf
zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice wait lucid
zinit light Valiev/almostontop
# fixes suggested by chatgpt
zinit ice wait"0" lucid atload"!_zsh_autosuggest_start" blockf
zinit light zsh-users/zsh-autosuggestions
zinit ice wait lucid
zinit light MichaelAquilina/zsh-autoswitch-virtualenv
# auto notify
zinit ice wait lucid
zinit light MichaelAquilina/zsh-auto-notify
# reminds you of the aliases
zinit ice wait lucid
zinit light MichaelAquilina/zsh-you-should-use

autoload -Uz compinit
if [[ ! -f ${HOME}/.zcompdump || ${HOME}/.zcompdump -ot ${HOME}/.zshrc ]]; then
    compinit
else
    compinit -C
fi

## load user functions
. ~/.user.zsh

## setup pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
#  zprof

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# load secrets
[[ -f ~/.secrets ]] && . ~/.secrets

# bun completions
[ -s "/Users/nav/.bun/_bun" ] && source "/Users/nav/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Created by `pipx` on 2023-10-31 18:29:39
export PATH="$PATH:/Users/nav/.local/bin"
