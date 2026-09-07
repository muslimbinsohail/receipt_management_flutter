import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:receipt_management_flutter/data/models/receipt_model.dart';
import 'package:receipt_management_flutter/receipt_templates/base_receipt_template.dart';

/// Modern Minimal — Clean, white, lots of whitespace, thin accent lines
class ModernMinimalTemplate extends BaseReceiptTemplate {
  static const _accent = PdfColor.fromInt(0xFF6C5CE7);

  @override
  Future<pw.Document> generate(ReceiptModel receipt) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Header
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              buildHeader(receipt, accentColor: _accent),
              buildReceiptInfo(receipt),
            ],
          ),

          // Accent line
          pw.Container(
            margin: const pw.EdgeInsets.symmetric(vertical: 20),
            height: 2,
            decoration: const pw.BoxDecoration(
              gradient: pw.LinearGradient(
                colors: [_accent, PdfColor.fromInt(0xFF9B8FEF)],
              ),
            ),
          ),

          // Customer info
          buildCustomerInfo(receipt),
          pw.SizedBox(height: 20),

          // Items
          buildItemsTable(receipt, headerColor: _accent),
          pw.SizedBox(height: 20),

          // Totals
          buildTotals(receipt, accentColor: _accent),
          pw.SizedBox(height: 30),

          // Footer
          buildFooter(receipt),
        ],
      ),
    );

    return doc;
  }
}
