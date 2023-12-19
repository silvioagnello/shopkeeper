import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;

  const ImageSourceSheet({super.key, required this.onImageSelected});

  void imageSelected(File image) async {
    if (image != null) {
      File croppedImage = (await ImageCropper().cropImage(
        sourcePath: image.path,
      ) //ratioX: 1.0, ratioY: 1.0),
          ) as File;
      onImageSelected(croppedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            child: const Text("Câmera"),
            onPressed: () async {
              File image = (await ImagePicker()
                  .pickImage(source: ImageSource.camera)) as File;
              imageSelected(image);
            },
          ),
          ElevatedButton(
            child: const Text("Galeria"),
            onPressed: () async {
              File image = (await ImagePicker()
                  .pickImage(source: ImageSource.gallery)) as File;
              imageSelected(image);
            },
          )
        ],
      ),
    );
  }
}
