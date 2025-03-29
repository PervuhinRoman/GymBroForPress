import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/theme/text_styles.dart';
import 'package:gymbro/core/widgets/background_wrapper.dart';
import 'package:gymbro/core/widgets/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BackgroundWrapper(
        topBranchPadding: const EdgeInsets.only(
          top: 50,
          left: 10,
        ),
        bottomBranchPadding: const EdgeInsets.only(
          bottom: 10,
          right: -20,
        ),
        topBranchWidth: MediaQuery.of(context).size.width * 0.6,
        bottomBranchWidth: MediaQuery.of(context).size.width * 0.6,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    l10n.resetPassword,
                    style: AppTextStyles.robotoSemiBold.copyWith(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.enterEmail,
                  style: AppTextStyles.robotoRegular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  labelText: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    // Handle email change
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle password reset
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.accessCode,
                      style: AppTextStyles.robotoMedium.copyWith(
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
