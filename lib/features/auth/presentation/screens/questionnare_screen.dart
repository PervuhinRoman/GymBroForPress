import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/utils/routes.dart';
import 'package:gymbro/core/widgets/background_wrapper.dart';
import 'package:gymbro/core/widgets/custom_app_bar.dart';
import 'package:gymbro/core/widgets/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(context)!;

    String? selectedAge = '20';
    String? selectedGender = l10n.womanGender;
    String? selectedGoal = l10n.keepingShape;
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
                    l10n.meet,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // Имя
                CustomTextField(
                  controller: _nameController,
                  labelText: l10n.selectName,
                  onChanged: (value) {
                    // Handle name change
                  },
                ),
                const SizedBox(height: 34),

                // Возраст
                DropdownButtonFormField<String>(
                  value: selectedAge,
                  decoration: InputDecoration(
                    labelText: l10n.selectAge,
                    labelStyle:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                          const BorderSide(color: AppColors.greenPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                          const BorderSide(color: AppColors.violetPrimary),
                    ),
                  ),
                  items: List.generate(100, (index) => (index + 1).toString())
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedAge = value;
                    });
                  },
                ),
                const SizedBox(height: 34),

                // Пол
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    labelText: l10n.selectGender,
                    labelStyle:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                          const BorderSide(color: AppColors.greenPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                          const BorderSide(color: AppColors.violetPrimary),
                    ),
                  ),
                  items: [l10n.manGender, l10n.womanGender].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
                const SizedBox(height: 34),

                // Вес
                CustomTextField(
                  controller: _weightController,
                  labelText: l10n.selectWeight,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Handle weight change
                  },
                ),
                const SizedBox(height: 34),

                // Рост
                CustomTextField(
                  controller: _heightController,
                  labelText: l10n.selectHeight,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Handle height change
                  },
                ),
                const SizedBox(height: 34),

                // Цель
                DropdownButtonFormField<String>(
                  value: selectedGoal,
                  decoration: InputDecoration(
                    labelText: l10n.selectGoal,
                    labelStyle:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                          const BorderSide(color: AppColors.greenPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                          const BorderSide(color: AppColors.violetPrimary),
                    ),
                  ),
                  items: [
                    l10n.keepingShape,
                    l10n.loosingWeight,
                    l10n.gainingWeight,
                    l10n.healthyLifestyle
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedGoal = value;
                    });
                  },
                ),

                const Spacer(),

                // Кнопка регистрации
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        RouteNames.home,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.violetSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.completeRegistration,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Индикатор страниц
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.violetPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
