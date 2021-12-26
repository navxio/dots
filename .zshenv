export SPACESHIP_PROMPT_ORDER=(
  user
  dir
  host
  git_branch
  venv
  char 
  )
export SPACESHIP_CHAR_SUFFIX=" "
export SPACESHIP_CHAR_PREFIX=" "
export SPACESHIP_PROMPT_ADD_NEWLINE=false

export PATH=/usr/local/sbin:$PATH
export PATH=$PATH:$HOME/.cargo/bin

export LC_ALL=en_US.UTF-8
export FZF_DEFAULT_COMMAND="fd -H -I --type f --exclude .git/ --exclude node_modules/ --exclude build/"
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"
export EDITOR=vim
export TERM=xterm-256color
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
export ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)
