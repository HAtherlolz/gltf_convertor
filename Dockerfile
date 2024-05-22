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