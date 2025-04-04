import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/utils/routes.dart';
import 'package:gymbro/core/widgets/background_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymbro/core/widgets/custom_app_bar.dart';
import 'package:gymbro/core/widgets/custom_text_field.dart';
import 'package:gymbro/features/auth/domain/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isAgreedToTerms = false;
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: CustomAppBar(),
        body: BackgroundWrapper(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      l10n.createAccount,
                      style: Theme.of(context).textTheme.headlineLarge,
                      // style:
                      //     AppTextStyles.robotoSemiBold.copyWith(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Google Sign In Button
                  OutlinedButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      try {
                        final user = await _authService.signInWithGoogle();
                        if (user != null && mounted) {
                          Navigator.pushNamed(context, RouteNames.home);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      side: const BorderSide(color: AppColors.greenPrimary),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/google_icon.png',
                            height: 24),
                        const SizedBox(width: 8),
                        Text(
                          l10n.googleSignIn,
                          style: Theme.of(context).textTheme.bodyMedium,
                          // style: AppTextStyles.robotoMedium.copyWith(
                          //   color: AppColors.primaryText,
                          // ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      l10n.or,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    labelText: l10n.enterLogin,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 34),

                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    labelText: l10n.enterPassword,
                    isPassword: true,
                    obscureText: !_isPasswordVisible,
                    onVisibilityToggle: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 34),

                  // Confirm Password Field
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: l10n.repeatPassword,
                    isPassword: true,
                    obscureText: !_isConfirmPasswordVisible,
                    onVisibilityToggle: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Terms Checkbox
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.personalData,
                          style: Theme.of(context).textTheme.bodySmall,
                          // style: AppTextStyles.robotoRegular.copyWith(
                          //   color: AppColors.textSecondary,
                          //   fontSize: 13,
                          // ),
                        ),
                      ),
                      Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          value: _isAgreedToTerms,
                          onChanged: (value) {
                            setState(() {
                              _isAgreedToTerms = value ?? false;
                            });
                          },
                          activeColor: AppColors.violetPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Spacer(),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: !_isAgreedToTerms || _isLoading
                          ? null
                          : () async {
                              setState(() => _isLoading = true);
                              try {
                                final user = await _authService
                                    .registerWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                                if (user != null && mounted) {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.questionnare,
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.violetSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.signUp,
                        style: Theme.of(context).textTheme.bodyMedium,
                        // style: AppTextStyles.robotoMedium.copyWith(
                        //   color: AppColors.primaryText,
                        // ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Page Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.violetPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
