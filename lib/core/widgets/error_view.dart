import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../design_system/components/fb_button.dart';
import '../design_system/tokens/colors.dart';
import '../design_system/tokens/dimensions.dart';
import '../design_system/tokens/icons.dart';
import '../design_system/tokens/typography.dart';
import '../utils/error_utils.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  final VoidCallback? onSignIn;

  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.onSignIn,
  });

  String get _message => friendlyErrorMessage(error);

  IconData get _icon {
    final code = errorCode(error);
    return switch (code) {
      'kyc_required' => FbIcons.verified,
      'insufficient_balance' => FbIcons.wallet,
      'active_loan_exists' => FbIcons.creditCard,
      'not_found' => FbIcons.search,
      'unauthenticated' || 'forbidden' => FbIcons.shield,
      _ when error is NetworkException => FbIcons.wifiOff,
      _ => FbIcons.warning,
    };
  }

  static String messageFor(Object error) => friendlyErrorMessage(error);

  @override
  Widget build(BuildContext context) {
    final isAuth = isAuthError(error);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(sp32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(_icon, color: error500, size: 48),
          const SizedBox(height: sp16),
          Text(_message,
              style: AppTextStyles.bodyMedium.copyWith(color: gray700),
              textAlign: TextAlign.center),
          const SizedBox(height: sp16),
          if (isAuth && onSignIn != null)
            FBButton(
              label: 'Sign In',
              variant: FBButtonVariant.primary,
              onPressed: onSignIn,
            )
          else if (onRetry != null)
            FBButton(
              label: 'Try Again',
              variant: FBButtonVariant.secondary,
              onPressed: onRetry,
            ),
        ]),
      ),
    );
  }
}

void showErrorToast(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(friendlyErrorMessage(error)),
    backgroundColor: error500,
    duration: const Duration(seconds: 3),
  ));
}
