#! /bin/bash

source /Users/thibault/.zshrc
npx md-to-pdf "$1" 

osascript -e 'display notification "PDF generated"'
