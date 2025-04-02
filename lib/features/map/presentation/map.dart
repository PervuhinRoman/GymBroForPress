import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/features/map/domain/select_button_provider.dart';
import 'package:gymbro/features/map/presentation/gym_place.dart';
import 'package:gymbro/features/map/presentation/ontap_dialog.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../domain/map_objects_service.dart';

class Map extends ConsumerStatefulWidget {
  final Point startPoint;
  Map(
      {Key? key,
      this.startPoint = const Point(latitude: 43.405637, longitude: 39.954619)})
      : super(key: key);

  @override
  ConsumerState<Map> createState() => _MapState();
}

class _MapState extends ConsumerState<Map> {
  late YandexMapController controller;
  List<GymPlace>? mapObjects;

  @override
  void initState() {
    super.initState();
    _loadMapObjects();
  }

  void _loadMapObjects() async {
    final objects = await mapService.getMapObjectsList(_handlePlacemarkTap);
    setState(() {
      mapObjects = objects;
    });
  }

  void _handlePlacemarkTap(PlacemarkMapObject placeMarkObject, Point point) {
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 16),
      ),
    );

    showModalBottomSheet(
        context: context,
        builder: (_) {
          return OntapDialog(gymName: placeMarkObject.mapId);
        });
  }

  @override
  Widget build(BuildContext context) {
    final isAllSelected = ref.watch(selectButtonStateProvider);

    final List<MapObject> filteredMapObjects = [];
    if (mapObjects != null) {
      if (isAllSelected) {
        mapObjects!.forEach((el) {
          filteredMapObjects.add(el.toConfiguredObject());
        });
      } else {
        List<GymPlace> liked = mapObjects!.where((obj) => obj.isLiked).toList();
        liked.forEach((el) {
          filteredMapObjects.add(el.toConfiguredObject());
        });
      }
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: YandexMap(
          nightModeEnabled:
              Theme.of(context).brightness == Brightness.dark ? true : false,
          logoAlignment: MapAlignment(
            horizontal: HorizontalAlignment.center,
            vertical: VerticalAlignment.top,
          ),
          mapObjects: filteredMapObjects,
          onMapCreated: (YandexMapController yandexMapController) async {
            controller = yandexMapController;
            controller.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: widget.startPoint,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
