import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// AI translated from Kotling to Dart

class ProfileImagePicker extends StatelessWidget {
  final File? imageFile;
  final ValueChanged<File?> onImageChanged;
  final ImagePicker _picker = ImagePicker();

  ProfileImagePicker({
    super.key,
    required this.imageFile,
    required this.onImageChanged,
  });

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        onImageChanged(File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${AppLocalizations.of(context)!.errorSelectingImage} $e')),
      );
    }
  }

  void _showImageSourceOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(l10n.camera),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera, context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.gallery),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showImageSourceOptions(context),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(0x4D),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Hero(
                    tag: 'profileImage',
                    child: imageFile != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(imageFile!),
                          )
                        : const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person,
                                size: 60, color: Colors.white),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tapToChangePhoto,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
