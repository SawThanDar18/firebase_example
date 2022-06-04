import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_padc/blocs/text_recognition_bloc.dart';
import 'package:firebase_padc/utils/extensions.dart';
import 'package:firebase_padc/widgets/primary_button_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../resources/dimens.dart';
import '../resources/strings.dart';

class TextRecognitionPage extends StatelessWidget {
  const TextRecognitionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TextRecognitionBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: APP_BAR_LEADING_WIDTH,
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: const [
                SizedBox(
                  width: MARGIN_MEDIUM,
                ),
                Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                ),
                SizedBox(
                  width: MARGIN_SMALL,
                ),
                Text(
                  LBL_BACK,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_LARGE),
          child: Center(
            child: Column(
              children: [
                Consumer<TextRecognitionBloc>(
                  builder: (context, bloc, child) {
                    return Visibility(
                      visible: bloc.chosenImageFile != null,
                      child: Image.file(
                        bloc.chosenImageFile ?? File(""),
                        width: 300,
                        height: 300,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: MARGIN_LARGE,
                ),
                Consumer<TextRecognitionBloc>(
                  builder: (context, bloc, child) {
                    return GestureDetector(
                      onTap: () {
                        ImagePicker()
                            .pickImage(source: ImageSource.gallery)
                            .then((value) async {
                          var bytes = await value?.readAsBytes();
                          bloc.onImageChosen(
                            File(value?.path ?? ""),
                            bytes ?? Uint8List(0),
                          );
                        }).catchError((error) {
                          showSnackBarWithMessage(
                              context, "Image cannot be picked");
                        });
                      },
                      child: const PrimaryButtonView(label: LBL_CHOOSE_IMAGE),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
