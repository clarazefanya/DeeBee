import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageConverter {
  static String uint8ListToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  static Uint8List base64ToUint8List(String base64String) {
    return base64Decode(base64String);
  }

  static Future<String> compressAndConvertToBase64(Uint8List bytes) async {
    Uint8List currentBytes = bytes;

    // target maksimal 300 KB
    const targetSize = 300 * 1024;
    int quality = 90;

    while (currentBytes.lengthInBytes > targetSize && quality >= 20) {
      currentBytes = Uint8List.fromList(
        await FlutterImageCompress.compressWithList(
          currentBytes,
          quality: quality,
        ),
      );
      quality -= 10;
    }
    return base64Encode(currentBytes);
  }
}
