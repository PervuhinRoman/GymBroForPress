import 'package:yandex_mapkit/yandex_mapkit.dart';

class GymPlace {
  final double latitude;
  final double longitude;
  final String mapObjectId;
  final void tapFunc;

  GymPlace({
    required this.mapObjectId,
    required this.latitude,
    required this.longitude,
    required this.tapFunc
  });

  PlacemarkMapObject toConfiguredObject() {
    PlacemarkMapObject obj = PlacemarkMapObject(
      mapId: MapObjectId(mapObjectId),
      point: Point(latitude: latitude, longitude: longitude),
      onTap: (PlacemarkMapObject self, Point point) => tapFunc,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage(
            'assets/images/placemark.png',
          ),
          scale: 1,
        ),
      ),
      opacity: 1
    );

    return obj;
  }
}