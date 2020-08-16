#!/bin/sh

# xinitrc runs automatically when you run startx.
[ -f ~/.xprofile ] && . ~/.xprofile

ssh-agent i3
