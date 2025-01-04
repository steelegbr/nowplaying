# Now Playing

Now playing overlay for OBS. Can handle multiple stations and feeds. This consists of a web service and a client. The client pushes the now playing information up to the web service. The web service provides an interface that OBS can render. A little complicated but works for me.

## Kivy on Windows

Poetry will install most dependancies but NOT Kivy on Windows. To achieve this, you'll also need to run:

	poetry run python -m pip install "kivy[base]" --pre --extra-index-url https://kivy.org/downloads/simple/

## Animations on OBS

There is a known issue with animations not working on OBS. It is hoped a new release with a difference Chromium version will fix this.