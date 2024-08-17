function gl --wraps='git log --all --decorate --oneline --graph' --description 'alias gl git log --all --decorate --oneline --graph'
  git log --all --decorate --oneline --graph $argv
        
end
