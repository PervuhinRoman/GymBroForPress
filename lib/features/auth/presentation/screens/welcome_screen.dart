import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/theme/text_styles.dart';
import 'package:gymbro/core/widgets/background_wrapper.dart';
import 'package:gymbro/features/auth/presentation/screens/login_screen.dart';
import 'package:gymbro/features/auth/presentation/screens/registration_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Лого "VITA"
                        SizedBox(
                          height: 80,
                          width: 101,
                          child: Image(
                            image: AssetImage('assets/images/gymbro_logo.png'),
                          ),
                        ),
                        SizedBox(height: 30),
                        // Иллюстрация
                        SizedBox(
                          height: 220,
                          width: 330,
                          child: Image(
                            image: AssetImage(
                                'assets/images/welcome_illustration.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24), // Отступ после иллюстрации
                  Text(
                    l10n.welcomeDescription,
                    style: AppTextStyles.robotoSemiBold.copyWith(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48), // Отступ перед кнопками
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Кнопка регистрации
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenSecondary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              l10n.signUp,
                              style: AppTextStyles.robotoMedium.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Ссылка для входа
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.accountExistence,
                              style: AppTextStyles.robotoRegular.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                l10n.signIn,
                                style: AppTextStyles.robotoMedium.copyWith(
                                  color: AppColors.violetPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
