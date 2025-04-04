import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'info_body/settings_menu.dart';
import 'profile_body.dart';
import 'package:gymbro/features/auth/domain/auth_service.dart';

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

