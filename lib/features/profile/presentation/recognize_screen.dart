import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/theme/text_styles.dart';

class RecognizeScreen extends StatefulWidget {
  const RecognizeScreen({super.key});

  @override
  State<RecognizeScreen> createState() => _RecognizeScreenState();
}

class _RecognizeScreenState extends State<RecognizeScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File> _recentPhotos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecentPhotos();
  }

  Future<void> _loadRecentPhotos() async {
    final directory = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${directory.path}/food_photos');

    if (await photosDir.exists()) {
      final files = await photosDir.list().toList();
      setState(() {
        _recentPhotos = files
            .whereType<File>()
            .toList()
            .cast<File>()
            .reversed
            .take(10)
            .toList();
      });
    } else {
      await photosDir.create(recursive: true);
    }
  }

  Future<void> _takePhoto() async {
    setState(() => _isLoading = true);

    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final directory = await getApplicationDocumentsDirectory();
        final photosDir = Directory('${directory.path}/food_photos');

        if (!await photosDir.exists()) {
          await photosDir.create(recursive: true);
        }

        final fileName = 'food_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = File('${photosDir.path}/$fileName');
        await File(photo.path).copy(savedImage.path);

        setState(() {
          _recentPhotos.insert(0, savedImage);
          if (_recentPhotos.length > 10) {
            _recentPhotos = _recentPhotos.sublist(0, 10);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final photosDir = Directory('${directory.path}/food_photos');

        if (!await photosDir.exists()) {
          await photosDir.create(recursive: true);
        }

        final fileName = 'food_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = File('${photosDir.path}/$fileName');
        await File(image.path).copy(savedImage.path);

        setState(() {
          _recentPhotos.insert(0, savedImage);
          if (_recentPhotos.length > 10) {
            _recentPhotos = _recentPhotos.sublist(0, 10);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Инструкция
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.violetPaleX2,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Распознавание продуктов',
                  style: AppTextStyles.robotoBold.copyWith(
                    fontSize: 18,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Сфотографируйте продукт или блюдо, чтобы узнать его калорийность и пищевую ценность.',
                  style: AppTextStyles.robotoRegular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Кнопки действий
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _takePhoto,
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: Text(
                    'Камера',
                    style: AppTextStyles.robotoMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.violetPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _pickFromGallery,
                  icon: const Icon(Icons.photo_library,
                      color: AppColors.primaryText),
                  label: Text(
                    'Галерея',
                    style: AppTextStyles.robotoMedium.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Недавние фотографии
          Text(
            'НЕДАВНИЕ ФОТОГРАФИИ',
            style: AppTextStyles.robotoMedium.copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Сетка фотографий
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _recentPhotos.isEmpty
                    ? Center(
                        child: Text(
                          'Нет недавних фотографий',
                          style: AppTextStyles.robotoRegular.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemCount: _recentPhotos.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Открыть детальный просмотр фото
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => _PhotoDetailScreen(
                                    photoFile: _recentPhotos[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_recentPhotos[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// Экран детального просмотра фото
class _PhotoDetailScreen extends StatelessWidget {
  final File photoFile;

  const _PhotoDetailScreen({required this.photoFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Детали продукта',
          style: AppTextStyles.robotoMedium.copyWith(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              child: Center(
                child: Image.file(
                  photoFile,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black.withOpacity(0.7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Название продукта',
                  style: AppTextStyles.robotoBold.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _nutritionItem('Калории', '250 ккал', Colors.orange),
                    _nutritionItem('Белки', '10 г', Colors.red),
                    _nutritionItem('Жиры', '8 г', Colors.yellow),
                    _nutritionItem('Углеводы', '30 г', Colors.green),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Добавить в дневник питания
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.violetPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Добавить в дневник',
                      style: AppTextStyles.robotoMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nutritionItem(String title, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value.split(' ')[0],
              style: AppTextStyles.robotoBold.copyWith(
                color: color,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: AppTextStyles.robotoRegular.copyWith(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
