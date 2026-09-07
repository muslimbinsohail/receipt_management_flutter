import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:receipt_management_flutter/data/models/receipt_model.dart';
import 'package:receipt_management_flutter/receipt_templates/base_receipt_template.dart';

/// Classic Formal — Traditional, bordered sections, serif-style
class ClassicFormalTemplate extends BaseReceiptTemplate {
  static const _accent = PdfColor.fromInt(0xFF2C3E50);

  @override
  Future<pw.Document> generate(ReceiptModel receipt) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Double border header
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: _accent, width: 2),
            ),
            child: pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: _accent, width: 0.5),
              ),
              child: pw.Column(
                children: [
                  pw.Center(
                    child: pw.Text(
                      receipt.businessProfile?.name ?? 'BUSINESS NAME',
                      style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                        color: _accent,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  if (receipt.businessProfile?.address != null)
                    pw.Center(
                      child: pw.Text(
                        receipt.businessProfile!.address!,
                        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                      ),
                    ),
                  pw.SizedBox(height: 2),
                  pw.Center(
                    child: pw.Text(
                      [receipt.businessProfile?.phone, receipt.businessProfile?.email]
                          .where((e) => e != null && e.isNotEmpty)
                          .join(' | '),
                      style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Container(height: 1, color: _accent),
                  pw.SizedBox(height: 10),
                  pw.Center(
                    child: pw.Text(
                      'OFFICIAL RECEIPT',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: _accent,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 20),

          // Receipt info
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Receipt No: ${receipt.receiptNumber}',
                      style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      'Date: ${receipt.createdAt.day}/${receipt.createdAt.month}/${receipt.createdAt.year}',
                      style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
              if (receipt.businessProfile?.taxId != null)
                pw.Text('Tax ID: ${receipt.businessProfile!.taxId}',
                    style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
          pw.SizedBox(height: 16),

          // Customer
          buildCustomerInfo(receipt),
          pw.SizedBox(height: 20),

          // Items
          buildItemsTable(receipt, headerColor: _accent),
          pw.SizedBox(height: 20),

          // Totals
          buildTotals(receipt, accentColor: _accent),
          pw.SizedBox(height: 30),

          // Footer with signature line
          buildFooter(receipt),
          pw.SizedBox(height: 30),

          // Signature line
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                children: [
                  pw.Container(
                    width: 180,
                    height: 1,
                    color: _accent,
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text('Authorized Signature',
                      style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return doc;
  }
}
