#!/bin/bash
set -e

[ -d ~/Documents/ArchLinux ] || mkdir ~/Documents/ArchLinux

echo "moving iso to documents"
cp ~/archlinux-build/archiso/out/archlinux* ~/Documents/ArchLinux
