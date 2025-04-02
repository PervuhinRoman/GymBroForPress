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
    // return AlertDialog(
    //   title: Text(widget.gymName.toString()),
    //   content: Text('Информация о зале'),
    //   actions: <Widget>[
    //     TextButton(
    //       child: Text('Закрыть'),
    //       onPressed: () {
    //         Navigator.of(context).pop();
    //       },
    //     ),
    //   ],
    // );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Column(
          children: [
            Text(widget.gymName.toString()),
            Row(
              children: [
                Text(
                  "50%",
                  style: TextStyle(
                    fontSize: 72,
                  ),
                ),
                Column(
                  children: [
                    Text("Стартовая улица 2, Сириус"),
                    Flexible(child: Text("Средняя загруженность, можно идти в зал.Средняя загруженность, можно идти в зал.Средняя загруженность, можно идти в зал."))
                  ],
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 72),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(36))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(Icons.star),
                    ),
                    Text("Add to Favorite"),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
