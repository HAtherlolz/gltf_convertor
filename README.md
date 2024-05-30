# GLTF Convertor

This Python module provides a convenient way to convert 3D models and textures from various formats into the GLTF format.

## Features

- Supports conversion from formats such as OBJ, FBX, STL to GLTF.
- Extracts models and textures from archives (ZIP, RAR) and converts them.
- Copies textures to the output directory and updates their paths.
- Removes temporary directories after conversion.

## Usage

To use the GLTF Convertor, follow the steps below:

### Installation

- Ensure you have Python 3.7+ installed.
- Install the required dependencies by running:


### Running Locally (macOS)

1. Install "unar" for macOS package to your system.
2. Run the following command:

```/Applications/Blender.app/Contents/MacOS/Blender -b -P convertor.py```

### Running in Docker

1. Ensure you have Docker installed on your system.
2. Build and run the Docker container.
3. Execute the conversion process within the Docker container using the following command:

```docker exec -it -e ARCHIVE_PATH={{ path }} -e TMP_PATH={{ path }} -e OUTPUT_PATH={{ path }} {{ container_name }} /usr/local/blender/blender -b -P main.py```

## Note

The output file generation logic in the code is marked as TODO. You may need to customize it according to your specific requirements.

## Requirements

- Python 3.7+
- Blender (for conversion)
- unar (for macOS)
- rarfile library


