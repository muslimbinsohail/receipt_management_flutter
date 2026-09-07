import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:receipt_management_flutter/data/models/receipt_model.dart';
import 'package:receipt_management_flutter/receipt_templates/base_receipt_template.dart';

/// Dark Premium — Dark background with gold accents, luxury feel
class DarkPremiumTemplate extends BaseReceiptTemplate {
  static const _dark = PdfColor.fromInt(0xFF1A1A2E);
  static const _darkSurface = PdfColor.fromInt(0xFF16213E);
  static const _gold = PdfColor.fromInt(0xFFD4A574);
  static const _lightText = PdfColor.fromInt(0xFFE0E0E0);

  @override
  Future<pw.Document> generate(ReceiptModel receipt) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        build: (context) => [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(40),
            decoration: const pw.BoxDecoration(color: _dark),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Gold divider top
                pw.Container(height: 2, color: _gold),
                pw.SizedBox(height: 24),

                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          receipt.businessProfile?.name ?? 'BUSINESS',
                          style: pw.TextStyle(
                            fontSize: 28,
                            fontWeight: pw.FontWeight.bold,
                            color: _gold,
                            letterSpacing: 1,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        if (receipt.businessProfile?.address != null)
                          pw.Text(receipt.businessProfile!.address!,
                              style: const pw.TextStyle(fontSize: 10, color: _lightText)),
                        pw.Text(
                          [receipt.businessProfile?.phone, receipt.businessProfile?.email]
                              .where((e) => e != null && e.isNotEmpty)
                              .join(' • '),
                          style: const pw.TextStyle(fontSize: 9, color: _lightText),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('RECEIPT',
                            style: pw.TextStyle(
                                fontSize: 14, fontWeight: pw.FontWeight.bold, color: _gold, letterSpacing: 3)),
                        pw.SizedBox(height: 4),
                        pw.Text('# ${receipt.receiptNumber}',
                            style: pw.TextStyle(fontSize: 11, color: _lightText, fontWeight: pw.FontWeight.bold)),
                        pw.Text(
                            '${receipt.createdAt.day}/${receipt.createdAt.month}/${receipt.createdAt.year}',
                            style: const pw.TextStyle(fontSize: 10, color: _lightText)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Container(height: 0.5, color: _gold),
                pw.SizedBox(height: 20),

                // Customer
                if (receipt.customer != null && receipt.customer!.isNotEmpty)
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: _darkSurface,
                      borderRadius: pw.BorderRadius.circular(6),
                      border: pw.Border.all(color: _gold, width: 0.5),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('BILL TO',
                            style: pw.TextStyle(
                                fontSize: 9, fontWeight: pw.FontWeight.bold, color: _gold)),
                        pw.SizedBox(height: 4),
                        pw.Text(receipt.customer!.name,
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold, color: _lightText)),
                        if (receipt.customer!.email != null)
                          pw.Text(receipt.customer!.email!,
                              style: const pw.TextStyle(fontSize: 10, color: _lightText)),
                        if (receipt.customer!.phone != null)
                          pw.Text(receipt.customer!.phone!,
                              style: const pw.TextStyle(fontSize: 10, color: _lightText)),
                      ],
                    ),
                  ),
                pw.SizedBox(height: 20),

                // Custom dark items table
                _buildDarkItemsTable(receipt),
                pw.SizedBox(height: 20),

                // Totals
                _buildDarkTotals(receipt),
                pw.SizedBox(height: 30),

                // Payment method & notes
                if (receipt.paymentMethod != null)
                  pw.Text('Payment: ${receipt.paymentMethod}',
                      style: pw.TextStyle(fontSize: 10, color: _gold, fontWeight: pw.FontWeight.bold)),
                if (receipt.notes != null && receipt.notes!.isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: _darkSurface,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Notes:',
                            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: _gold)),
                        pw.SizedBox(height: 2),
                        pw.Text(receipt.notes!,
                            style: const pw.TextStyle(fontSize: 9, color: _lightText)),
                      ],
                    ),
                  ),
                ],
                pw.SizedBox(height: 24),
                pw.Center(
                  child: pw.Text('Thank you for your business!',
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: _gold)),
                ),
                pw.SizedBox(height: 20),
                pw.Container(height: 2, color: _gold),
              ],
            ),
          ),
        ],
      ),
    );

    return doc;
  }

  pw.Widget _buildDarkItemsTable(ReceiptModel receipt) {
    return pw.TableHelper.fromTextArray(
      headerAlignment: pw.Alignment.centerLeft,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(color: _darkSurface),
      headerStyle: pw.TextStyle(color: _gold, fontSize: 10, fontWeight: pw.FontWeight.bold),
      cellStyle: const pw.TextStyle(fontSize: 10, color: _lightText),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1F2937)),
      headers: ['#', 'Item', 'Qty', 'Price', 'Total'],
      data: receipt.items.asMap().entries.map((entry) {
        final item = entry.value;
        return [
          '${entry.key + 1}',
          item.name,
          item.quantity.toStringAsFixed(item.quantity == item.quantity.roundToDouble() ? 0 : 2),
          '${receipt.currencySymbol}${item.unitPrice.toStringAsFixed(2)}',
          '${receipt.currencySymbol}${item.total.toStringAsFixed(2)}',
        ];
      }).toList(),
      columnWidths: {
        0: const pw.FixedColumnWidth(30),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FixedColumnWidth(40),
        3: const pw.FixedColumnWidth(70),
        4: const pw.FixedColumnWidth(80),
      },
    );
  }

  pw.Widget _buildDarkTotals(ReceiptModel receipt) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 220,
        child: pw.Column(
          children: [
            _row('Subtotal', receipt.subtotal, receipt.currencySymbol),
            if (receipt.taxRate > 0)
              _row('Tax (${receipt.taxRate.toStringAsFixed(1)}%)', receipt.taxAmount, receipt.currencySymbol),
            if (receipt.discountRate > 0)
              _row('Discount', -receipt.discountAmount, receipt.currencySymbol),
            pw.Container(height: 0.5, color: _gold, margin: const pw.EdgeInsets.symmetric(vertical: 4)),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TOTAL',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: _gold)),
                pw.Text('${receipt.currencySymbol}${receipt.total.toStringAsFixed(2)}',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: _gold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _row(String label, double amount, String symbol) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: _lightText)),
          pw.Text('${amount < 0 ? '-' : ''}$symbol${amount.abs().toStringAsFixed(2)}',
              style: const pw.TextStyle(fontSize: 10, color: _lightText)),
        ],
      ),
    );
  }
}
