#!/bin/bash

PROCESSED=/darknet/dbesync/processed
RAW=/darknet/dbelocal/raw/
CFG=/darknet/cfg
cd "/darknet/"
printf "Listening on port: 12345\n"

dos2unix /darknet/cfg/coco.data
dos2unix /darknet/cfg/yolov3.cfg

while true
do
    printf "Ready to read file\n"
    process=true

    netcat -l -p 12345 | while $process
    do
        process=false
        read line
        printf "line: $line\n"
        if [ -f "$line" ]
        then
            fileName=$(basename $line)
            echo "Processing file: $line"
            echo "$PROCESSED/$fileName.png"
            ./darknet detect cfg/yolov3.cfg yolov3.weights "$line"

            if [ -f /darknet/predictions.png ]
            then    
                mv -f /darknet/predictions.png "$PROCESSED/$fileName.png"
            fi
        fi

        printf "End the loop: $process\n"
    done
    # netcat -l -p 12345 | read LINE
    # if [ -f "$LINE" ]
    # then
    #     fileName=$(basename $LINE)
    #     printf "Processing file: $LINE\n"
    #     /darknet/darknet detect $CFG/yolov3.cfg /darknet/yolov3.weights "$LINE"
    #     printf "Copying to: $PROCESSED/$fileName.png\n"
    #     mv -f /darknet/predictions.png "$PROCESSED/$fileName.png"
    # fi
done

#tcpserver -H -R 0.0.0.0 12345 "/darknet/remote-execute.sh"

printf "tcpserver running\n"