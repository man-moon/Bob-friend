import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void pickImage() async {
  final imagePicker = ImagePicker();
  final pickedImage = await imagePicker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 50,
  );


}

void showImagePicker(BuildContext context){
  showDialog(
    context: context,
    builder: (context){
      return Dialog(
        child: Container(

        ),
      );
    }
  );
}