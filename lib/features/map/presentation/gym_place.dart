import 'package:yandex_mapkit/yandex_mapkit.dart';

class GymPlace {
  final double latitude;
  final double longitude;
  final String mapObjectId;
  final bool isLiked;
  final TapCallback<PlacemarkMapObject> tapFunc;

  GymPlace({
    required this.mapObjectId,
    required this.isLiked,
    required this.latitude,
    required this.longitude,
    required this.tapFunc
  });

  PlacemarkMapObject toConfiguredObject() {
    PlacemarkMapObject obj = PlacemarkMapObject(
      mapId: MapObjectId(mapObjectId),
      point: Point(latitude: latitude, longitude: longitude),
      //onTap: (PlacemarkMapObject self, Point point) => tapFunc,
        onTap: tapFunc,
        // onTap: (PlacemarkMapObject obj, Point point) => print("WTF"),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage(
            'assets/images/placemark.png',
          ),
          scale: 1.5,
        ),
      ),
      opacity: 1
    );

    return obj;
  }
}