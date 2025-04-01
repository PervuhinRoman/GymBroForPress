import 'package:flutter/material.dart';
import 'package:gymbro/core/_dev/debug_tools.dart';
import 'gallery_block.dart';
import 'entries_block.dart';
import 'profile_info.dart';
import 'package:gymbro/core/widgets/double_text.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
  });

  static const double pbgHeight = 100.0;

  static const double radius = 100;
  static const double leftPadding = 45;
  static const double topRelPadding = 0.4;

  static const double ibSepHeight = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      child: ListView(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ProfileBackGround(),
              ProfileHeader(),
              DebugBox(
                height: pbgHeight + (radius * (1-topRelPadding)),
                width: leftPadding,
              ),
            ],
          ),
          // Basically, just need a "ручка"
          InfoSection(
            header: 'General Info',
            optionalButton: null,
            infoBody: Entries(
              infoTuples: [
                ['+7 (800) 555-35-35', 'Phone Number'],
                ['The quick red fox jumps over the lazy brown dog and the lively white cat', 'Bio'],
                // ["@user", "User Tag"],
              ],
            )
          ),
          InfoSection(
            header: 'Progress in Pictures',
            infoBody: Gallery(
              photosUrls: [
                'assets/dog.png',
                'assets/cat.png',
                'assets/myles.jpg',
              ],
            ),
          ),
        ]
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final topRelPadding = ProfileBody.topRelPadding;
    final radius = ProfileBody.radius;
    final leftPadding = ProfileBody.leftPadding;
    
    final pbgHeight = ProfileBody.pbgHeight;

    final double nameLeftPadding = ((0.8 - topRelPadding) * radius / 2).abs();

    final ThemeData contextTheme = Theme.of(context); 

    return Positioned(
      left: leftPadding,
      top: pbgHeight - radius * topRelPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ProfileAvatar(),
          DebugGizmo(
            child: Padding(
              padding: EdgeInsets.only(left: nameLeftPadding),
              child: Column(
                children: [
                  DoubleTextDisplay(
                    topText: 'Name LastName', 
                    topStyle: contextTheme.textTheme.titleLarge,
                    bottomText: 'online',
                    bottomColor: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final radius = ProfileBody.radius;
    return ClipOval(
        child: Image(
          width: radius,
          height: radius,
          image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
        ),
    );
  }
}

class ProfileBackGround extends StatelessWidget {
  const ProfileBackGround({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double pbgHeight = ProfileBody.pbgHeight;
    return Row(
      children: [
        Expanded(
          child: ColoredBox(
            color: Theme.of(context).colorScheme.primary,
            child: SizedBox(height: pbgHeight,),
          ),
        ),
      ],
    );
  }
}
