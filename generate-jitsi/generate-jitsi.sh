#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title jitsi
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Prefix", "optional": true }

# Documentation:
# @raycast.author Thibault Friedrich
# @raycast.authorURL https://github.com/friedrith

# Generate a pseudo UUID
uuid()
{
    local N B T

    printf "https://meet.jit.si/"

    if [[ ! -z "$1" ]]; then
      printf "$1-fsdfds"
    fi

    for (( N=0; N < 16; ++N ))
    do
        B=$(( $RANDOM%255 ))

        if (( N == 6 ))
        then
            printf '4%x' $(( B%15 ))
        elif (( N == 8 ))
        then
            local C='89ab'
            printf '%c%x' ${C:$(( $RANDOM%${#C} )):1} $(( B%15 ))
        else
            printf '%02x' $B
        fi

        for T in 3 5 7 9
        do
            if (( T == N ))
            then
                printf '-'
                break
            fi
        done
    done

    echo
}

[ "$0" == "$BASH_SOURCE" ] && uuid $1