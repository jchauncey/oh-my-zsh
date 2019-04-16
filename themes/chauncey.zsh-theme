# fino2.zsh-theme

# Use with a dark background and 256-color terminal!
# Meant for people with rbenv and git. Tested only on OS X 10.7.

# You can set your computer name in the ~/.box-name file if you want.

# Borrowing shamelessly from these oh-my-zsh themes:
#   bira
#   robbyrussell
#
# Also borrowing from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

function prompt_char {
  git branch >/dev/null 2>/dev/null && echo "±" && return
  echo '○'
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo ${SHORT_HOST:-$HOST}
}

function go_version {
  /usr/local/go/bin/go version | grep -o -E '\d+.\d+.'
}

function az_sub {
  echo $SUBSCRIPTION_NAME
}

prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

function hcp_env() {
  if [[ -n "${REGION}" && -n "${CLUSTER}" ]]; then
    echo "%{$FG[120]%}[hcp:${REGION}@${CLUSTER}]%{$reset_color%}"
  else
    echo ""
  fi
}

function kube_env() {
  echo "%{$FG[160]%}[k8s:${KUBECONFIG}]%{$reset_color%}"
}

local current_dir='${PWD/#$HOME/~}'
local git_info='$(git_prompt_info)'
local prompt_char='$(prompt_char)'

go_ver=' %{$FG[243]%}‹go:$(go_version)›%{$reset_color%}'
kubes_env='$(kube_env)'
env='$(hcp_env)'
az_sub='%{$FG[020]%}[sub:$(az_sub)]%{$reset_color%}'
# deis='%{$FG[129]%}[$(deis_user)@$(deis_env)]'
# sub='%{$FG[129]%}[$(az_sub)]'

# %{$FG[239]%}at%{$reset_color%} %{$FG[033]%}$(box_name)%{$reset_color%}

PROMPT="╭─%{$FG[040]%}%n%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}${current_dir}%{$reset_color%}${git_info} %{$FG[239]%}using${go_ver}
| ${kubes_env} ${env} ${az_sub}
╰─${last_exit_code}${prompt_char}%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%}✘✘✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%}✔"

