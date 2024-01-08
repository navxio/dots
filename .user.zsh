######
#
# User functions
######

#  pomodoro timer
#  usage pomo <task>
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


# generate gitignore files
function gi() { curl -sLw n https://www.toptal.com/developers/gitignore/api/$@ >> .gitignore;}

# make and cd into a directorya
function take() {
  mkdir $1; cd $1;
}

# manage dotfiles
function c() {
    /usr/bin/git --git-dir=$HOME/.mydots/ --work-tree=$HOME $@
}

# open a new iterm window in current directory
function iterm(){
    osascript -e "tell application \"iTerm\"
        activate
        set newWindow to (create window with default profile)
        tell current session of newWindow
            write text \"cd '$PWD'\"
        end tell
    end tell"
}

function yabai_reload() {
  terminal-notifier -message 'Reloading yabai' -title 'yabai';
  yabai --stop-service;
  yabai --start-service;
  sudo yabai --load-sa
  terminal-notifier -message 'Reloaded yabai' -title 'yabai';
}

function clazygit() {
  lazygit --git-dir=$HOME/.mydots/ --work-tree=$HOME
}
