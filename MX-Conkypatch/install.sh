#!/bin/bash
mkdir -p ~/.conkypatch
mkdir -p ~/.conkypatch/icons
cp -v conky.conf ~/.conkypatch
cp -v -r icons/* ~/.conkypatch/icons/
mkdir -p ~/.fonts
cp -v -r fonts ~/.fonts/

