# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi
export PATH=$PATH:$HOME/.nodebrew/current/bin
export PATH="/usr/local/opt/openssl/bin:$PATH"
# pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
# php composer installer
export PATH=$PATH:$HOME/.composer/vendor/bin
# export PATH="$HOME/.anyenv/bin:$PATH"
# eval "$(anyenv init -)"

# Golang
export GOPATH=${HOME}/go
export PATH=$GOPATH/bin:$PATH
export PATH="/usr/local/opt/php@7.1/bin:$PATH"
export PATH="/usr/local/opt/php@7.1/sbin:$PATH"
