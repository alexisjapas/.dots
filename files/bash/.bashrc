# history up/down arrows
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# misc
source ~/.bash_aliases

# prompt
source ~/.git-prompt.sh
source ~/.al-prompt.sh

# direnv
eval "$(direnv hook bash)"
