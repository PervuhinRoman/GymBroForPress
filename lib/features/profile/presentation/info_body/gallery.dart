import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gymbro/features/profile/domain/photo_widget_service.dart';
import 'package:gymbro/features/profile/presentation/info_body/info_body_adapter.dart';
import 'package:gymbro/features/profile/presentation/info_body/photo_widget.dart';
import 'info_wrapper.dart';
import 'dart:io';

ShaderCallback galleryShaderCallback = () {
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
}.call();

class Gallery extends StatelessWidget implements InfoBody {
  const Gallery({
    super.key,
    required this.photoPaths,
  });

  final List<String>? photoPaths;
  static const double _vertPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    final contextTheme = Theme.of(context);

    return ColoredBox(
      color: contextTheme.colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.only(top: _vertPadding, bottom: _vertPadding),
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: galleryShaderCallback,
              child: GalleryCarousel(photoPaths: photoPaths),
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
    required this.photoPaths,
  });

  final List<String>? photoPaths;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        viewportFraction: 0.4,
      ),
      items: photoPaths!.map((path) {
        return PhotoWidget(imagePath: path);
      }).toList(),
    );
  }
}
