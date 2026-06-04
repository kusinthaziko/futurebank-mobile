import 'package:graphql_flutter/graphql_flutter.dart';

const _errorCodeMap = <String, _ErrorInfo>{
  'unauthenticated': _ErrorInfo(
    'Your session has expired. Please sign in again.',
    'lock',
  ),
  'forbidden': _ErrorInfo(
    'You don\'t have permission to perform this action.',
    'block',
  ),
  'kyc_required': _ErrorInfo(
    'Please complete your KYC verification first.',
    'verified_user',
  ),
  'insufficient_balance': _ErrorInfo(
    'Insufficient balance for this transaction.',
    'account_balance',
  ),
  'active_loan_exists': _ErrorInfo(
    'You have an active loan. Please settle it first.',
    'credit_score',
  ),
  'not_found': _ErrorInfo(
    'The requested resource was not found.',
    'search_off',
  ),
  'invalid': _ErrorInfo(
    'Invalid input. Please check your details and try again.',
    'error',
  ),
  'internal_error': _ErrorInfo(
    'Something went wrong on our end. Please try again.',
    'bug_report',
  ),
};

class _ErrorInfo {
  final String message;
  final String iconName;
  const _ErrorInfo(this.message, this.iconName);
}

String friendlyErrorMessage(Object error) {
  if (error is OperationException) {
    final code = errorCode(error);
    if (code != null && _errorCodeMap.containsKey(code)) {
      return _errorCodeMap[code]!.message;
    }
    if (error.graphqlErrors.isNotEmpty) {
      return error.graphqlErrors.first.message;
    }
    if (error.linkException != null) {
      final linkErr = error.linkException!;
      if (linkErr is NetworkException) {
        return 'No internet connection. Check your network and try again.';
      }
      return 'Connection error. Please try again.';
    }
  }
  return 'Something went wrong. Please try again.';
}

String? errorCode(Object error) {
  if (error is OperationException) {
    for (final ge in error.graphqlErrors) {
      final code = ge.extensions?['code'] as String?;
      if (code != null) return code;
    }
  }
  return null;
}

bool isAuthError(Object error) {
  final code = errorCode(error);
  return code == 'unauthenticated' || code == 'forbidden';
}
