import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../presentation/gym_place.dart';

part 'gym_place_provider.g.dart';

@riverpod
class GymPlaceState extends _$GymPlaceState {
  @override
  List<GymPlace> build() {
    return [];
  }

  void setPlaces(List<GymPlace> places) {
    state = places;
  }

  void toggleFavorite(String mapObjectId) {
    state = state.map((place) {
      if (place.mapObjectId == mapObjectId) {
        return GymPlace(
          mapObjectId: place.mapObjectId,
          isLiked: !place.isLiked,
          latitude: place.latitude,
          longitude: place.longitude,
          tapFunc: place.tapFunc,
        );
      }
      return place;
    }).toList();
  }

  bool isLiked(String mapObjectId) {
    final place = state.firstWhere(
      (place) => place.mapObjectId == mapObjectId,
      orElse: () => GymPlace(
        mapObjectId: '',
        isLiked: false,
        latitude: 0,
        longitude: 0,
        tapFunc: (_, __) {},
      ),
    );
    return place.mapObjectId.isNotEmpty ? place.isLiked : false;
  }
} 