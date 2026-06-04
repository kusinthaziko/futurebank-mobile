import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../design_system/components/fb_button.dart';
import '../design_system/tokens/colors.dart';
import '../design_system/tokens/dimensions.dart';
import '../design_system/tokens/typography.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.error, this.onRetry});

  String get _message {
    if (error is OperationException) {
      final e = error as OperationException;
      if (e.graphqlErrors.isNotEmpty) return e.graphqlErrors.first.message;
      if (e.linkException != null) return 'No internet connection. Check your network.';
    }
    return 'Something went wrong. Please try again.';
  }

  static String messageFor(Object error) => ErrorView(error: error)._message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(sp32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.error_outline, color: error500, size: 48),
        const SizedBox(height: sp16),
        Text(_message,
            style: AppTextStyles.bodyMedium.copyWith(color: gray700),
            textAlign: TextAlign.center),
        if (onRetry != null) ...[
          const SizedBox(height: sp16),
          FBButton(
            label: 'Try Again',
            variant: FBButtonVariant.secondary,
            onPressed: onRetry,
          ),
        ],
      ]),
    ),
  );
}

void showErrorToast(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(ErrorView.messageFor(error)),
    backgroundColor: error500,
    duration: const Duration(seconds: 3),
  ));
}
