case $- in
  *i*) ;;
    *) return;;
esac
source ~/dotFiles/shell
source ~/dotFiles/aliases
source ~/dotFiles/functions
source ~/dotFiles/prompt
source ~/dotFiles/init
source ~/dotFiles/envs
[[ $- == *i* ]] && bind -f ~/dotFiles/inputrc

# PATH and DOCKER
export PATH=$HOME/bin:$PATH
export PATH=/home/ksoni/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock
export EDITOR='nvim'
