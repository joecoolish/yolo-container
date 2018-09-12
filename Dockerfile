# Run with:
# docker run --rm -ti -v c:/imagesYOLO:/imagesToProcess/ -v c:/images:/darknet/dbesync/processed/ -p 12345:12345 joecoolish/yolo
FROM ubuntu
LABEL version="1.0"
LABEL description="You only look once (YOLO) is a real-time object detection system. Darknet is an open source neural network."

# Create app directory
WORKDIR /

RUN apt-get update && apt-get install -y \
  dos2unix \
  gcc \
  git \
  make \
  netcat \
  ucspi-tcp \
  wget

COPY install.sh .
RUN chmod +x install.sh
RUN dos2unix install.sh
RUN /bin/sh ./install.sh

COPY ./remote-execute.sh /darknet/
RUN chmod +x /darknet/remote-execute.sh
RUN dos2unix /darknet/remote-execute.sh
COPY ./darknet-listener.sh .
RUN chmod +x ./darknet-listener.sh
RUN dos2unix ./darknet-listener.sh
COPY ./local-filewatch.sh .
RUN chmod +x ./local-filewatch.sh
RUN dos2unix ./local-filewatch.sh

CMD ./darknet-listener.sh
#CMD ./local-filewatch.sh