import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  const UserImagePicker(this.imagePickFn);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  Future<void> _pickImage() async {
    ImageSource source = ImageSource.gallery;
    if (Platform.isAndroid) source = ImageSource.camera;
    final image = await ImagePicker().pickImage(source: source, imageQuality: 50, maxWidth: 150);
    if (image == null) return;
    setState(() {
       _pickedImage = File(image.path);
    });
    widget.imagePickFn(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          child: _pickedImage == null ? Icon(Icons.person, size: 60,) : null,
          backgroundColor: Colors.purple,
          backgroundImage:
              _pickedImage == null ? null : FileImage(_pickedImage!),
        ),
        TextButton.icon(
            icon: Icon(Icons.image),
            label: Text('Add image'),
            onPressed: _pickImage),
      ],
    );
  }
}
