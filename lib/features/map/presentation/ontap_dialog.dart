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
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 16),
      child: IntrinsicHeight(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.sports_basketball_rounded),
                  ),
                  Text(widget.gymName.value,
                      style: Theme.of(context).textTheme.displaySmall),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "50%",
                  style: TextStyle(
                    fontSize: 72,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Стартовая улица 2, Сириус",
                                style: Theme.of(context).textTheme.bodyLarge)),
                        SizedBox(height: 16),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "Средняя загруженность, можно идти в зал",
                                style: Theme.of(context).textTheme.bodyLarge)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
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
                        child: Icon(Icons.star_border, size: 32),
                      ),
                      Text(
                        "Add to Favorite",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
