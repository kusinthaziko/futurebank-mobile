import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

/// Displays a blockchain contract hash with copy and info tooltip.
class BlockchainContractCard extends StatelessWidget {
  final String contractHash;

  const BlockchainContractCard({super.key, required this.contractHash});

  @override
  Widget build(BuildContext context) {
    return FBCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Blockchain Contract',
                style: AppTextStyles.labelLarge,
              ),
              const SizedBox(width: sp4),
              GestureDetector(
                onTap: () => _showTooltip(context),
                child: const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: primary300,
                ),
              ),
            ],
          ),
          const SizedBox(height: sp4),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${contractHash.substring(0, 24)}...',
                  style: AppTextStyles.caption.copyWith(
                    color: primary500,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 16, color: primary500),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: contractHash));
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Hash copied')));
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTooltip(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: radius12),
        title: const Text(
          'What is a Blockchain Contract?',
          style: AppTextStyles.titleMedium,
        ),
        content: const Text(
          'A blockchain contract hash is the unique address of your loan '
          'agreement on the blockchain. It proves your loan terms are '
          'immutably recorded and cannot be changed. You can verify it '
          'independently on any blockchain explorer.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
