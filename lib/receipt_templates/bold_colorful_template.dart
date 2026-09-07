import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:receipt_management_flutter/data/models/receipt_model.dart';
import 'package:receipt_management_flutter/receipt_templates/base_receipt_template.dart';

/// Bold Colorful — Vibrant with colored header band and modern typography
class BoldColorfulTemplate extends BaseReceiptTemplate {
  static const _primary = PdfColor.fromInt(0xFFE17055);
  static const _secondary = PdfColor.fromInt(0xFF6C5CE7);

  @override
  Future<pw.Document> generate(ReceiptModel receipt) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        build: (context) => [
          // Colored header band
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            decoration: const pw.BoxDecoration(
              gradient: pw.LinearGradient(
                colors: [_primary, _secondary],
                begin: pw.Alignment.topLeft,
                end: pw.Alignment.bottomRight,
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      receipt.businessProfile?.name ?? 'BUSINESS',
                      style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    if (receipt.businessProfile?.address != null)
                      pw.Text(receipt.businessProfile!.address!,
                          style: pw.TextStyle(fontSize: 10, color: PdfColors.white.shade(.8))),
                    pw.Text(
                      [receipt.businessProfile?.phone, receipt.businessProfile?.email]
                          .where((e) => e != null && e.isNotEmpty)
                          .join(' • '),
                      style: pw.TextStyle(fontSize: 9, color: PdfColors.white.shade(.7)),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        borderRadius: pw.BorderRadius.circular(20),
                      ),
                      child: pw.Text(
                        'RECEIPT',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: _primary,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text('# ${receipt.receiptNumber}',
                        style: pw.TextStyle(fontSize: 11, color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        '${receipt.createdAt.day}/${receipt.createdAt.month}/${receipt.createdAt.year}',
                        style: pw.TextStyle(fontSize: 10, color: PdfColors.white.shade(.8))),
                  ],
                ),
              ],
            ),
          ),

          // Body with padding
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Customer
                buildCustomerInfo(receipt),
                pw.SizedBox(height: 20),

                // Items
                buildItemsTable(receipt, headerColor: _primary),
                pw.SizedBox(height: 20),

                // Totals
                buildTotals(receipt, accentColor: _primary),
                pw.SizedBox(height: 30),

                // Footer
                buildFooter(receipt),
              ],
            ),
          ),
        ],
      ),
    );

    return doc;
  }
}
