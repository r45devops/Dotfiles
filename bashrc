#history config
shopt -s histappend cdspell autocd
export HISTSIZE=1000 HISTFILESIZE=1000
export HISTCONTROL="ignorespace:erasedups"
#PROMPT_COMMAND='[[ $? -ne 0 ]] && history -d $((HISTCMD-1)) 2>/dev/null'

PS1='[\u@\h \W]\$ '

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias l='ls -hl --color=auto --group-directories-first'
alias ls='ls -hl --color=auto --group-directories-first'
alias sl='ls -hl --color=auto --group-directories-first'
alias la='ls -ahl --color=auto --group-directories-first'
alias grep='grep --color=auto'

alias vi='nvim'

#zoxide config
eval "$(zoxide init bash)"

#fzf config
eval "$(fzf --bash)"
export FZF_DEFAULT_OPTS="
  --height 40% --reverse --border=rounded --ansi
  --color hl:231,hl+:155,info:144,prompt:33,spinner:148,pointer:64,marker:136
"
export FZF_CTRL_R_OPTS="
  --multi --preview 'echo {}' --preview-window up:3:hidden
  --bind '?:toggle-preview' \
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort' \
  --header 'Tab 多选  /  Ctrl-Y 复制  /  ?: 预览'
"

#git aliases
alias g='git'
alias gaa='git add -A'
alias gs='git status -sb'
alias gpl='git pull'
alias gpu='git push'
alias gd='git diff | mate'
alias gau='git add --update'
#alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcot='git checkout -t'
alias gcotb='git checkout --track -b'
alias gl='git log --oneline --decorate'
alias glog='git log --pretty=format:"%h %s" --graph'

#Docker
alias dp='docker ps'
alias di='docker images'
alias dpr='docker pull'
alias drun='docker run -it --rm'
alias dexec='docker exec -it'

#Shellcheck
alias shfmt='shfmt -i 4 -ci -sr -w'                        # 格式化当前 Shell 脚本（4空格缩进）
alias shcheck='shellcheck -s bash'                         # 检查 Bash 脚本
alias shcheckx='shellcheck -s bash -x'                     # 检查并追踪 source 的脚本
alias shclean='shellcheck -s bash --exclude=SC2086,SC2154' # 忽略常见“有意为之”的警告
