import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadFilesToCloud(inputFile,
    {cloudLocation = "legal_docs", fileType = ".png"}) async {
  if (inputFile == null || inputFile.runtimeType == String) return inputFile;
  var postImageRef = FirebaseStorage.instance.ref().child(cloudLocation);
  UploadTask uploadTask = postImageRef
      .child(DateTime.now().toString() + fileType)
      .putFile(File(inputFile.path));
  log(uploadTask.toString());
  var instanceOfUploadTask = await uploadTask;
  String imageUrl = await instanceOfUploadTask.ref.getDownloadURL();
  return imageUrl.toString();
}
