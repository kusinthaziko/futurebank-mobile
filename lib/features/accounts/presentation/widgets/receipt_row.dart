import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

/// A label-value row used in the receipt screen with optional copy, bold, status formatting.
class ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final bool copyable;
  final bool bold;
  final bool status;

  const ReceiptRow({
    super.key,
    required this.label,
    required this.value,
    this.copyable = false,
    this.bold = false,
    this.status = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: gray500),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onLongPress: copyable
                ? () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  }
                : null,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: bold ? FontWeight.w600 : null,
                      color: status
                          ? (value == 'completed' ? success500 : warning500)
                          : null,
                    ),
                  ),
                ),
                if (copyable) const Icon(Icons.copy, color: gray500, size: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
