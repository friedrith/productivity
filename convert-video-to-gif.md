# Convert Video to GIF

A script to convert a video file to a GIF file on macOS.

It is particulary useful when you want to add a screen recording to your Pull Request or issue while the platform only allows images like Bitbucket.

It uses the best settings to keep the GIF file size as small as possible since some platforms have a very low size limit for image files. It also maintains a good quality while reducing the framerate.

The script uses [`ffmpeg`](https://ffmpeg.org/) to extract the video frames and [`ImageMagick`](https://imagemagick.org/) to convert the frames to a GIF file.

## Getting started

```bash
brew install ffmpeg imagemagick

# if you are using macOS silicon
arch -arm64 brew install ffmpeg imagemagick
```

This script is available as a Apple shortcut. You can download it from the link below:

https://www.icloud.com/shortcuts/ec417cfcb32941f7aa9316b3c44c32ff

Then you will be able to convert a video to a GIF file from the context menu on the Finder app.

Or you can run the script directly:

```bash
./convert-video-to-gif.sh <video-filename>
```
