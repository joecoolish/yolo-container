#!/bin/bash

PROCESSED=/darknet/dbesync/processed
RAW=/darknet/dbelocal/raw/
CFG=/darknet/cfg

read LINE
if [ -f "$LINE" ]
then
    fileName=$(basename $LINE)
    printf "Processing file: $LINE\n"
    /darknet/darknet detect $CFG/yolov3.cfg /darknet/yolov3.weights "$LINE"
    printf "Copying to: $PROCESSED/$fileName.png\n"
    mv -f /darknet/predictions.png "$PROCESSED/$fileName.png"
fi