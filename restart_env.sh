#!/bin/bash

# folder exists /tmp/packing ?
if [ -d /tmp/packing ]; then
  # rm
  sudo rm -r /tmp/packing
fi

rm *.xz >/dev/null 2>&1
rm debian-binary >/dev/null 2>&1
rm ninvaders.deb >/dev/null 2>&1
