import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_card_input.dart';
import '../../../../core/design_system/components/fb_misc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: gql(r'''
        query {
          myAccounts { id account_number account_type balance currency status }
        }
      ''')),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
        final accounts = (result.data?['myAccounts'] as List? ?? [])
            .cast<Map<String, dynamic>>();
        return Scaffold(
          appBar: AppBar(title: const Text('Accounts')),
          body: ListView.builder(
            padding: const EdgeInsets.all(sp16),
            itemCount: accounts.length,
            itemBuilder: (_, i) {
              final a = accounts[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: sp12),
                child: FBCard(
                  gradient: a['account_type'] == 'savings',
                  onTap: () => context.push('/transactions/${a['id']}'),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${a['account_type']}'.toUpperCase(),
                        style: AppTextStyles.labelMedium.copyWith(
                            color: a['account_type'] == 'savings' ? white70 : gray500)),
                    const SizedBox(height: sp8),
                    Text('${a['currency']} ${a['balance']}',
                        style: AppTextStyles.displayMedium.copyWith(
                            color: a['account_type'] == 'savings' ? white : gray900)),
                    const SizedBox(height: sp4),
                    Text('${a['account_number']}',
                        style: AppTextStyles.caption.copyWith(
                            color: a['account_type'] == 'savings' ? white60 : gray500)),
                  ]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ignore: constant_identifier_names
const white70 = Color(0xB3FFFFFF);
// ignore: constant_identifier_names
const white60 = Color(0x99FFFFFF);
