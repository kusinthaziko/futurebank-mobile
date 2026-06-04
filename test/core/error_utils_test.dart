import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/core/utils/error_utils.dart';

void main() {
  group('friendlyErrorMessage', () {
    test('returns default message for generic error', () {
      expect(
        friendlyErrorMessage(Exception('test')),
        'Something went wrong. Please try again.',
      );
    });

    test('returns network message for NetworkException', () {
      final err = OperationException(
        linkException: NetworkException(
          originalException: Exception('Network error'),
          uri: Uri.parse('http://localhost:4000/api/graphql'),
        ),
      );
      expect(
        friendlyErrorMessage(err),
        'No internet connection. Check your network and try again.',
      );
    });

    test('returns code-specific message for known error codes', () {
      final err = OperationException(
        graphqlErrors: [
          GraphQLError(
            message: 'Insufficient balance',
            extensions: {'code': 'insufficient_balance'},
          ),
        ],
      );
      expect(
        friendlyErrorMessage(err),
        'Insufficient balance for this transaction.',
      );
    });

    test('returns graphql message when no code match', () {
      final err = OperationException(
        graphqlErrors: [
          GraphQLError(message: 'Custom error message'),
        ],
      );
      expect(friendlyErrorMessage(err), 'Custom error message');
    });

    test('handles kyc_required code', () {
      final err = OperationException(
        graphqlErrors: [
          GraphQLError(
            message: 'KYC needed',
            extensions: {'code': 'kyc_required'},
          ),
        ],
      );
      expect(
        friendlyErrorMessage(err),
        'Please complete your KYC verification first.',
      );
    });

    test('handles internal_error code', () {
      final err = OperationException(
        graphqlErrors: [
          GraphQLError(
            message: 'Server error',
            extensions: {'code': 'internal_error'},
          ),
        ],
      );
      expect(
        friendlyErrorMessage(err),
        'Something went wrong on our end. Please try again.',
      );
    });
  });

  group('errorCode', () {
    test('extracts error code from GraphQL error extensions', () {
      final err = OperationException(
        graphqlErrors: [
          GraphQLError(
            message: 'test',
            extensions: {'code': 'unauthenticated'},
          ),
        ],
      );
      expect(errorCode(err), 'unauthenticated');
    });

    test('returns null when no code extension', () {
      final err = OperationException(
        graphqlErrors: [GraphQLError(message: 'test')],
      );
      expect(errorCode(err), isNull);
    });

    test('returns null for non-OperationException', () {
      expect(errorCode(Exception('test')), isNull);
    });
  });

  group('isAuthError', () {
    test('returns true for unauthenticated', () {
      final err = OperationException(
        graphqlErrors: [
          GraphQLError(
            message: 'test',
            extensions: {'code': 'unauthenticated'},
          ),
        ],
      );
      expect(isAuthError(err), isTrue);
    });

    test('returns true for forbidden', () {
      final err = OperationException(
        graphqlErrors: [
          GraphQLError(
            message: 'test',
            extensions: {'code': 'forbidden'},
          ),
        ],
      );
      expect(isAuthError(err), isTrue);
    });

    test('returns false for other errors', () {
      final err = OperationException(
        graphqlErrors: [
          GraphQLError(
            message: 'test',
            extensions: {'code': 'not_found'},
          ),
        ],
      );
      expect(isAuthError(err), isFalse);
    });

    test('returns false for non-OperationException', () {
      expect(isAuthError(Exception('test')), isFalse);
    });
  });
}
