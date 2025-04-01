import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_button.dart';
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(debugProvider.notifier).toggleDebug(); // TODO REDO
          },
        ),
        
        actions: [
          SettingsMenu(),
        ],
        title: Text('Profile'),
      ),
      body: ProfileBody(),
    );
  }
}

