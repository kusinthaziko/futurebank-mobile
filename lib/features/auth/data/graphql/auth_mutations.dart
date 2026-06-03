import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/graphql/client.dart';

class AuthMutations {
  static const _loginMutation = r'''
    mutation Login($email: String!, $password: String!) {
      login(input: { email: $email, password: $password }) {
        accessToken
        refreshToken
        user { id full_name email kyc_level role }
      }
    }
  ''';

  static const _registerMutation = r'''
    mutation Register($input: RegisterInput!) {
      register(input: $input) {
        accessToken
        refreshToken
        user { id full_name email kyc_level role }
      }
    }
  ''';

  static Future<Map<String, dynamic>?> login(
      WidgetRef ref, {required String email, required String password}) async {
    final client = ref.read(graphQLClientProvider(null));
    final result = await client.mutate(MutationOptions(
      document: gql(_loginMutation),
      variables: {'email': email, 'password': password},
    ));
    if (result.hasException) throw result.exception!;
    return result.data?['login'];
  }

  static Future<Map<String, dynamic>?> register(
      WidgetRef ref, Map<String, dynamic> input) async {
    final client = ref.read(graphQLClientProvider(null));
    final result = await client.mutate(MutationOptions(
      document: gql(_registerMutation),
      variables: {'input': input},
    ));
    if (result.hasException) throw result.exception!;
    return result.data?['register'];
  }
}
