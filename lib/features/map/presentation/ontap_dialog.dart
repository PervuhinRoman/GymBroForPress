import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/features/map/domain/gym_place_provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class OntapDialog extends ConsumerStatefulWidget {
  final MapObjectId gymName;
  const OntapDialog({super.key, required this.gymName});

  @override
  ConsumerState<OntapDialog> createState() => _OntapDialogState();
}

class _OntapDialogState extends ConsumerState<OntapDialog> {
  late bool _isLiked;
  
  @override
  void initState() {
    super.initState();
    // Инициализируем начальное состояние
    _isLiked = ref.read(gymPlaceStateProvider.notifier).isLiked(widget.gymName.value);
  }
  
  @override
  Widget build(BuildContext context) {
    // Используем локальное состояние для UI
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
                  Flexible(
                    child: Text(widget.gymName.value,
                        style: Theme.of(context).textTheme.displaySmall),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  // TODO: получение данных
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
              child: GestureDetector(
                onTap: () {
                  // Переключаем состояние в провайдере
                  ref.read(gymPlaceStateProvider.notifier).toggleFavorite(widget.gymName.value);

                  // Обновляем локальное состояние
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  height: 72,
                  decoration: BoxDecoration(
                    color: _isLiked ? AppColors.constantError : AppColors.greenPrimary,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 400),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isLiked ? Icons.star : Icons.star_border,
                            size: 32,
                            color: Colors.white,
                          ),
                          SizedBox(width: 16),
                          Text(
                            _isLiked ? "Remove from Favorite" : "Add to Favorite",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
