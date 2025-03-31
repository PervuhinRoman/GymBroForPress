import 'package:flutter/material.dart';
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

    // mapObjects
    //   ..add(obj)
    //   ..add(place);
  }

  //List<MapObject> mapObjects = [];

  // final MapObjectId mapObjectId = const MapObjectId('map_object_collection');
  // final MapObjectId mapObjectWithDynamicIconId = const MapObjectId('dynamic_icon_place-mark');

  // PlacemarkMapObject obj = PlacemarkMapObject(
  //   mapId: const MapObjectId('obj'),
  //   point: const Point(latitude: 55.7522, longitude: 37.6156),
  //   onTap: (PlacemarkMapObject self, Point point) {},
  //   icon: PlacemarkIcon.single(
  //     PlacemarkIconStyle(
  //       image: BitmapDescriptor.fromAssetImage(
  //         'assets/images/placemark-dumbells.png',
  //       ),
  //       scale: 3,
  //     ),
  //   ),
  // );
  //
  // final PlacemarkMapObject place = PlacemarkMapObject(
  //   mapId: const MapObjectId('place'),
  //   point: const Point(latitude: 55.743116, longitude: 37.611992),
  //   icon: PlacemarkIcon.single(
  //     PlacemarkIconStyle(
  //       image: BitmapDescriptor.fromAssetImage(
  //         'assets/images/placemark-dumbells.png',
  //       ),
  //       scale: 3,
  //     ),
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Positioned.fill(
            child: Container(
              margin: EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.0),
                child: FutureBuilder(
                    future: mapService.getMapObjectsList(() {}),
                    builder: (context, asyncValue) {
                      final List<MapObject> mapObjects = [];
                      if (asyncValue.hasData) {
                        mapObjects.addAll(asyncValue.data!);
                      }

                      return YandexMap(
                        logoAlignment: MapAlignment(
                          horizontal: HorizontalAlignment.center,
                          vertical: VerticalAlignment.top,
                        ),
                        mapObjects: mapObjects,
                        onMapCreated:
                            (YandexMapController yandexMapController) async {
                          controller = yandexMapController;
                          controller.moveCamera(
                            CameraUpdate.newCameraPosition(
                              const CameraPosition(
                                target: Point(
                                    latitude: 43.405637, longitude: 39.954619),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
