alias docker_exec='docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -it'
alias bastion_exec='docker_exec -e ACCEPT_QULA=true -it bdicluster_bastion_1'
alias bx='bastion_exec'
alias bbash='bx bash'
alias dup='docker-compose -p bdicluster up -d'
alias ddown='docker-compose -p bdicluster down'
