import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_padc/ml_kit/ml_kit_text_recognition.dart';
import 'package:flutter/cupertino.dart';

class TextRecognitionBloc extends ChangeNotifier {
  File? chosenImageFile;

  final MLKitTextRecognition _mlKitTextRecognition = MLKitTextRecognition();

  onImageChosen(File imageFile, Uint8List bytes) {
    chosenImageFile = imageFile;
    _mlKitTextRecognition.detectTexts(imageFile);
    notifyListeners();
  }
}
