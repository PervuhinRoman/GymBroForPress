import 'dart:io';

class PhotoWidgetService {
  static Future<void> deleteImageByPath(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        print('Image deleted from: $imagePath');
      } else {
        print('Image does not exist');
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}

