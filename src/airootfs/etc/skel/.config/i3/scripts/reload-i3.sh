#!/bin/bash

source_files="$HOME/.config/i3/src"
i3_config="$HOME/.config/i3/config"
rm -f $i3_config
cat $source_files/* >> $i3_config
i3-msg reload