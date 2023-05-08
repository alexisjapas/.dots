#!/usr/bin/env bash

tr_force_color_prompt='yes'

case "$TERM" in
    xterm*) tr_rounded_box='yes' ;;
         *) tr_rounded_box=      ;;
esac

case "$TERM" in
    xterm-color) tr_color_prompt='yes' ;;
     *-256color) tr_color_prompt='yes' ;;
              *) tr_color_prompt=      ;;
esac

if [ -n "$tr_force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null
    then
        tr_color_prompt='yes'
    else
        tr_color_prompt=
    fi
fi

function virtualenv_info(){
    # Get Virtual Env
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Strip out the path and just leave the env name
        venv="${VIRTUAL_ENV##*/}"
    else
        # In case you don't have one activated
        venv=''
    fi
    [[ -n "$venv" ]] && echo "(venv:$venv) "
}

# disable the default virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1

tr_color_format()
{
    if [ "$tr_color_prompt" == 'yes' ]
    then
        case $# in
            1) echo "\[\033[${1}m\]"      ;;
            2) echo "\[\033[${1};${2}m\]" ;;
            *) echo "\[\033[00m\]"        ;;
        esac
    fi
}

tr_ret_code()
{
    local ret_code=$?

    test $ret_code -eq 0 && echo "$1" || echo "$2"

    return $ret_code
}

tr_shlvl_count()
{
    local ret_code=$?

    test -n "$SHLVL" && test "$SHLVL" -gt 1 && echo "$1$SHLVL$2"

    return $ret_code
}

tr_jobs_count()
{
    local ret_code=$?

    test -n "$(jobs -p)" && echo "$1"

    return $ret_code
}

tr_git_branch()
{
    local ret_code=$?

    local git_branch="$(__git_ps1 %s)"

    test -n "$git_branch" && echo "$1$git_branch$2"

    return $ret_code
}

tr_bash_prompt()
{
    ## Styles
    local S_NONE=00
    local S_BOLD=01

    ## Colors
    local    C_YELLOW=93
    local     C_WHITE=97
    local      C_CYAN=96
    local       C_RED=91
    local      C_BLUE=94
    local     C_GREEN=92
    local   C_MAGENTA=95
    local C_TURQUOISE=36

    local C_USER=$(test $UID -eq 0 && echo $C_RED || echo $C_GREEN)

    ## Symbols
    if [ "$tr_rounded_box" == 'yes' ]
    then
        local   L_DR=╭
        local   L_UR=╰
    else
        local   L_DR=┌
        local   L_UR=└
    fi
        local L_DASH=─

    ## Fonts
    local     F_NONE=$(tr_color_format $S_NONE)
    local      F_BOX=$(tr_color_format $S_NONE $C_TURQUOISE)
    local     F_USER=$(tr_color_format $S_BOLD $C_USER)
    local F_HOSTNAME=$(tr_color_format $S_NONE $C_BLUE)
    local    F_SHLVL=$(tr_color_format $S_NONE $C_RED)
    local     F_JOBS=$(tr_color_format $S_NONE $C_YELLOW)
    local   F_BRANCH=$(tr_color_format $S_NONE $C_MAGENTA)
    local      F_CWD=$(tr_color_format $S_BOLD $C_WHITE)
    local    F_INPUT=$(tr_color_format $S_NONE "\$(tr_ret_code $C_MAGENTA $C_RED)")
    local      F_CMD=$(tr_color_format $S_BOLD $C_CYAN)

    ########################################################################
    ## Prompt - User                                                      ##
    ########################################################################

    local PROMPT_USER=$L_DASH'('$F_USER'\u'$F_BOX

    ########################################################################
    ## Prompt - Hostname                                                  ##
    ########################################################################

    local PROMPT_HOSTNAME='@'$F_HOSTNAME'\h'$F_BOX')'

    ########################################################################
    ## Prompt - Shell Level                                               ##
    ########################################################################

    local PROMPT_SHLVL_1=$L_DASH'{'$F_SHLVL'lvl:'
    local PROMPT_SHLVL_2=$F_BOX'}'
    local PROMPT_SHLVL="\$(tr_shlvl_count '$PROMPT_SHLVL_1' '$PROMPT_SHLVL_2')"

    ########################################################################
    ## Prompt - Jobs                                                      ##
    ########################################################################

    local PROMPT_JOBS=$L_DASH'{'$F_JOBS'&:\j'$F_BOX'}'
          PROMPT_JOBS="\$(tr_jobs_count '$PROMPT_JOBS')"

    ########################################################################
    ## Prompt - Git Branch                                                ##
    ########################################################################

    local PROMPT_BRANCH_1=$L_DASH'('$F_BRANCH
    local PROMPT_BRANCH_2=$F_BOX')'
    local PROMPT_BRANCH="\$(tr_git_branch '$PROMPT_BRANCH_1' '$PROMPT_BRANCH_2')"

    ########################################################################
    ## Prompt - Working Directory                                         ##
    ########################################################################

    local PROMPT_CWD=$L_DASH'['$F_CWD'\w'$F_BOX']'

    ########################################################################
    ## Prompt - Input                                                     ##
    ########################################################################

    local PROMPT_INPUT=$L_DASH$F_INPUT
          PROMPT_INPUT_1=$PROMPT_INPUT'\$'
          PROMPT_INPUT_2=$PROMPT_INPUT'>'

    ########################################################################
    ## Prompt - Command                                                   ##
    ########################################################################

    local PROMPT_CMD=$F_CMD' '

    ########################################################################
    ## Window Title                                                       ##
    ########################################################################

    case $TERM in
        xterm*|rxvt*) local _TITLEBAR='\[\033]0;\u: \w\a\]' ;;
                   *)                                       ;;
    esac

    ########################################################################
    ## Bash Prompt                                                        ##
    ########################################################################

    PS0=$F_NONE

    PS1=$_TITLEBAR
    PS1=$PS1$F_BOX$L_DR$L_DASH
    PS1=$PS1$PROMPT_USER
    PS1=$PS1$PROMPT_HOSTNAME
    PS1=$PS1$PROMPT_SHLVL
    PS1=$PS1$PROMPT_JOBS
    PS1=$PS1$PROMPT_BRANCH
    #PS1=$PS1"\$(virtualenv_info)" 
    PS1=$PS1$PROMPT_CWD'\n'
    PS1=$PS1$F_BOX$L_UR
    PS1=$PS1$PROMPT_INPUT_1
    PS1=$PS1$PROMPT_CMD

    PS2=$F_BOX$L_UR
    PS2=$PS2$PROMPT_INPUT_2
    PS2=$PS2$PROMPT_CMD
}

tr_bash_prompt

unset tr_bash_prompt
unset tr_rounded_box
unset tr_color_format
unset tr_color_prompt
unset tr_force_color_prompt
