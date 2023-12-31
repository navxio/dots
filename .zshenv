export ZPLUG_CACHE_DIR=$HOME/.cache/zplug
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
export ZPLUG_HOME=/opt/homebrew/opt/zplug

if [[ "$SHLVL" = 1 ]]; then
  export PATH=/usr/local/sbin:$PATH
  export PATH=$PATH:$HOME/.cargo/bin
  export PATH=$PATH:/Users/nav/Library/Android/sdk
  export PATH=/Users/nav/Library/Android/sdk/platform-tools:$PATH
fi

export LC_ALL=en_US.UTF-8
export EDITOR=nvim
export TERM=xterm-256color
export ANDROID_SDK_PATH=/Users/nav/Library/Android/sdk
export ANDROID_SDK=/Users/nav/Library/Android/sdk

if [[ "$SHLVL" = 1 ]]; then
  export PATH=/Users/nav/Library/Android/sdk/platform-tools:$PATH
  export PATH=/opt/homebrew/bin:$PATH
  export PATH=$HOME/.volta/bin:$PATH
  export PATH=/usr/local/opt/python@3.7/bin:$PATH
  export PATH=/usr/local/opt/ansible@2.8/bin:$PATH
fi
export ANDROID_SDK=/Users/nav/Library/Android/sdk
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Bun
export BUN_INSTALL="/Users/nav/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
