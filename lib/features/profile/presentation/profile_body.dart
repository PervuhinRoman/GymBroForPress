import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gymbro/features/profile/domain/profile_body_service.dart';
import 'package:gymbro/features/profile/presentation/profile_header.dart';
import 'info_body/gallery.dart';
import 'info_body/entries.dart';
import 'info_body/info_wrapper.dart';
import 'package:gymbro/core/widgets/double_text.dart';
import 'package:gymbro/features/profile/presentation/profile_configs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  List<String> photoPaths = [];

  @override
  void initState() {
    super.initState();
    _loadSavedImages();
  }

  Future<void> _loadSavedImages() async {
    List<File> savedImages = await getSavedImages();
    setState(() {
      photoPaths = savedImages.map((file) => file.path).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ProfileBackGround(),
            ProfileHeader(),
            SizedBox(
              height: ProfileBodyConfig.pbgHeight + (ProfileBodyConfig.radius * (1-ProfileBodyConfig.topRelPadding)),
              width: ProfileBodyConfig.leftPadding,
            ),
          ],
        ),

        // Basically, just need a "ручка"
        InfoWrapper(
          header: 'General Info',
          optionalButton: IconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onPrimary,),
            onPressed: () {
              
            }
          ), 
          infoBody: Entries(
            infoClauses: [
              InfoClause('Phone Number',  '+7 (800) 555-35-35'),
              InfoClause('Bio',           'The quick red fox jumps over the lazy brown dog and the lively white cat'),
              InfoClause('User Tag',      '@user'),
            ],
          )
        ),
        InfoWrapper(
          header: 'Progress in Pictures',
          optionalButton: IconButton(
            icon: Icon(Icons.image_search, color: Theme.of(context).colorScheme.onPrimary,),
            onPressed: () async {
              await pickAndSaveImage(ImageSource.gallery);
              _loadSavedImages();
            }
          ), 
          infoBody: Gallery(
            photoPaths: photoPaths,
          ),
        ),
      ]
    );
  }
}
