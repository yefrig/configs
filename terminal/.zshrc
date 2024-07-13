source ${ZDOTDIR:-~}/.antidote/antidote.zsh

antidote load

prompt starship

zstyle ':zephyr:plugin:editor' key-bindings 'vi'

# fzf opts
# Preview file content using bat
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# aliases
alias nv=nvim
alias nvf="fzf --multi --bind 'enter:become(nvim {+})'"

export VISUAL=nvim
export EDITOR="$VISUAL"
