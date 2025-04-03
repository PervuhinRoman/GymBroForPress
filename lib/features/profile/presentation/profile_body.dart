import 'package:flutter/material.dart';
import 'package:gymbro/core/_dev/debug_tools.dart';
import 'package:gymbro/features/profile/presentation/profile_header.dart';
import 'info_body/gallery_block.dart';
import 'info_body/entries_block.dart';
import 'info_body/info_wrapper.dart';
import 'package:gymbro/core/widgets/double_text.dart';

class ProfileBodyConfig {
  static const double pbgHeight = 60.0;

  static const double radius = 110;
  static const double leftPadding = 45;
  static const double topRelPadding = 0.4;

  static const double ibSepHeight = 10;
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ProfileBackGround(),
            ProfileHeader(),
            DebugBox(
              height: ProfileBodyConfig.pbgHeight + (ProfileBodyConfig.radius * (1-ProfileBodyConfig.topRelPadding)),
              width: ProfileBodyConfig.leftPadding,
            ),
          ],
        ),

        // Basically, just need a "ручка"
        InfoWrapper(
          header: 'General Info',
          optionalButton: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              
            }
          ), 
          infoBody: Entries(
            infoTuples: [
              ['+7 (800) 555-35-35', 'Phone Number'],
              ['The quick red fox jumps over the lazy brown dog and the lively white cat', 'Bio'],
              ['@user', 'User Tag'],
            ],
          )
        ),
        InfoWrapper(
          header: 'Progress in Pictures',
          infoBody: Gallery(
            photosUrls: [
              'assets/images/dog.jpeg',
              'assets/images/cat.jpeg',
              'assets/images/myles.jpeg',
            ],
          ),
        ),
      ]
    );
  }
}
