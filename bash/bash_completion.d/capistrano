function __capistrano_list_all_opts {
  local i IFS=$'\n'
  cap -h|egrep '^    '|awk '{print $1 "\n" $2}'|egrep '^-'
}

__capistrano_all_opts=
function __capistrano_compute_all_opts {
  : ${__capistrano_all_opts:=$(__capistrano_list_all_opts)}
}

__capistrano_all_tasks=
__capistrano_cached_capfile_path=
__capistrano_cached_capfile_mtime=
function __capistrano_compute_all_tasks {
  local tasks
  if [ -f "Capfile" ]; then
    if [ -n "${__capistrano_all_tasks-}" ] && [ "${__capistrano_cached_capfile_path}" == $(pwd) ] && [ "${__capistrano_cached_capfile_mtime}" == $(stat -f %m Capfile) ]; then
      return 0
    else
      tasks=$(cap -T 2>/dev/null)
      if [ $? -eq 0 ]; then
        __capistrano_all_tasks=$(echo "$tasks"|egrep '^cap '|cut -f2 -d ' ')
        __capistrano_cached_capfile_path=$(pwd)
        __capistrano_cached_capfile_mtime=$(stat -f %m Capfile)
        return 0
      fi
    fi
  fi

  __capistrano_all_tasks=
  __capistrano_cached_capfile_path=
  __capistrano_cached_capfile_mtime=
}

function _capistrano_complete {
  local cur prev opts

  COMPREPLY=()
  cur=`_get_cword`
  prev=${COMP_WORDS[COMP_CWORD-1]}

  case $prev in
    -f|--file)
      _filedir
      return 0
      ;;
    -e|--explain)
      __capistrano_compute_all_tasks
      opts=${__capistrano_all_tasks}
      ;;
    *)
      if [[ "$cur" == -* ]]; then
        __capistrano_compute_all_opts
        opts=${__capistrano_all_opts}
      else
        __capistrano_compute_all_tasks
        opts=${__capistrano_all_tasks}
      fi
      ;;
  esac

  COMP_WORDBREAKS=${COMP_WORDBREAKS//:}
  COMPREPLY=( $(compgen -W "$opts" -- $cur) )
}


complete -F _capistrano_complete cap
