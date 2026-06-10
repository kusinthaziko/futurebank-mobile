import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class AISearchInput extends StatefulWidget {
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final bool isSearching;

  const AISearchInput({
    super.key,
    required this.onSubmitted,
    required this.onClear,
    this.isSearching = false,
  });

  @override
  State<AISearchInput> createState() => _AISearchInputState();
}

class _AISearchInputState extends State<AISearchInput> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp8),
      child: TextField(
        controller: _controller,
        onChanged: (v) => setState(() => _hasText = v.isNotEmpty),
        onSubmitted: widget.onSubmitted,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search transactions...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: gray500),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: sp16,
            vertical: sp12,
          ),
          border: OutlineInputBorder(
            borderRadius: radius12,
            borderSide: const BorderSide(color: gray300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: radius12,
            borderSide: const BorderSide(color: gray300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: radius12,
            borderSide: const BorderSide(color: primary500, width: 1.5),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: widget.isSearching
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primary500,
                    ),
                  )
                : Icon(
                    _hasText ? Icons.auto_awesome : Icons.search,
                    color: _hasText ? gold500 : gray500,
                    size: 20,
                  ),
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18, color: gray500),
                  onPressed: () {
                    _controller.clear();
                    setState(() => _hasText = false);
                    widget.onClear();
                  },
                )
              : null,
        ),
      ),
    );
  }
}
