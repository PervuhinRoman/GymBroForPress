import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<List<File>> getSavedImages() async {
  final directory = await getApplicationDocumentsDirectory();
  final imageDirectory = Directory('${directory.path}/personal_images');
  if (!await imageDirectory.exists()) {
    await imageDirectory.create(recursive: true);
  }
  final List<FileSystemEntity> files = imageDirectory.listSync();

  return files.whereType<File>().toList();
}

Future<void> saveImage(XFile image) async {
  Directory appDir = await getApplicationDocumentsDirectory();
  Directory imageDir = Directory('${appDir.path}/personal_images');
  if (!await imageDir.exists()) {
    await imageDir.create(recursive: true);
  }
  String newPath = '${imageDir.path}/${image.name}';

  await File(image.path).copy(newPath);
}

Future<void> pickAndSaveImage(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source);

  if (image != null) {
    await saveImage(image);
  } else {
    print('No image selected');
  }
}
