# this is a dockerfile to package eCAL and some applications

FROM ubuntu:focal
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y
# install prerequisites    
RUN apt-get install -y git python3-pip curl libqt5multimedia5-plugins software-properties-common

# install eCAL
RUN add-apt-repository -y ppa:ecal/ecal-5.11 && \
    apt-get install -y ecal
    
WORKDIR /app/ecal-camera-samples    
RUN curl -LJO https://github.com/eclipse-ecal/ecal-camera-samples/releases/download/v1.0.0/ecal-camera-samples-ubuntu-20.04-ecal-5.11.deb -o  ecal-camera-samples-ubuntu-20.04-ecal-5.11.deb && \
    dpkg -i ecal-camera-samples*.deb 
    
# install the eCAL camera sample
WORKDIR /app/ecal-foxglove-bridge  
RUN git clone https://github.com/eclipse-ecal/ecal-foxglove-bridge.git /app/ecal-foxglove-bridge && \
    curl -LJO https://github.com/eclipse-ecal/ecal/releases/download/v5.11.3/ecal5-5.11.3-1focal-cp38-cp38-linux_x86_64.whl -o ecal5-5.11.3-1focal-cp38-cp38-linux_x86_64.whl && \
    pip install -r python/requirements.txt && \
    pip install ./ecal5-5.11.3-1focal-cp38-cp38-linux_x86_64.whl
 
CMD ["python3", "/app/ecal-foxglove-bridge/python/ecal-foxglove-bridge.py"]