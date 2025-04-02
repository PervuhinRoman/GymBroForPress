import 'package:flutter/material.dart';
import 'map.dart';
import 'select_button.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 64),
          Expanded(child: Map(key: key)),
          SelectButton(key: key),
        ],
      ),
    );
  }
}