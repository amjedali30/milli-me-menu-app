import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future compressImage(File _imageFile) async {
  List<int> imageBytes = await _imageFile.readAsBytes();
  Uint8List uint8List = Uint8List.fromList(imageBytes);
  List<int> compressedBytes = await FlutterImageCompress.compressWithList(
    uint8List,
    minHeight: 1920,
    minWidth: 1080,
    quality: 85,
  );

  // Save compressed file
  File compressedFile = _imageFile;
  await compressedFile.writeAsBytes(compressedBytes);

  return compressedFile;
}

String getFilenameFromUrl(String url) {
  Uri uri = Uri.parse(url);
  List<String> pathSegments = uri.pathSegments;
  String filenameWithPrefix = pathSegments.last;

  // Find the index of the first "/" character to remove the prefix
  int index = filenameWithPrefix.indexOf("/");

  // Return the filename without the prefix
  return filenameWithPrefix.substring(index + 1);
}
