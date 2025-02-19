# env vars
setenv VISUAL nvim
setenv EDITOR $VISUAL

# fzf opts
setenv FZF_DEFAULT_COMMAND 'fd --type f'
# setenv JAVA_HOME /Library/Java/JavaVirtualMachines/jdk-21-oracle-java-se.jdk/Contents/Home

# path
fish_add_path /opt/local/bin/
fish_add_path /opt/homebrew/bin

# integrations
starship init fish | source
fzf --fish | source

fish_config theme choose "Rosé Pine"
