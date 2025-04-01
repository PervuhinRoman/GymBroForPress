import 'package:flutter/material.dart';

class EditButton extends IconButton {
  const EditButton({
    super.key, 
    required super.onPressed, 
    required super.icon,
  });

  @override
  IconButton build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: onPressed,
    );
  }
}
