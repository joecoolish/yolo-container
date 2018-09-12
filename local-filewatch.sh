#!/bin/bash
# This is a sample script used with the Open Source Software (OSS)
# Darknet is an open source neural network framework written in C and CUDA.
# You only look once (YOLO) is a real-time object detection system.
# The OSS sample code is built to process images serially.  This script
# sets up a queuing mechanism to process imagse as they arrive.
# This script was designed to run on Fedora systems (tested on CentOS based
# containers) and requires the packages:  inotify-tools libnotify-bin
set -o errexit
set -o nounset
shopt -s nullglob
# Define the CASE SENSITIVE paths for source, output and config files. (Don't forget the trailing /
FILES=/darknet/dbelocal/input/
PROCESSED=/darknet/dbesync/processed/
RAW=/darknet/dbelocal/raw/
CFG=/darknet/cfg/

FILECOUNT=1
cd /darknet/
# "Watching the directory for file changes that will be sent to the queue for processing"
while true
do
  # Setup a file system watcher to watch for changes in the $FILES directory
  if TRIGGER=`inotifywait -e close_write,moved_to --format %f $FILES/.`
  then
    until [ $FILECOUNT -eq 0 ]
    do
      for FN in $FILES/*
      do
        echo $FN
        # Echo out the commands to execute.  The commands will be appended int the queue for processing.
        # Execute the darknet image processor
        /darknet/darknet detect $CFG/yolov3.cfg $CFG/yolov3.weights "$FILES/${FN##*/}"
        # Move the files out of the queue once processed.
        mv -f "$FILES/${FN##*/}" "$RAW/${FN##*/}"
        # Move the prediction file into the processed directory.
        mv -f /darknet/predictions.png "$PROCESSED/${FN##*/}.png"
        FILECOUNT=`ls $FILES/*.jpg | wc -l`
      done
    done
  fi
done 
