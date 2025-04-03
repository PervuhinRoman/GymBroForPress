import 'package:flutter/material.dart';
import 'package:gymbro/features/profile/presentation/profile_header.dart';
import 'info_body/gallery.dart';
import 'info_body/entries.dart';
import 'info_body/info_wrapper.dart';
import 'package:gymbro/core/widgets/double_text.dart';
import 'package:gymbro/features/profile/presentation/profile_configs.dart';

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
            icon: Icon(Icons.edit),
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
