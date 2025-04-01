import 'package:flutter/material.dart';
import 'package:gymbro/core/_dev/debug_tools.dart';
import 'package:gymbro/core/widgets/double_text.dart';
import 'package:gymbro/features/profile/presentation/profile_body.dart';

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

    final double nameLeftPadding = ((0.7 - topRelPadding) * radius / 2).abs();

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
              padding: EdgeInsets.only(left: nameLeftPadding, bottom: radius*0.08),
              child: Column(
                children: [
                  DoubleTextDisplay(
                    topText: 'Name LastName', 
                    topStyle: contextTheme.textTheme.titleLarge,
                    bottomText: 'online',
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

