import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/features/tinder/presentation/match/match_title.dart';
import '../../domain/user.dart';
import 'background_icons.dart';

class MatchPopup extends StatelessWidget {
  final User matchedUser;

  const MatchPopup({super.key, required this.matchedUser});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.8;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
          minHeight: 300,
        ),
        decoration: _buildDialogDecoration(),
        child: Stack(
          children: [
            const BackgroundIcons(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MatchTitle(l10n: AppLocalizations.of(context)!),
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
                    child: MatchContent(matchedUser: matchedUser),
                  ),
                ),
              ],
            ),
            _ActionButton(l10n: AppLocalizations.of(context)!),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDialogDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.violetSecondary,
          AppColors.violetPrimary,
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final AppLocalizations l10n;

  const _ActionButton({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      left: 0,
      right: 0,
      child: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.violetPrimary,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.check_circle),
          label: Text(
            l10n.great,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
