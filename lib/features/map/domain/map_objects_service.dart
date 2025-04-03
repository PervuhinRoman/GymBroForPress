import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../presentation/gym_place.dart';
import 'gym_place_provider.dart';

// Convert to a provider
final mapServiceProvider = Provider((ref) => MapObjectsService(ref));

class MapObjectsService {
  final Ref _ref;

  MapObjectsService(this._ref);

  Future<List<GymPlace>> getMapObjectsList(TapCallback<PlacemarkMapObject> tapFunc) async {
    // TODO: получение избранных плейсов из Firestore
    final List<GymPlace> gyms = [
      GymPlace(mapObjectId: 'Gym1', isLiked: true,
          latitude: 43.408760, longitude: 39.952869,
          tapFunc: tapFunc
      ),
      GymPlace(mapObjectId: 'Gym2', isLiked: true,
          latitude: 43.408846, longitude: 39.956273,
          tapFunc: tapFunc
      ),
      GymPlace(mapObjectId: 'Gym3', isLiked: true,
          latitude: 43.407339, longitude: 39.958438,
          tapFunc: tapFunc
      ),
      GymPlace(mapObjectId: 'Gym4', isLiked: true,
          latitude: 43.401772, longitude: 39.954755,
          tapFunc: tapFunc
      ),
      GymPlace(mapObjectId: 'Gym5', isLiked: false,
          latitude: 43.402466, longitude: 39.951818,
          tapFunc: tapFunc
      ),
      GymPlace(mapObjectId: 'Gym6', isLiked: false,
          latitude: 43.401353, longitude: 39.951036,
          tapFunc: tapFunc
      ),
      GymPlace(mapObjectId: 'Gym7', isLiked: false,
          latitude: 43.404536, longitude: 39.949868,
          tapFunc: tapFunc
      ),
      GymPlace(mapObjectId: 'Gym8', isLiked: false,
          latitude: 43.406907, longitude: 39.949572,
          tapFunc: tapFunc
      ),
    ];
    
    // Store the gyms in the provider
    _ref.read(gymPlaceStateProvider.notifier).setPlaces(gyms);
    
    return gyms;
  }
}