import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/theme/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showProfileAvatar;
  final List<Widget>? actions;
  final Color backgroundColor;
  final double elevation;
  final VoidCallback? onProfileTap;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.showProfileAvatar = false,
    this.actions,
    this.backgroundColor = Colors.transparent,
    this.elevation = 0,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: showProfileAvatar
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: onProfileTap,
                child: const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/profile_avatar.png'),
                ),
              ),
            )
          : showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: AppColors.primaryText),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
      title: title != null
          ? Text(
              title!,
              style: AppTextStyles.robotoMedium.copyWith(
                fontSize: 18,
                color: AppColors.primaryText,
              ),
            )
          : null,
      actions: [
        ...(actions ?? []),
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/images/gymbro_logo_dark.png'
                : 'assets/images/gymbro_logo.png',
            height: 50,
          ),
        ),
      ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
