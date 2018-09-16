#!/bin/bash

git clone https://github.com/pjreddie/darknet
cd darknet
make

wget https://pjreddie.com/media/files/yolov3.weights
wget https://pjreddie.com/media/files/yolov3-tiny.weights 
wget https://pjreddie.com/media/files/yolov2.weights