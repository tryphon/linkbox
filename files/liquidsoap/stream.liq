#!/usr/bin/liquidsoap

stream = input.http("http://localhost:8000/main.ogg")
output.alsa(device="plughw:0",fallback(track_sensitive = false, [stream, blank()]))
