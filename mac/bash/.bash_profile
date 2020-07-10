# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi
export PATH=$PATH:$HOME/.nodebrew/current/bin
export PATH="/usr/local/opt/openssl/bin:$PATH"

# php composer installer
export PATH=$PATH:$HOME/.composer/vendor/bin
# export PATH="$HOME/.anyenv/bin:$PATH"
# eval "$(anyenv init -)"

# Golang
export GOPATH=${HOME}/go
export PATH=$GOPATH/bin:$PATH
export PATH="/usr/local/opt/php@7.1/bin:$PATH"
export PATH="/usr/local/opt/php@7.1/sbin:$PATH"

# Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/ymgn/.sdkman"
[[ -s "/Users/ymgn/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/ymgn/.sdkman/bin/sdkman-init.sh"
export PATH="/usr/local/opt/php@7.3/bin:$PATH"
export PATH="/usr/local/opt/php@7.3/sbin:$PATH"
