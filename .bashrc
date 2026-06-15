alias bolt="flatpak run com.adamcake.Bolt"

# Molokai colors
M_GREEN='148'
M_BLUE='81'
M_PINK='197'
M_WHITE='255'

set_prompt() {
    local EXIT="$?"
    local GIT_FORMAT=" (\[\e[38;5;${M_PINK}m\]%s\[\e[0m\])"
    #local GIT_INFO=$(__git_ps1 "$GIT_FORMAT")
    local GIT_INFO=""

    # 1. Determine the color based on success/fail
    local PROMPT_COLOR
    if [ $EXIT -eq 0 ]; then
        PROMPT_COLOR="\[\e[38;5;${M_WHITE}m\]"
    else
        PROMPT_COLOR="\[\e[38;5;${M_PINK}m\]"
    fi

    # 2. Determine the char based on user (Root vs User)
    local PROMPT_CHAR
    if [ "$EUID" -eq 0 ]; then
        PROMPT_CHAR="#"
    else
        PROMPT_CHAR="%"
    fi

    # 3. Construct PS1
    PS1="\[\e[38;5;${M_GREEN}m\]\u@\h\[\e[0m\] \[\e[38;5;${M_BLUE}m\]\W\[\e[0m\]${GIT_INFO}\n${PROMPT_COLOR}${PROMPT_CHAR} \[\e[0m\]"
}

PROMPT_COMMAND=set_prompt


# uv
export PATH="/home/albin/.local/bin:$PATH"
