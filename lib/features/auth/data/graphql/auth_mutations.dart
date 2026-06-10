import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/graphql/client.dart';

class AuthMutations {
  static const _loginMutation = r'''
    mutation Login($email: String!, $password: String!) {
      login(input: { email: $email, password: $password }) {
        accessToken
        refreshToken
        user { id full_name email kyc_level role institution_id }
      }
    }
  ''';

  static const _registerMutation = r'''
    mutation Register($input: RegisterInput!) {
      register(input: $input) {
        accessToken
        refreshToken
        user { id full_name email kyc_level role institution_id }
      }
    }
  ''';

  static const _forgotPasswordMutation = r'''
    mutation ForgotPassword($email: String!) {
      forgotPassword(input: { email: $email })
    }
  ''';

  static const _verifyEmailMutation = r'''
    mutation VerifyEmail($code: String!, $email: String) {
      verifyEmail(input: { code: $code, email: $email }) {
        success
      }
    }
  ''';

  static const _resendVerificationMutation = r'''
    mutation ResendVerificationCode($email: String) {
      resendVerificationCode(input: { email: $email }) {
        success
      }
    }
  ''';

  static const _submitKYCMutation = r'''
    mutation SubmitKYC($input: KYCInput!) {
      submitKYC(input: $input) {
        kyc_level
        status
      }
    }
  ''';

  static Future<Map<String, dynamic>?> login(
    WidgetRef ref, {
    required String email,
    required String password,
  }) async {
    final client = ref.read(graphQLClientProvider(null));
    final result = await client.mutate(
      MutationOptions(
        document: gql(_loginMutation),
        variables: {'email': email, 'password': password},
      ),
    );
    if (result.hasException) throw result.exception!;
    return result.data?['login'];
  }

  static Future<Map<String, dynamic>?> register(
    WidgetRef ref,
    Map<String, dynamic> input,
  ) async {
    final client = ref.read(graphQLClientProvider(null));
    final result = await client.mutate(
      MutationOptions(
        document: gql(_registerMutation),
        variables: {'input': input},
      ),
    );
    if (result.hasException) throw result.exception!;
    return result.data?['register'];
  }

  static Future<void> forgotPassword(
    WidgetRef ref, {
    required String email,
  }) async {
    final client = ref.read(graphQLClientProvider(null));
    final result = await client.mutate(
      MutationOptions(
        document: gql(_forgotPasswordMutation),
        variables: {'email': email},
      ),
    );
    if (result.hasException) throw result.exception!;
  }

  static Future<void> verifyEmail(
    WidgetRef ref, {
    required String code,
    String? email,
  }) async {
    final client = ref.read(graphQLClientProvider(null));
    final result = await client.mutate(
      MutationOptions(
        document: gql(_verifyEmailMutation),
        variables: {'code': code, 'email': email},
      ),
    );
    if (result.hasException) throw result.exception!;
  }

  static Future<void> resendVerificationCode(
    WidgetRef ref, {
    String? email,
  }) async {
    final client = ref.read(graphQLClientProvider(null));
    final result = await client.mutate(
      MutationOptions(
        document: gql(_resendVerificationMutation),
        variables: {'email': email},
      ),
    );
    if (result.hasException) throw result.exception!;
  }

  static Future<void> submitKYC(
    WidgetRef ref, {
    required String documentType,
    required String cloudinaryPublicId,
  }) async {
    final client = ref.read(graphQLClientProvider(null));
    final result = await client.mutate(
      MutationOptions(
        document: gql(_submitKYCMutation),
        variables: {
          'input': {
            'document_type': documentType,
            'cloudinary_public_id': cloudinaryPublicId,
          },
        },
      ),
    );
    if (result.hasException) throw result.exception!;
  }
}
