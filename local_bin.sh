################################################################################
# Initialization                                                               #
################################################################################

# Setup local bin dir
[[ -n "$LOCAL_BIN_DIR" ]] || export LOCAL_BIN_DIR=$HOME/.local_bin

# Try to set local bin as prompt command

if [[ -n "$PROMPT_COMMAND" && "$PROMPT_COMMAND" != "__local_bin_prompt_command" ]]; then
  export __LOCAL_BIN_USER_PROMPT_COMMAND=$PROMPT_COMMAND
fi

export PROMPT_COMMAND='__local_bin_prompt_command'


if [[ -n "${ZSH_VERSION}" ]]; then
  # TODO: what if precmd() is already defined?
  precmd() {
    $PROMPT_COMMAND
  }
fi
################################################################################
# Commands                                                                     #
################################################################################

local_bin() {
  local cmd=$1

  case "$cmd" in
    'cd')
      __local_bin_cd
      ;;
    'edit')
      __local_bin_edit $2
      ;;
    *)
      __local_bin_help
      ;;
  esac
}

localbin() {
  local_bin $@
}

################################################################################
# Internals                                                                    #
################################################################################

__local_bin_prompt_command() {
  __local_bin_set_path
  [[ -n "$__LOCAL_BIN_USER_PROMPT_COMMAND" ]] && $__LOCAL_BIN_USER_PROMPT_COMMAND
}

__local_bin_current_path() {
  echo $LOCAL_BIN_DIR$(pwd)
}

__local_bin_recursively_build_paths() {
  local path=$1 acc=$2 updir
  if [[ "$path" == "$LOCAL_BIN_DIR" ]]; then
    echo $path
    return
  fi
  if [[ -n "$acc" ]]; then
    updir=$(dirname $path)
    acc=$acc:$updir
    if [[ "$updir" == "$LOCAL_BIN_DIR" ]]; then
      echo $acc
    else
      __local_bin_recursively_build_paths $updir, $acc
    fi
  else
    __local_bin_recursively_build_paths $path $path
  fi
}

__local_bin_set_path() {
  local sed_filter cleaned_path
  sed_filter="s#\\${LOCAL_BIN_DIR}/[^:]*:##g"
  cleaned_path=$(echo $PATH | sed $sed_filter)
  chmod -R +x $LOCAL_BIN_DIR/*
  if [[ "$LOCAL_BIN_RECURSIVE" == "1" ]]; then
    export PATH=$(__local_bin_recursively_build_paths $(__local_bin_current_path)):$cleaned_path
  else
    export PATH=$(__local_bin_current_path):$cleaned_path
  fi
  export __LOCAL_BIN_WORKS=1
}

__local_bin_create_directory() {
  [[ -e "$1" ]] || mkdir -p $1
}

__local_bin_cd() {
  __local_bin_create_directory $(__local_bin_current_path)
  echo "Switching to local_bin directory for $(pwd)"
  echo "To go back type: cd -"
  cd $(__local_bin_current_path)
}

__local_bin_edit() {
  __local_bin_create_directory $(__local_bin_current_path)
  if [[ -n "$1" ]]; then
    $EDITOR $(__local_bin_current_path)/$1
  else
    $EDITOR $(__local_bin_current_path)
  fi
}

__local_bin_help() {
  echo "help todo"
}
