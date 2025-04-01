import 'package:flutter/material.dart';

// /// Flutter code sample for [showModalBottomSheet].

// void main() => runApp(const BottomSheetApp());

// class BottomSheetApp extends StatelessWidget {
//   const BottomSheetApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Bottom Sheet Sample')),
//         body: const BottomSheetExample(),
//       ),
//     );
//   }
// }


class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      tooltip: "Show settings",
      onPressed: () {
        showModalBottomSheet<void>(
          showDragHandle: true,
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Test Settings'),
                    ElevatedButton(
                      child: const Text('Close Settings'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}