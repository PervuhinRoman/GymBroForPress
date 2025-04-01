# Yandex MAPKIT

[Pub.dev](https://pub.dev/packages/yandex_mapkit)
[GitHub](https://github.com/Unact/yandex_mapkit)

---

## Кейсы
### Просто вывести карту, чёрт возьми

Виджет карты (Map)

```dart
class Map extends StatelessWidget {
  Map(Key? key) : super(key: key);
  
  late YandexMapController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        YandexMap(
          mapObjects: const [],
          onMapCreated: (YandexMapController yandexMapController) async {
            controller = yandexMapController;
            controller.moveCamera(
                CameraUpdate.newCameraPosition(
                    const CameraPosition(
                        target: Point(latitude: 55.7522, longitude: 37.6156)
                    )
                )
            );
          },
        )
      ],
    );
  }
}
```

Вызов виджета Map:
```dart
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Map(key))
      ],
    );
  }
}

```

### Добавление точки на карте (самая простая точка-картинка)
_какие-либо объекты карты есть на ней сразу при запуске_

0. Достаточно, что логично ((●'◡'●)), подключить:
```dart
import 'package:yandex_mapkit/yandex_mapkit.dart';
```

В `State`-классе:
1. создать `List<MapObject>`
2. создать объект карты:
   ```dart
   PlacemarkMapObject obj = PlacemarkMapObject(
      mapId: const MapObjectId('obj'),
      point: const Point(latitude: 55.7522, longitude: 37.6156),
      onTap: (PlacemarkMapObject self, Point point) {

      },
      icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('assets/images/placemark-dumbells.png'),
              scale: 5
          )
     )
   );
   ```
3. в `@override initState()` добавить объект-карты в массив:
    ```dart
   @override
    void initState() {
      super.initState();
      mapObjects.add(obj);
    }
    ```
4. Передать а качестве аргумента `mapObjects:` массив из п.1
    ```dart
   // ...
   YandexMap(
          mapObjects: mapObjects,
          onMapCreated: ...
   // ...
    ```

### Закгругление границ карты
== Обернуть в: `Stack` --> `Positioned.fill` --> `Container` (для отступов) --> `ClipRRect` == 💖 

Пример:
```dart
@override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32.0),
              child: YandexMap(
                logoAlignment: MapAlignment(horizontal: HorizontalAlignment.center, vertical: VerticalAlignment.top),
                mapObjects: mapObjects,
                onMapCreated: (YandexMapController yandexMapController) async {
                  controller = yandexMapController;
                  controller.moveCamera(
                    CameraUpdate.newCameraPosition(
                      const CameraPosition(
                        target: Point(latitude: 55.7522, longitude: 37.6156),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
```