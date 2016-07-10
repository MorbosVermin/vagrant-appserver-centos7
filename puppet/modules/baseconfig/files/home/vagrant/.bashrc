# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias dir='/bin/ls -ltrgF --color=auto'
alias grep='/bin/grep --color=auto'
alias df='/bin/df -Tah'

export PS1="(\u@\h:\W) "
export PATH=$PATH:$HOME/bin

echo "Note: Use 'deploy' to deploy WAR files within /vagrant/deploy."

alias listapps='curl http://manager:Manager123@localhost/manager/text/list'
echo "Note: Use 'listapps' to list application deployed to this container/server."

alias serverinfo='curl http://manager:Manager123@localhost/manager/text/serverinfo'
echo "Note: Use 'serverinfo' to show server information."
