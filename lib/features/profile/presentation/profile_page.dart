import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'info_body/settings_button.dart';
import 'package:gymbro/core/_dev/debug_tools.dart';
import 'profile_body.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        
        actions: [
          SettingsMenu(),
        ],
      ),
      body: ProfileBody(),
    );
  }
}

