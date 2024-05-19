FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xz-utils

# Set working directory
WORKDIR /app

# Download Blender
RUN wget https://download.blender.org/release/Blender2.83/blender-2.83.0-linux64.tar.xz

# Extract Blender
RUN tar -xf blender-2.83.0-linux64.tar.xz && rm blender-2.83.0-linux64.tar.xz

# Rename extracted directory to 'blender'
RUN mv blender-2.83.0-linux64 blender

# Copy script and data files into the container
COPY test.py /app/test.py
COPY data/supersushi.zip /app/data/supersushi.zip

# Run the script
CMD /app/blender/blender -b -P test.py
