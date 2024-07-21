# env vars
setenv VISUAL nvim
setenv EDITOR $VISUAL

# fzf opts
setenv FZF_DEFAULT_COMMAND 'fd --type f'

# integrations
starship init fish | source
fzf --fish | source

# path
fish_add_path /opt/local/bin/

fish_config theme choose "Rosé Pine"
