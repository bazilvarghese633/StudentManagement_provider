import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPageProvider extends ChangeNotifier {
  String? profileImagepath;
  XFile? image;

  void setImage(XFile? img) {
    image = img;
    profileImagepath = img?.path;
    notifyListeners();
  }

  void clearImage() {
    image = null;
    profileImagepath = null;
    notifyListeners();
  }
}
