
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';

import '../utils/size_config.dart';

void showImagePickerSheet(
    {context,setState,  required Function(XFile) onImageSelected,
      required BoxConstraints constraints}) {
  FocusManager.instance.primaryFocus?.unfocus();
  SystemChannels.textInput.invokeMethod('TextInput.hide');
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    currentFocus.focusedChild?.unfocus();
  }
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (context) {
        return Container(
          height: getProportionateHeight(300, constraints),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                "Choose Profile Picture",
                size: Theme.of(context).textTheme.titleLarge?.fontSize,
                weight: FontWeight.bold,
              ),
              const SizedBox(
                height: 8,
              ),
              TextWidget(
                "Choose an image as a profile picture from one of the following sources",
                flow: TextOverflow.visible,
                size: Theme.of(context).textTheme.bodyLarge?.fontSize,
                weight: Theme.of(context).textTheme.bodyLarge?.fontWeight,
              ),
              const Spacer(),
              Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Icon(Icons.photo_library_rounded, size: 48),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 3,
                    child: Icon(Icons.camera_alt_rounded, size: 48),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor:
                          Theme.of(context).colorScheme.onPrimary,
                          backgroundColor:
                          Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () async {
                        var pickedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        setState(() {
                          Navigator.of(context).pop();
                          if (pickedImage != null) {
                            onImageSelected(pickedImage);
                          } else {
                            Future.delayed(const Duration(milliseconds: 300),
                                    () {
                                  snackbar(context,
                                      "The image you selected is empty or you didn't select an image.");
                                });
                          }
                        });
                      },
                      child: const Text(
                        "Gallery",
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor:
                          Theme.of(context).colorScheme.onPrimary,
                          backgroundColor:
                          Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () async {
                        var pickedImage = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        setState(() {
                          Navigator.of(context).pop();
                          if (pickedImage != null) {
                            onImageSelected(pickedImage);
                          } else {
                            Future.delayed(const Duration(milliseconds: 300),
                                    () {
                                  snackbar(context,
                                      "The image you selected is empty or you didn't select an image.");
                                });
                          }
                        });
                      },
                      child: const Text("Camera"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}

