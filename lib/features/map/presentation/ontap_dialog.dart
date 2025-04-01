import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class OntapDialog extends StatefulWidget {
  final MapObjectId gymName;
  const OntapDialog({super.key, required this.gymName});

  @override
  State<OntapDialog> createState() => _OntapDialogState();
}

class _OntapDialogState extends State<OntapDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.gymName.toString()),
      content: Text('Информация о зале'),
      actions: <Widget>[
        TextButton(
          child: Text('Закрыть'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
