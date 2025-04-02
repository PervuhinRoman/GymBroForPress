import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../presentation/gym_place.dart';
// TODO: превратить в riverpod
final mapService = MapObjectsService();

class MapObjectsService {
  List<GymPlace> mapObjects = [];
  //Future<List<MapObject>> getMapObjectsList(TapCallback<PlacemarkMapObject> tapFunc) async {
    Future<List<GymPlace>> getMapObjectsList(TapCallback<PlacemarkMapObject> tapFunc) async {
    // TODO: получение избранных плейсов из Firestore
    final gym1 = GymPlace(mapObjectId: 'Gym1', isLiked: true,
        latitude: 43.408760, longitude: 39.952869,
        tapFunc: tapFunc
    );
    final gym2 = GymPlace(mapObjectId: 'Gym2', isLiked: true,
        latitude: 43.408846, longitude: 39.956273,
        tapFunc: tapFunc
    );
    final gym3 = GymPlace(mapObjectId: 'Gym3', isLiked: true,
        latitude: 43.407339,  longitude: 39.958438,
        tapFunc: tapFunc
    );
    final gym4 = GymPlace(mapObjectId: 'Gym4', isLiked: true,
        latitude: 43.401772,  longitude: 39.954755,
        tapFunc: tapFunc
    );
    var gym5 = GymPlace(mapObjectId: 'Gym5', isLiked: false,
        latitude: 43.402466,  longitude: 39.951818,
        tapFunc: tapFunc
    );
    var gym6 = GymPlace(mapObjectId: 'Gym6', isLiked: false,
        latitude: 43.401353,   longitude: 39.951036,
        tapFunc: tapFunc
    );
    var gym7 = GymPlace(mapObjectId: 'Gym7', isLiked: false,
        latitude: 43.404536,   longitude: 39.949868,
        tapFunc: tapFunc
    );
    var gym8 = GymPlace(mapObjectId: 'Gym8', isLiked: false,
        latitude: 43.406907,   longitude: 39.949572,
        tapFunc: tapFunc
    );
    // TODO: final или var
    mapObjects = [
      gym1, gym2, gym3, gym4, gym5, gym6, gym7, gym8
    ];
    //return mapObjects.map((e) => e.toConfiguredObject()).toList();
    return mapObjects;
  }
}