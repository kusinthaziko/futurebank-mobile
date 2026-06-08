import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

/// Handles PDF generation, sharing, and downloading of transaction receipts.
class ReceiptPdfService {
  /// Generates a PDF document from transaction data.
  static Future<Uint8List> generatePdf(Map<String, dynamic> tx) async {
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

  static pw.Widget _pdfRow(String label, String value) {
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

  /// Shares the receipt PDF via the system share sheet.
  static Future<void> sharePdf(Map<String, dynamic> tx) async {
    final bytes = await generatePdf(tx);
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'receipt_${tx['reference']}.pdf',
    );
  }

  /// Downloads the receipt PDF to the device temporary directory.
  static Future<String> downloadPdf(Map<String, dynamic> tx) async {
    final bytes = await generatePdf(tx);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/receipt_${tx['reference']}.pdf');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  static String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}
