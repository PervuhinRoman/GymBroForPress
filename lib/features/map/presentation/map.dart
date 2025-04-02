import 'package:flutter/material.dart';
import 'package:gymbro/features/map/presentation/ontap_dialog.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../domain/map_objects_service.dart';

class Map extends StatefulWidget {
  const Map(Key? key) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late YandexMapController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: FutureBuilder(future: mapService.getMapObjectsList(
            (PlacemarkMapObject placeMarkObject, Point point) {
              controller.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: point,
                    zoom: 16
                  ),
                ),
              );
              showModalBottomSheet(context: context, builder: (_) {
                return OntapDialog(gymName: placeMarkObject.mapId);
              });

        }), builder: (context, asyncValue) {
          final List<MapObject> mapObjects = [];
          if (asyncValue.hasData) {
            mapObjects.addAll(asyncValue.data!);
          }

          return YandexMap(
            nightModeEnabled: Theme.of(context).brightness == Brightness.dark ? true : false,
            logoAlignment: MapAlignment(
              horizontal: HorizontalAlignment.center,
              vertical: VerticalAlignment.top,
            ),
            mapObjects: mapObjects,
            onMapCreated: (YandexMapController yandexMapController) async {
              controller = yandexMapController;
              controller.moveCamera(
                CameraUpdate.newCameraPosition(
                  const CameraPosition(
                    target: Point(latitude: 43.405637, longitude: 39.954619),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
