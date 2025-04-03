import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gymbro/features/profile/presentation/info_body/info_body_adapter.dart';
import 'info_wrapper.dart';

ShaderCallback galleryShaderCallback() {
  final Color op = Colors.white.withAlpha(255);
  final Color tr = Colors.white.withAlpha(0);
  final double trStop = 0.01;
  final double opStop = 0.04;

  return (bounds) => LinearGradient(
                stops:  [trStop, opStop, 1-opStop, 1-trStop],
                colors: [tr,     op,     op,       tr      ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds);
}

class Gallery extends StatelessWidget implements InfoBody {
  const Gallery({
    super.key,
    required this.photosUrls,
  });

  final List<String>? photosUrls;
  static const double _vertPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    final contextTheme = Theme.of(context);

    // TODO: catch exceptional behavior
    
    if (photosUrls == null) {
      return Placeholder();
    }
    // TODO END;

    return ColoredBox(
      color: contextTheme.colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.only(top: _vertPadding, bottom: _vertPadding),
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: galleryShaderCallback(),
              child: GalleryCarousel(photosUrls: photosUrls),
            ),
          ]
        ),
      ),
    );
  }
}

class GalleryCarousel extends StatelessWidget {
  const GalleryCarousel({
    super.key,
    required this.photosUrls,
  });

  final List<String>? photosUrls;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        viewportFraction: 0.4,
      ),
      items: photosUrls!.map((path) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: 9/16,
            child: Image.asset(
              path,
              fit: BoxFit.cover, 
              width: double.infinity,
            ),
          ),
        );
      }).toList(),
    );
  }
}
