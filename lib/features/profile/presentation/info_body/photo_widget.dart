import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymbro/features/profile/presentation/info_body/photo_widget_service.dart';

class PhotoWidget extends StatelessWidget {
  final String imagePath; // The path to the image

  const PhotoWidget({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: 9/16,
            child: Image.file(
              File(imagePath), 
              fit: BoxFit.cover, 
            ),
          ),
        ),
        
        Material(
          elevation: 2,
          shape: CircleBorder(),
          child: ClipOval(
            child: SizedBox(
              width: 25,
              height: 25,
              child: ColoredBox(
                color: Theme.of(context).colorScheme.surface,
                
                child: TextButton(
                  child: Icon(Icons.delete_outline),
                  // iconSize: 15,
                  onPressed: () => _showDeleteDialog(context),
                  // tooltip: 'Delete Image',
                ),
              ),
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                PhotoWidgetService.deleteImageByPath(imagePath); 
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
