# Implements Bundler bash completion.
# Script tries to cache groups and gems list as long as possible,
# and also uses Gemfile.lock to speedup completions lookup.

_BUNDLER_GEM_FILE=Gemfile

function __bundler_list_all_commands {
  local i IFS=$'\n'
  bundle help|egrep '^  [a-zA-Z0-9]'|cut -f4 -d ' '
}

__bundler_all_commands=
function __bundler_compute_all_commands {
  : ${__bundler_all_commands:=$(__bundler_list_all_commands)}
}

__bundler_command_opts=
function __bundler_compute_command_opts {
  local opts=$(bundle help $1|grep '^  \['|cut -f2 -d '['|cut -f1 -d '=')
  if [ $? -eq 0 ]; then
    __bundler_command_opts=$opts
  else
    __bundler_command_opts=
  fi
}

__bundler_cached_gemfile_path=
__bundler_cached_gemfile_mtime=
__bundler_all_gems=
function __bundler_compute_all_gems {
  local gems
  if [ -f "${_BUNDLER_GEM_FILE}.lock" ]; then
    __bundler_all_gems=$(ruby -ryaml -e "puts YAML.load_file('${_BUNDLER_GEM_FILE}.lock')['specs'].map(&:keys).flatten")
    return 0
  elif [ -f "${_BUNDLER_GEM_FILE}" ]; then
    if [ -n "${__bundler_all_gems-}" ] && [ "${__bundler_cached_gemfile_path}" == $(pwd) ] && [ "${__bundler_cached_gemfile_mtime}" == $(stat -f %m ${_BUNDLER_GEM_FILE}) ]; then
      return 0
    else
      gems=$(bundle show 2>/dev/null)
      if [ $? -eq 0 ]; then
        __bundler_all_gems=$(echo "$gems"|cut -f2 -d '*'|cut -f2 -d ' ')
        __bundler_cached_gemfile_path=$(pwd)
        __bundler_cached_gemfile_mtime=$(stat -f %m ${_BUNDLER_GEM_FILE})
        return 0
      fi
    fi
  fi

  __bundler_all_gems=
  __bundler_cached_gemfile_path=
  __bundler_cached_gemfile_mtime=
}

__bundler_all_groups=
function __bundler_compute_all_groups {
  local gems
  if [ -f "${_BUNDLER_GEM_FILE}.lock" ]; then
    __bundler_all_groups=$(ruby -ryaml -e "puts YAML.load_file('${_BUNDLER_GEM_FILE}.lock')['dependencies'].map{|n,v|v['group']}.flatten.uniq.join(' ')")
    return 0
  elif [ -f "${_BUNDLER_GEM_FILE}" ]; then
    if [ -n "${__bundler_all_groups-}" ] && [ "${__bundler_cached_gemfile_path}" == $(pwd) ] && [ "${__bundler_cached_gemfile_mtime}" == $(stat -f %m ${_BUNDLER_GEM_FILE}) ]; then
      return 0
    else
      gems=$(ruby -rconfig/boot -e "puts Bundler.definition.groups" 2>/dev/null)
      if [ $? -eq 0 ]; then
        __bundler_all_groups=$gems
        __bundler_cached_gemfile_path=$(pwd)
        __bundler_cached_gemfile_mtime=$(stat -f %m ${_BUNDLER_GEM_FILE})
        return 0
      fi
    fi
  fi

  __bundler_all_groups=
  __bundler_cached_gemfile_path=
  __bundler_cached_gemfile_mtime=
}

function _bundler_complete {
  local cur prev cmd special opts

  COMPREPLY=()
  cur=`_get_cword`
  cmd=${COMP_WORDS[1]}
  prev=${COMP_WORDS[COMP_CWORD-1]}

  for ((i=COMP_CWORD-1; i > 1; i--)); do
    if [ "${COMP_WORDS[i]}" == '--gemfile' ]; then
      if [ -n "${COMP_WORDS[i+1]-}" ]; then
        _BUNDLER_GEM_FILE=${COMP_WORDS[i+1]}
      fi
      break
    fi
  done

  if [ "$COMP_CWORD" -eq 1 ]; then
    if [[ "$cur" == -* ]]; then
      opts='-h --help -v --version'
    else
      __bundler_compute_all_commands
      opts=${__bundler_all_commands}
    fi
  else
    case $prev in
      --gemfile)
        _filedir
        return 0
        ;;
      *)
        if [[ "$cur" == -* ]]; then
          __bundler_compute_command_opts $cmd
          opts=${__bundler_command_opts}
        else
          case $cmd in
            help)
              __bundler_compute_all_commands
              opts=${__bundler_all_commands}
              ;;
            open|show)
              __bundler_compute_all_gems
              opts=${__bundler_all_gems}
              ;;
            console)
              __bundler_compute_all_groups
              opts=${__bundler_all_groups}
              ;;
            install)
              for ((i=COMP_CWORD-1; i > 1; i--)); do
                if [ "${COMP_WORDS[i]}" == '--without' ]; then
                  __bundler_compute_all_groups
                  opts=${__bundler_all_groups}
                  break
                elif [[ "${COMP_WORDS[i]}" == -* ]]; then
                  break
                fi
              done
              ;;
          esac
        fi
        ;;
    esac
  fi

  COMPREPLY=( $(compgen -W "$opts" -- $cur) )
}

complete -F _bundler_complete bundle
