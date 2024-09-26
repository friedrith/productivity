#!/bin/zsh

# Require ffmpeg and imagemagick installed

# Define the ffmpeg path
FFMPEG_PATH=`which ffmpeg`
if [ $? -ne 0 ]; then
    FFMPEG_PATH=~/Applications/ffmpeg
    $FFMPEG_PATH -version > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Failed to locate FFMPEG library "
        osascript -e 'tell app "System Events" to display dialog "Failed to locate FFMPEG library " with title "'$window_title_end'" buttons {"CANCEL"} default button "CANCEL"'
        exit 1
    fi
fi

# Check imagemagic installation
convert -version > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Failed to locate IMAGEMAGIC library"
    osascript -e 'tell app "System Events" to display dialog "Failed to locate IMAGEMAGIC library " with title "'$window_title_end'" buttons {"CANCEL"} default button "CANCEL"'
    exit 1
fi

# If you want to make a shell script exit whenever any command within the script fails, you can use the set -e option.
# This option tells the shell to exit immediately if any command within the script exits with a non-zero status.
set -e

# Check if the video file is passed as an argument
if [ -z "$1" ]; then
    osascript -e 'display dialog "No video file specified." buttons {"CANCEL"}'
    exit 1
fi

videoFilename="$1"
filename="${videoFilename%.*}"
gifFilename="$filename.gif"

window_title="GIF Conversion Process"
window_title_end="GIF Conversion Process finished"

# Function to check if a window with the given title exists
is_window_open() {
    local window_title="$1"

    osascript -e 'tell application "System Events"' \
              -e 'tell process "System Events"' \
              -e 'if exists (window "'$window_title'") then' \
              -e 'set dialogExists to "true"' \
              -e 'else' \
              -e 'set dialogExists to "false"' \
              -e 'end if' \
              -e 'return dialogExists' \
              -e 'end tell' \
              -e 'end tell'
}

# Show a dialog box indicating the start of the process with a unique title, run in the background
osascript -e 'tell app "System Events" to display dialog "Starting GIF conversion for '"$videoFilename"'..." with title "'$window_title'" buttons {"OK"} default button "OK"' &

#######################################
### Starting the conversion process ###
### Conversion parameters
##  Speed Up Video Playback:
#     setpts=0.5*PTS: Speeds up the video by 2x.
#     Adjust the factor to control the speed:
#       setpts=0.25*PTS: Speeds up by 4x.
#       setpts=2*PTS: Slows down by 0.5x.
#
##  Control Frame Rate:
#      fps=10: Extracts 10 frames per second.
#       Lower fps reduces the number of frames, making the GIF smaller and potentially faster if the delay is adjusted.
#
##  Adjust Frame Delay in GIF:
#      -delay 5: Sets the delay between frames to 0.05 seconds.
#       Smaller values make the GIF play faster.
#
##  If You Want to Skip More Frames:
#       Use the select filter to pick frames at specific intervals.
#       Example: select='not(mod(n\,25))' selects every 25th frame.
##########################################
# --- Key Parameters (User Adjustable) ---

# Frames per second to extract (adjust to control smoothness and file size).
# The higher value, more frames are extracted, smoother animation and bigger resulting size
# Default 10
fps=5

# Factor to speed up or slow down the video (1 means normal speed; less than 1 speeds up, greater than 1 slows down)
# To speed up video by 2x: => '0.5'
setpts_factor=0.75

# Delay between frames in the GIF (in 1/100th of a second; lower values make the GIF play faster)
# Default 10
delay=6

# Number of frames to skip (1 means no skipping; higher values skip more frames)
# select='not(mod(n\\,${skip_frames}))' => The select filter picks frames based on the modulo of the frame number.
skip_frames=2

# --- End of Key Parameters ---
# filtersO="select='not(mod(n\,10))',setpts=1*PTS,fps=10,scale=1000:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=128[p];[s1][p]paletteuse=dither=bayer"

filters="select='not(mod(n\\,${skip_frames}))',setpts=${setpts_factor}*PTS,fps=${fps},scale=1000:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=128[p];[s1][p]paletteuse=dither=bayer"

echo -e "FILTRs are: $filters"

# Run the conversion
if $FFMPEG_PATH -i "$videoFilename" -vf "$filters" -c:v pam -f image2pipe - | convert -delay "$delay" - -loop 0 -layers optimize "$gifFilename"; then

    # Check if the dialog still exists and close it
    if [ "$(is_window_open "$window_title")" = "true" ]; then
        echo "The window '$window_title' is open."
        osascript -e 'tell application "System Events" to tell process "System Events" to click button "OK" of window "'$window_title'"'
        if [ $? != 0 ]; then echo "Failed to close the window."; fi
    else
        echo "The window '$window_title' is not open."
    fi

    # Show a system notification when the conversion is complete
    osascript -e 'display notification "GIF '$gifFilename' generated successfully!" with title "GIF Conversion"'

    # Show a dialog box when the conversion is complete
    osascript -e 'tell app "System Events" to display dialog "GIF conversion complete! File saved as '$gifFilename'." with title "'$window_title_end'" buttons {"OK"} default button "OK"'
else
    # Check if the dialog exists before trying to close it
    if [ "$(is_window_open "$window_title")" = "true" ]; then
        echo "The window '$window_title' is open."
        osascript -e 'tell application "System Events" to tell process "System Events" to click button "OK" of window "'$window_title'"'
        if [ $? != 0 ]; then echo "Failed to close the window."; fi
    else
        echo "The window '$window_title' is not open."
    fi

    # Show a system notification if the conversion fails
    osascript -e 'display notification "Failed to generate GIF from '$videoFilename'." with title "GIF Conversion Error"'

    # Show a dialog box if the conversion fails
    echo "Failed to generate GIF from '$videoFilename'."
    osascript -e 'tell app "System Events" to display dialog "Failed to generate GIF from '$videoFilename'." with title "'$window_title_end'" buttons {"CANCEL"} default button "CANCEL"'
    exit 1
fi

echo "Conversion complete: $gifFilename"
