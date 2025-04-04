import 'package:flutter/material.dart';
import 'package:gymbro/features/map/presentation/percentage_indicator.dart';
import 'map.dart';
import 'select_button.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          // Кнопка назад
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          // Карта
          Expanded(child: Map()),
          SelectButton(),
        ],
      ),
    );
    // return
    //   Scaffold(
    //       body: Center(
    //         child: PercentageIndicator(
    //           percentage: 80,
    //           height: 150,
    //           width: 200,
    //           title: "Низкая загруженность",
    //           subtitle: "Есть более свободные",
    //         ),
    //       ));
  }
}