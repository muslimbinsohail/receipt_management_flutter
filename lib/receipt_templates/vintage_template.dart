import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:receipt_management_flutter/data/models/receipt_model.dart';
import 'package:receipt_management_flutter/receipt_templates/base_receipt_template.dart';

/// Vintage — Retro style with sepia tones and decorative borders
class VintageTemplate extends BaseReceiptTemplate {
  static const _sepia = PdfColor.fromInt(0xFF8B7355);
  static const _warmBg = PdfColor.fromInt(0xFFFAF0E6);

  @override
  Future<pw.Document> generate(ReceiptModel receipt) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Outer decorative border
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: _sepia, width: 2),
            ),
            child: pw.Container(
              padding: const pw.EdgeInsets.all(28),
              decoration: pw.BoxDecoration(
                color: _warmBg,
                border: pw.Border.all(color: _sepia, width: 1),
              ),
              child: pw.Column(
                children: [
                  // Ornamental top line
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(width: 60, height: 1, color: _sepia),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('✦',
                            style: pw.TextStyle(fontSize: 14, color: _sepia, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Container(width: 60, height: 1, color: _sepia),
                    ],
                  ),
                  pw.SizedBox(height: 16),

                  // Business name
                  pw.Center(
                    child: pw.Text(
                      receipt.businessProfile?.name ?? 'ESTABLISHMENT',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: _sepia,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 4),

                  if (receipt.businessProfile?.address != null)
                    pw.Center(
                      child: pw.Text(receipt.businessProfile!.address!,
                          style: const pw.TextStyle(fontSize: 10, color: _sepia)),
                    ),
                  pw.Center(
                    child: pw.Text(
                      [receipt.businessProfile?.phone, receipt.businessProfile?.email]
                          .where((e) => e != null && e.isNotEmpty)
                          .join(' ~ '),
                      style: const pw.TextStyle(fontSize: 9, color: _sepia),
                    ),
                  ),
                  pw.SizedBox(height: 12),

                  // Ornamental divider
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(width: 100, height: 0.5, color: _sepia),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 8),
                        child: pw.Text('RECEIPT',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold, color: _sepia, letterSpacing: 4)),
                      ),
                      pw.Container(width: 100, height: 0.5, color: _sepia),
                    ],
                  ),
                  pw.SizedBox(height: 16),

                  // Receipt info
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('No: ${receipt.receiptNumber}',
                          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _sepia)),
                      pw.Text(
                          'Date: ${receipt.createdAt.day}/${receipt.createdAt.month}/${receipt.createdAt.year}',
                          style: const pw.TextStyle(fontSize: 10, color: _sepia)),
                    ],
                  ),
                  pw.SizedBox(height: 12),

                  // Customer
                  if (receipt.customer != null && receipt.customer!.isNotEmpty) ...[
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: _sepia, width: 0.5),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Billed To:',
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold, color: _sepia)),
                          pw.Text(receipt.customer!.name,
                              style: pw.TextStyle(
                                  fontSize: 11, fontWeight: pw.FontWeight.bold, color: _sepia)),
                          if (receipt.customer!.email != null)
                            pw.Text(receipt.customer!.email!,
                                style: const pw.TextStyle(fontSize: 9, color: _sepia)),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 16),
                  ],

                  // Items table
                  buildItemsTable(receipt, headerColor: _sepia),
                  pw.SizedBox(height: 16),

                  // Totals
                  buildTotals(receipt, accentColor: _sepia),
                  pw.SizedBox(height: 24),

                  // Notes & Payment
                  if (receipt.paymentMethod != null)
                    pw.Text('Payment: ${receipt.paymentMethod}',
                        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _sepia)),
                  if (receipt.notes != null && receipt.notes!.isNotEmpty) ...[
                    pw.SizedBox(height: 6),
                    pw.Text('Note: ${receipt.notes}',
                        style: const pw.TextStyle(fontSize: 9, color: _sepia)),
                  ],
                  pw.SizedBox(height: 20),

                  // Bottom ornament
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(width: 60, height: 1, color: _sepia),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('With Gratitude',
                            style: pw.TextStyle(
                                fontSize: 11, color: _sepia, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Container(width: 60, height: 1, color: _sepia),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return doc;
  }
}
