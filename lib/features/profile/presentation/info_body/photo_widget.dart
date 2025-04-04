import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymbro/features/profile/domain/photo_widget_service.dart';

class PhotoWidget extends StatefulWidget {
  final String imagePath; // The path to the image

  const PhotoWidget({
    super.key,
    required this.imagePath,
  });

  @override
  _PhotoWidgetState createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> {
  bool _isCached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isCached) {
      // Use didChangeDependencies to ensure context is fully initialized
      precacheImage(FileImage(File(widget.imagePath)), context).then((_) {
        setState(() {
          _isCached = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // While the image is being cached, show a placeholder
    if (!_isCached) {
      return const Center(child: CircularProgressIndicator());
    }
    
    // Once cached, display the image with the delete button
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Image.file(
              File(widget.imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Material(
          elevation: 2,
          shape: const CircleBorder(),
          child: SizedBox(
            height: 30,
            width: 30,
            child: IconButton.outlined(
              padding: EdgeInsets.zero,
              onPressed: () => _showDeleteDialog(context),
              icon: const Icon(Icons.delete_outline, size: 15),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Image'),
          content: const Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await PhotoWidgetService.deleteImageByPath(widget.imagePath);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
