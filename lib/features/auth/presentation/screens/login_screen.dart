import 'package:flutter/material.dart';
// import 'package:gymbro/core/services/auth_service.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/theme/text_styles.dart';
import 'package:gymbro/core/utils/routes.dart';
import 'package:gymbro/core/widgets/background_wrapper.dart';
import 'package:gymbro/core/widgets/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymbro/features/auth/services/auth_service.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                  l10n.logIn,
                  style: AppTextStyles.robotoSemiBold.copyWith(fontSize: 24),
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
                      Navigator.pushNamed(
                        context,
                        RouteNames.home
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
                    Image.asset('assets/images/google_icon.png', height: 24),
                    const SizedBox(width: 8),
                    Text(
                      l10n.googleSignIn,
                      style: AppTextStyles.robotoMedium.copyWith(
                        color: AppColors.primaryText,
                      ),
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

              // Email/Phone Field
              CustomTextField(
                controller: _emailController,
                labelText: l10n.phoneNumberOrEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 34),

              // Password Field
              CustomTextField(
                controller: _passwordController,
                labelText: l10n.password,
                isPassword: true,
                obscureText: !_isPasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 70),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
            
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);
                          try {
                            final user =
                                await _authService.signInWithEmailAndPassword(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (mounted) {
                              if (user != null) {
                                Navigator.pushNamed(context, RouteNames.home);
                              }
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.violetSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          l10n.next,
                          style: AppTextStyles.robotoMedium.copyWith(
                            color: AppColors.primaryText,
                          ),
                        ),
                ),
              ),
              // Forgot Password Link
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.forgotPassword);
                  },
                  child: Text(
                    l10n.forgotPassword,
                    style: AppTextStyles.robotoRegular.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
