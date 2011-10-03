function __mysql_list_all_opts {
  local i IFS=$'\n'
  mysql --help|egrep '^  -'|awk '{print $1 "\n" $2}'|egrep '^-'|sed s/,$//|sort
}

__mysql_all_opts=
function __mysql_compute_all_opts {
  : ${__mysql_all_opts:=$(__mysql_list_all_opts)}
}

function _mysql_complete {
  local cur prev opts

  COMPREPLY=()
  cur=`_get_cword`
  prev=${COMP_WORDS[COMP_CWORD-1]}

  case $prev in
    *)
      if [[ "$cur" == -* ]]; then
        __mysql_compute_all_opts
        opts=${__mysql_all_opts}
      else
        opts=$(mysql -uroot -s -e 'show databases')
      fi
      ;;
  esac

  COMP_WORDBREAKS=${COMP_WORDBREAKS//:}
  COMPREPLY=( $(compgen -W "$opts" -- $cur) )
}

complete -F _mysql_complete mysql
