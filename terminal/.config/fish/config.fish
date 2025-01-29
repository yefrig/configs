# env vars
setenv VISUAL nvim
setenv EDITOR $VISUAL

# ghcup-env
setenv GHCUP_INSTALL_BASE_PREFIX $HOME

# fzf opts
setenv FZF_DEFAULT_COMMAND 'fd --type f'

# path
fish_add_path /opt/local/bin/
fish_add_path $HOME/.cabal/bin
fish_add_path $HOME/.ghcup/bin

# integrations
starship init fish | source
fzf --fish | source

fish_config theme choose "Rosé Pine"
