import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/icons.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/graphql/client.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../features/auth/domain/auth_state.dart';
import '../../data/receipt_pdf_service.dart';
import '../widgets/receipt_row.dart';

const _receiptQuery = r'''
  query Receipt($id: ID!) {
    transaction(id: $id) {
      id reference description amount transaction_type status inserted_at
      fromAccount { id accountNumber }
      toAccount { id accountNumber }
      blockchainTxHash
    }
  }
''';

class ReceiptScreen extends ConsumerStatefulWidget {
  final String receiptId;
  const ReceiptScreen({super.key, required this.receiptId});

  @override
  ConsumerState<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends ConsumerState<ReceiptScreen> {
  bool _isGeneratingPdf = false;

  Future<void> _sharePdf(Map<String, dynamic> tx) async {
    setState(() => _isGeneratingPdf = true);
    try {
      await ReceiptPdfService.sharePdf(tx);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to share PDF: $e')));
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  Future<void> _downloadPdf(Map<String, dynamic> tx) async {
    setState(() => _isGeneratingPdf = true);
    try {
      await ReceiptPdfService.downloadPdf(tx);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('PDF saved successfully')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to download PDF: $e')));
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final token = auth is Authenticated ? auth.accessToken : null;
    final client = ref.read(graphQLClientProvider(token));

    return Scaffold(
      appBar: AppBar(title: const Text('Receipt')),
      body: FutureBuilder<QueryResult>(
        future: client.query(
          QueryOptions(
            document: gql(_receiptQuery),
            variables: {'id': widget.receiptId},
          ),
        ),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || (snap.data?.hasException ?? false)) {
            return ErrorView(error: snap.error ?? snap.data!.exception!);
          }

          final tx = snap.data?.data?['transaction'] as Map<String, dynamic>?;
          if (tx == null) {
            return const Center(child: Text('Receipt not found'));
          }
          final from = tx['fromAccount'] as Map<String, dynamic>?;
          final to = tx['toAccount'] as Map<String, dynamic>?;

          return ListView(
            padding: const EdgeInsets.all(sp24),
            children: [
              const Icon(FbIcons.checkCircle, color: success500, size: 72),
              const SizedBox(height: sp12),
              const Text(
                'Transaction Successful',
                style: AppTextStyles.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: sp4),
              Text(
                tx['transaction_type'] as String? ?? 'Transfer',
                style: AppTextStyles.bodyMedium.copyWith(color: gray500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: sp32),
              ReceiptRow(
                label: 'Reference',
                value: tx['reference'] as String? ?? '',
                copyable: true,
              ),
              const Divider(height: sp24),
              if (from != null) ...[
                ReceiptRow(
                  label: 'From',
                  value: from['accountNumber'] as String? ?? '',
                ),
                const Divider(height: sp24),
              ],
              if (to != null) ...[
                ReceiptRow(
                  label: 'To',
                  value: to['accountNumber'] as String? ?? '',
                ),
                const Divider(height: sp24),
              ],
              ReceiptRow(
                label: 'Amount',
                value: tx['amount'] as String? ?? '',
                bold: true,
              ),
              const Divider(height: sp24),
              ReceiptRow(
                label: 'Date',
                value: _formatDate(tx['inserted_at'] as String? ?? ''),
              ),
              const Divider(height: sp24),
              ReceiptRow(
                label: 'Status',
                value: tx['status'] as String? ?? '',
                status: true,
              ),
              if (tx['blockchainTxHash'] != null) ...[
                const Divider(height: sp24),
                ReceiptRow(
                  label: 'Blockchain TX',
                  value: tx['blockchainTxHash'] as String,
                  copyable: true,
                ),
              ],
              const SizedBox(height: sp32),
              FBButton(
                label: 'Share Receipt',
                icon: const Icon(FbIcons.share, size: 16),
                variant: FBButtonVariant.secondary,
                loading: _isGeneratingPdf,
                onPressed: _isGeneratingPdf ? null : () => _sharePdf(tx),
              ),
              const SizedBox(height: sp12),
              FBButton(
                label: 'Download PDF',
                icon: const Icon(Icons.download, size: 16),
                variant: FBButtonVariant.ghost,
                loading: _isGeneratingPdf,
                onPressed: _isGeneratingPdf ? null : () => _downloadPdf(tx),
              ),
              const SizedBox(height: sp12),
              TextButton(
                onPressed: () => context.go('/home'),
                child: Text(
                  'Back to Home',
                  style: AppTextStyles.labelMedium.copyWith(color: primary500),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}
