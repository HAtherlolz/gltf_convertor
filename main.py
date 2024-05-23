# ==== Vanilla libs ====
import os
import shutil
import zipfile

from typing import Tuple, List, NoReturn

# ==== Third part libs ====
import bpy
import rarfile


class GLTFConvertor:
    model_importers = {
        "fbx": bpy.ops.import_scene.fbx,
        "obj": bpy.ops.import_scene.obj,
        "stl": bpy.ops.import_mesh.stl
    }

    def __init__(
            self,
            archive_path: str,
            tmp_path: str,
            output_path: str,
            model_file_extensions: Tuple = (".obj", ".fbx", ".stl"),
            textures_file_extensions: Tuple = (".png", ".jpg", ".bmp", ".tga", ".tif")
    ):
        """
       - Required args:
       :param archive_path:                - path to archive
       :param tmp_path:                    - path for temporary directory (creates and deletes after converting)
       :param output_path:                 - path for converted .gltf model and textures

       - Non required args:
       :param model_file_extensions:       - tuple of allowed extensions for models file
       :param textures_file_extensions:    - tuple of allowed extensions for textures file
       """
        self.archive_path = archive_path
        self.tmp_path = tmp_path
        self.output_path = output_path
        self.model_file_extensions = model_file_extensions
        self.textures_file_extensions = textures_file_extensions

    def _tmp_dir_get_or_create(self) -> NoReturn:
        """ Ensure the extraction directory exists """
        if not os.path.exists(self.tmp_path):
            os.makedirs(self.tmp_path)

    def _output_dir_get_or_create(self) -> NoReturn:
        """ Ensure the extraction directory exists """
        if not os.path.exists(self.output_path):
            os.makedirs(self.output_path)

    def _extract(self) -> str:
        """
            Checks the extensions of the
            archive and extract it to self.tmp_path
        """
        self._tmp_dir_get_or_create()

        if self.archive_path.split(".")[1] == "zip":
            with zipfile.ZipFile(self.archive_path, 'r') as zip_ref:
                zip_ref.extractall(self.tmp_path)
        elif self.archive_path.split(".")[1] == "rar":
            with rarfile.RarFile(self.archive_path, 'r') as rar_ref:
                rar_ref.extractall(self.tmp_path)

        return self.tmp_path

    def _extract_model_and_textures(self) -> Tuple[str, str, List[str]]:
        """
            Gets the model file and textures from temp dir
        """
        file_path = None
        file_name = None
        textures = list()
        tmp_dir = self._extract()

        for root, dirs, files in os.walk(tmp_dir):
            for file in files:
                if file.endswith(self.model_file_extensions):
                    file_path = os.path.join(root, file)
                    file_name = file
                elif file.endswith(self.textures_file_extensions):
                    textures.append(os.path.join(root, file))
            if file_path:
                break

        if not file_path:
            raise FileNotFoundError("No models file found in the archive.")

        return file_name, file_path, textures

    @staticmethod
    def _apply_textures(textures: List[str], texture_output_dir: str) -> NoReturn:
        """ Copy textures to the output directory and update their paths """
        if not os.path.exists(texture_output_dir):
            os.makedirs(texture_output_dir)

        for texture in textures:
            new_texture_path = os.path.join(texture_output_dir, os.path.basename(texture))
            shutil.copy(texture, new_texture_path)

    def convert_to_gltf(self) -> NoReturn:
        """
            Gets file extension and convert target model to gltf
        """
        bpy.ops.wm.read_factory_settings(use_empty=True)  # Creates new scene

        file_name, file_path, textures = self._extract_model_and_textures()
        models_file_extension = file_path.split(".")[1]

        # Gets a right model importer and imports the scene
        self.model_importers[models_file_extension](filepath=file_path)
        self._output_dir_get_or_create()
        output = f"{self.output_path}/{file_name}"

        bpy.ops.export_scene.gltf(filepath=output, export_format='GLTF_SEPARATE')

        # Write the textures near the model
        textures_output_dir = os.path.join(self.output_path, "textures")
        self._apply_textures(textures, textures_output_dir)

        # Remove tmp dir
        shutil.rmtree(self.tmp_path)


if __name__ == "__main__":
    archive_path = os.getenv('ARCHIVE_PATH')
    tmp_path = os.getenv('TMP_PATH')
    output_path = os.getenv('OUTPUT_PATH')

    # zip_file_path = "data/supersushi.zip"
    # extracted_dir = "/tmp/supersushi_extracted_zip"
    # output_file_path = "output_zip"
    zip_file_path = archive_path
    extracted_dir = tmp_path
    output_file_path = output_path
    print("zip_file_path: ", zip_file_path)
    print("extracted_dir: ", extracted_dir)
    print("output_file_path: ", output_file_path)
    convertor_zip = GLTFConvertor(zip_file_path, extracted_dir, output_file_path)
    convertor_zip.convert_to_gltf()

    # rar_file_path = "data/SushiCart.rar"
    # extracted_dir = "/tmp/supersushi_extracted_rar"
    # output_file_path = "output_rar"
    # convertor_rar = GLTFConvertor(rar_file_path, extracted_dir, output_file_path)
    # convertor_rar.convert_to_gltf()

    print("Conversion completed successfully!")
