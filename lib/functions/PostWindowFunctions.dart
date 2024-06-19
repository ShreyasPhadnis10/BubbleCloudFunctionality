import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../pages/main/camera/displayImage.dart';

class PostWindowFunctions {
  static Future<void> openGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DisplayImage(filePath: pickedFile.path)));
    }
  }

  static Future<void> openVideos() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? pickedFile =
        await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      DisplayImage(filePath: pickedFile.path);
    }
  }

  static Future<String> setGalleryImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      return "There was an error while loading the image";
    }
  }
}
