#!/bin/bash

PROCESSED=/darknet/dbesync/processed
RAW=/darknet/dbelocal/raw/
CFG=/darknet/cfg
cd "/darknet/"
printf "Listening on port: 12345\n"

dos2unix $CFG/coco.data
dos2unix $CFG/yolov3.cfg
dos2unix $CFG/yolov2.cfg
dos2unix $CFG/yolov3-tiny.cfg

while true
do
    line="TEMP"
    printf "Ready to read file\n"

    while read inside
    do
        printf "inside: $inside\n"
        line=$inside
        printf "End the loop: $process\n"

        pkill netcat
    done < <(netcat -l -p 12345)

    printf "outside: $line\n"

    if [ -f "$line" ]
    then
        fileName=$(basename "$line")
        echo "Processing file: $line"
        echo "$PROCESSED/$fileName.jpg"
        ./darknet detect $CFG/yolov$YOLO_VER.cfg yolov$YOLO_VER.weights "$line"

        if [ -f /darknet/predictions.jpg ]
        then    
            mv -f /darknet/predictions.jpg "$PROCESSED/$fileName.jpg"
        fi
    fi

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