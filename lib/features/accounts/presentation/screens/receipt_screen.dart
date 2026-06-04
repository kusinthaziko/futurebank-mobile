import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/graphql/client.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../features/auth/domain/auth_state.dart';

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

  Future<Uint8List> _generatePdf(Map<String, dynamic> tx) async {
    final pdf = pw.Document();
    final from = tx['fromAccount'] as Map<String, dynamic>?;
    final to = tx['toAccount'] as Map<String, dynamic>?;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 0,
              child: pw.Text('futureBank',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                  )),
            ),
            pw.Text('Transaction Receipt',
                style: pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
            pw.Divider(),
            pw.SizedBox(height: 20),
            _pdfRow('Reference', tx['reference'] ?? ''),
            _pdfRow('Date', _formatDate(tx['inserted_at'] ?? '')),
            if (from != null) _pdfRow('From', from['accountNumber'] ?? ''),
            if (to != null) _pdfRow('To', to['accountNumber'] ?? ''),
            pw.SizedBox(height: 20),
            pw.Container(
              padding: pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('AMOUNT',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      )),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'MWK ${tx['amount'] ?? ''}',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Row(children: [
              pw.Text('Status: ',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(tx['status'] ?? '',
                  style: pw.TextStyle(
                    color: tx['status'] == 'completed'
                        ? PdfColors.green700
                        : PdfColors.orange700,
                  )),
            ]),
            if (tx['description'] != null) ...[
              pw.SizedBox(height: 12),
              _pdfRow('Description', tx['description'] as String),
            ],
            if (tx['blockchainTxHash'] != null) ...[
              pw.SizedBox(height: 12),
              _pdfRow('Blockchain TX', tx['blockchainTxHash'] as String),
            ],
            pw.SizedBox(height: 40),
            pw.Divider(),
            pw.SizedBox(height: 8),
            pw.Text('This is a computer-generated receipt',
                style: pw.TextStyle(
                  color: PdfColors.grey500,
                  fontSize: 10,
                )),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(children: [
        pw.SizedBox(
          width: 120,
          child: pw.Text(label,
              style: pw.TextStyle(
                color: PdfColors.grey600,
                fontSize: 12,
              )),
        ),
        pw.Expanded(
          child: pw.Text(value, style: pw.TextStyle(fontSize: 12)),
        ),
      ]),
    );
  }

  Future<void> _sharePdf(Map<String, dynamic> tx) async {
    setState(() => _isGeneratingPdf = true);
    try {
      final bytes = await _generatePdf(tx);
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'receipt_${tx['reference']}.pdf',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share PDF: $e')),
      );
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  Future<void> _downloadPdf(Map<String, dynamic> tx) async {
    setState(() => _isGeneratingPdf = true);
    try {
      final bytes = await _generatePdf(tx);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/receipt_${tx['reference']}.pdf');
      await file.writeAsBytes(bytes);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF saved successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download PDF: $e')),
      );
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
        future: client.query(QueryOptions(
          document: gql(_receiptQuery),
          variables: {'id': widget.receiptId},
        )),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || (snap.data?.hasException ?? false)) {
            return ErrorView(error: snap.error ?? snap.data!.exception!);
          }

          final tx =
              snap.data!.data!['transaction'] as Map<String, dynamic>;
          final from = tx['fromAccount'] as Map<String, dynamic>?;
          final to = tx['toAccount'] as Map<String, dynamic>?;

          return ListView(
            padding: const EdgeInsets.all(sp24),
            children: [
              const Icon(Icons.check_circle, color: success500, size: 72),
              const SizedBox(height: sp12),
              const Text('Transaction Successful',
                  style: AppTextStyles.titleLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: sp4),
              Text(tx['transaction_type'] as String? ?? 'Transfer',
                  style: AppTextStyles.bodyMedium.copyWith(color: gray500),
                  textAlign: TextAlign.center),
              const SizedBox(height: sp32),
              _ReceiptRow(
                label: 'Reference',
                value: tx['reference'] as String? ?? '',
                copyable: true,
              ),
              const Divider(height: sp24),
              if (from != null) ...[
                _ReceiptRow(
                  label: 'From',
                  value: from['accountNumber'] as String? ?? '',
                ),
                const Divider(height: sp24),
              ],
              if (to != null) ...[
                _ReceiptRow(
                  label: 'To',
                  value: to['accountNumber'] as String? ?? '',
                ),
                const Divider(height: sp24),
              ],
              _ReceiptRow(
                label: 'Amount',
                value: tx['amount'] as String? ?? '',
                bold: true,
              ),
              const Divider(height: sp24),
              _ReceiptRow(
                label: 'Date',
                value: _formatDate(tx['inserted_at'] as String? ?? ''),
              ),
              const Divider(height: sp24),
              _ReceiptRow(
                label: 'Status',
                value: tx['status'] as String? ?? '',
                status: true,
              ),
              if (tx['blockchainTxHash'] != null) ...[
                const Divider(height: sp24),
                _ReceiptRow(
                  label: 'Blockchain TX',
                  value: tx['blockchainTxHash'] as String,
                  copyable: true,
                ),
              ],
              const SizedBox(height: sp32),
              FBButton(
                label: 'Share Receipt',
                icon: const Icon(Icons.share, size: 16),
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
                child: Text('Back to Home',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: primary500)),
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

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final bool copyable;
  final bool bold;
  final bool status;

  const _ReceiptRow({
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
          child: Text(label,
              style: AppTextStyles.caption.copyWith(color: gray500)),
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
            child: Row(children: [
              Expanded(
                child: Text(value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: bold ? FontWeight.w600 : null,
                      color: status
                          ? (value == 'completed' ? success500 : warning500)
                          : null,
                    )),
              ),
              if (copyable) const Icon(Icons.copy, color: gray500, size: 14),
            ]),
          ),
        ),
      ],
    );
  }
}
