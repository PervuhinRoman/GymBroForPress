import 'dart:io';

class PhotoWidgetService {
  static Future<void> deleteImageByPath(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      } 
    } catch (e) {
      // Womp-womp
    }
  }
}

