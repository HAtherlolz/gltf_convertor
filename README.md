# TODO: change output file generation

# To run locally use the command below

# ======== LOCALLY macOS ========
#### install "unar" for macOS package to your system
#### /Applications/Blender.app/Contents/MacOS/Blender -b -P convertor.py
#### /Applications/Blender.app/Contents/Resources/4.1/python/bin/python3.11 -m pip install rarfile


# ======== DOCKER ========
### /usr/local/blender/2.82/python/bin/python3.7m
### RUN IN DOCKER
#### docker exec -it -e ARCHIVE_PATH={{ path }} -e TMP_PATH={{ path }} -e OUTPUT_PATH={{ path }} {{ container_name }} /usr/local/blender/blender -b -P main.py
  `docker exec -it -e ARCHIVE_PATH=data/supersushi.zip -e TMP_PATH=tmp/supersushi_extracted_zip -e OUTPUT_PATH=out gltf_convertor_blender_1 /usr/local/blender/blender -b -P main.py`

