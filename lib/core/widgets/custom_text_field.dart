import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onVisibilityToggle;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.isPassword = false,
    this.obscureText = false,
    this.onVisibilityToggle,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _hasInput = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasInput = _controller.text.isNotEmpty;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller ?? _controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: _hasInput ? AppColors.greenPrimary : AppColors.textSecondary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.violetPrimary),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Image.asset(
                  widget.obscureText
                      ? 'assets/images/enabled_text.png'
                      : 'assets/images/disabled_text.png',
                  width: 24,
                  height: 24,
                  color: AppColors.textSecondary,
                ),
                onPressed: widget.onVisibilityToggle,
              )
            : null,
      ),
    );
  }
}
