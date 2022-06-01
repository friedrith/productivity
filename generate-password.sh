#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title password
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author Thibault Friedrich
# @raycast.authorURL https://github.com/friedrith

SIZE=${1:-20}

# Alphanumeric pool
APOOL='a-zA-Z0-9'

# Special character pool
SPOOL='a-zA-Z0-9\`\!\@\#\$\%\^\&\~_\*\(\)\{\}\<\>\-\+\=\|\;\:\\'

cat /dev/urandom | LC_ALL=C tr -dc \
			$SPOOL | fold -w $SIZE | head -n 1
echo #

exit
