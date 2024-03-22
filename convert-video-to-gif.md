# Convert Video to GIF

Sometimes you need to convert a video like a screen recording to a high-quality GIF file. This is the tool to do that on macOS.

It is particulary useful when you want to add a screen recording to your Pull Request or issue while the platform only allows images like Bitbucket.
It uses the best settings to keep the GIF file size as small as possible since some platforms have a very low size limit for image files. It also maintains a good quality while reducing the framerate.

You can check a [demo GIF there](https://github.com/friedrith/productivity/assets/4005226/e752691e-03d9-4a2e-9232-71f814e56b3c).

## Getting started

The tool uses [`ffmpeg`](https://ffmpeg.org/) to extract the video frames and [`ImageMagick`](https://imagemagick.org/) to convert the frames to a GIF file.

```bash
brew install ffmpeg imagemagick

# if you are using macOS silicon
arch -arm64 brew install ffmpeg imagemagick
```

## Apple Shortcut

This tool is available as a Apple shortcut. You can install it from the link below:

https://www.icloud.com/shortcuts/ec417cfcb32941f7aa9316b3c44c32ff

Then you will be able to convert a video to a GIF file from the context menu on the Finder app.

![convert a video from the context menu](https://github.com/friedrith/productivity/assets/4005226/d9ff32f1-4a83-4409-ba1a-a3bae35df3d5)

## Script

You can also run the script directly:

```bash
curl https://raw.githubusercontent.com/friedrith/productivity/master/convert-video-to-gif.sh -o convert-video-to-gif.sh
./convert-video-to-gif.sh <video-filename>
```
