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
RUN ./install.sh

COPY ./remote-execute.sh /darknet/
RUN chmod +x /darknet/remote-execute.sh
COPY ./darknet-listener.sh .
COPY ./local-filewatch.sh .

CMD ./darknet-listener.sh
#CMD ./local-filewatch.sh