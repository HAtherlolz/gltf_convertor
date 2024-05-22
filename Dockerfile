#FROM ubuntu:latest
#
## Install dependencies
#RUN apt-get update && apt-get install -y \
#    wget \
#    unzip \
#    xz-utils
#
## Set working directory
#WORKDIR /app
#
## Download Blender
#RUN wget https://download.blender.org/release/Blender2.83/blender-2.83.0-linux64.tar.xz
#
## Extract Blender
#RUN tar -xf blender-2.83.0-linux64.tar.xz && rm blender-2.83.0-linux64.tar.xz
#
## Rename extracted directory to 'blender'
#RUN mv blender-2.83.0-linux64 blender
#
## Copy script and data files into the container
#COPY test.py /app/test.py
#COPY data/supersushi.zip /app/data/supersushi.zip
#
## Run the script
#CMD /app/blender/blender -b -P test.py

# Use the official Ubuntu image as the base
#FROM ubuntu:latest
#
## Update and install dependencies
#RUN apt-get update && apt-get install -y \
#    wget \
#    unzip \
#    unrar \
##    libglu1-mesa \
##    libxi6 \
##    libxrender1 \
##    libxrandr2 \
##    libdbus-1-3 \
##    libnss3 \
##    libxcomposite1 \
##    libxcursor1 \
##    libxdamage1 \
##    libxfixes3 \
##    libasound2 \
##    libatk1.0-0 \
##    libatk-bridge2.0-0 \
##    libcups2 \
##    libdrm2 \
##    libgbm1 \
##    libxkbcommon0 \
##    libxshmfence1 \
##    libpango1.0-0 \
##    libwayland-client0 \
##    libwayland-cursor0 \
##    libwayland-egl1 \
##    libepoxy0 \
##    && rm -rf /var/lib/apt/lists/*
#
## Download and install Blender
#RUN wget https://download.blender.org/release/Blender2.92/blender-2.92.0-linux64.tar.xz \
#    && tar -xf blender-2.92.0-linux64.tar.xz \
#    && mv blender-2.92.0-linux64 /opt/blender \
#    && rm blender-2.92.0-linux64.tar.xz
#
## Add Blender to PATH
#ENV PATH="/opt/blender:$PATH"
#
## Install pip within Blender's Python environment and the rarfile library
#RUN /opt/blender/2.92/python/bin/python3.7m -m ensurepip \
#    && /opt/blender/2.92/python/bin/python3.7m -m pip install --upgrade pip \
#    && /opt/blender/2.92/python/bin/python3.7m -m pip install rarfile
#
## Create a directory for the Blender script
##WORKDIR /usr/src/app
#
### Copy your Blender Python script into the container
##COPY your_blender_script.py .
##
### Set default argument values (can be overridden)
##ENV SCRIPT_ARGS=""
##
### Command to run Blender with your script and arguments
##CMD ["sh", "-c", "blender --background --python your_blender_script.py -- $SCRIPT_ARGS"]


#FROM ubuntu:latest
#
## Update and install dependencies
#RUN apt-get update && apt-get install -y \
#    wget \
#    unzip \
#    unrar
#
## Download and install Blender
#RUN wget https://download.blender.org/release/Blender2.92/blender-2.92.0-linux64.tar.xz \
#    && tar -xf blender-2.92.0-linux64.tar.xz \
#    && mv blender-2.92.0-linux64 /opt/blender \
#    && rm blender-2.92.0-linux64.tar.xz
#
## Add Blender to PATH
#ENV PATH="/opt/blender/blender-2.92.0-linux64:$PATH"
#
## Install pip within Blender's Python environment and the rarfile library
#RUN /opt/blender/blender-2.92.0-linux64/2.92/python/bin/python3.7m -m ensurepip \
#    && /opt/blender/blender-2.92.0-linux64/2.92/python/bin/python3.7m -m pip install --upgrade pip \
#    && /opt/blender/blender-2.92.0-linux64/2.92/python/bin/python3.7m -m pip install rarfile



FROM ubuntu:bionic

ENV APP /app
RUN mkdir $APP
WORKDIR $APP

RUN apt-get update && \
	apt-get install -y \
		curl \
		libfreetype6 \
		libglu1-mesa \
		libxi6 \
        unrar \
		libxrender1 \
		xz-utils && \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists/*

ENV BLENDER_MAJOR 2.82
ENV BLENDER_VERSION 2.82a
ENV BLENDER_URL https://download.blender.org/release/Blender${BLENDER_MAJOR}/blender-${BLENDER_VERSION}-linux64.tar.xz

RUN curl -L ${BLENDER_URL} | tar -xJ -C /usr/local/ && \
	mv /usr/local/blender-${BLENDER_VERSION}-linux64 /usr/local/blender

## Install pip within Blender's Python environment and the rarfile library
RUN /usr/local/blender/2.82/python/bin/python3.7m -m ensurepip \
    && /usr/local/blender/2.82/python/bin/python3.7m -m pip install --upgrade pip \
    && /usr/local/blender/2.82/python/bin/python3.7m -m pip install rarfile

COPY . .

VOLUME /media
#ENTRYPOINT ["/usr/local/blender/blender", "-b"]