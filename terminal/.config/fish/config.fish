# env vars
setenv VISUAL nvim
setenv EDITOR $VISUAL

# ghcup-env
setenv GHCUP_INSTALL_BASE_PREFIX $HOME

# fzf opts
setenv FZF_DEFAULT_COMMAND 'fd --type f'

# integrations
starship init fish | source
fzf --fish | source

# path
fish_add_path /opt/local/bin/
fish_add_path $HOME/.cabal/bin
fish_add_path $HOME/.ghcup/bin

fish_config theme choose "Rosé Pine"
