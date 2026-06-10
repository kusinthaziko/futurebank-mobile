import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/dimensions.dart';
import '../tokens/typography.dart';

class FBCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool gradient;
  final bool outlined;
  final VoidCallback? onTap;

  const FBCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient = false,
    this.outlined = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(sp16),
        decoration: BoxDecoration(
          borderRadius: radius16,
          gradient: gradient
              ? const LinearGradient(
                  colors: [primary700, primary500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: gradient ? null : cardColor,
          border: outlined ? Border.all(color: gray300) : null,
          boxShadow: outlined ? null : shadowRaised,
        ),
        child: child,
      ),
    );
  }
}

class FBInput extends StatelessWidget {
  final String label;
  final String? hint;
  final String? error;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;

  const FBInput({
    super.key,
    required this.label,
    this.hint,
    this.error,
    this.obscure = false,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMedium.copyWith(color: gray700)),
        const SizedBox(height: sp4),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyLarge.copyWith(color: gray500),
            suffixIcon: suffix,
            errorText: error,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: sp16,
              vertical: sp12,
            ),
            border: OutlineInputBorder(
              borderRadius: radius12,
              borderSide: const BorderSide(color: gray300, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius12,
              borderSide: const BorderSide(color: gray300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius12,
              borderSide: const BorderSide(color: primary500, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: radius12,
              borderSide: const BorderSide(color: error500, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
