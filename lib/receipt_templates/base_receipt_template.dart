import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:receipt_management_flutter/data/models/receipt_model.dart';

/// Base abstract class for receipt PDF templates
abstract class BaseReceiptTemplate {
  /// Generate the complete PDF document
  Future<pw.Document> generate(ReceiptModel receipt);

  /// Build header section with business info
  pw.Widget buildHeader(ReceiptModel receipt, {PdfColor accentColor = PdfColors.indigo}) {
    final business = receipt.businessProfile;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          business?.name ?? 'Business Name',
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
            color: accentColor,
          ),
        ),
        if (business?.address != null && business!.address!.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 4),
            child: pw.Text(business.address!,
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
          ),
        if (business?.phone != null || business?.email != null)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 2),
            child: pw.Text(
              [business?.phone, business?.email]
                  .where((e) => e != null && e.isNotEmpty)
                  .join(' • '),
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ),
        if (business?.website != null && business!.website!.isNotEmpty)
          pw.Text(business.website!,
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
      ],
    );
  }

  /// Build receipt metadata (number, date)
  pw.Widget buildReceiptInfo(ReceiptModel receipt) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text('RECEIPT',
            style: pw.TextStyle(
                fontSize: 28, fontWeight: pw.FontWeight.bold, color: PdfColors.grey300)),
        pw.SizedBox(height: 4),
        pw.Text('# ${receipt.receiptNumber}',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 2),
        pw.Text(
          'Date: ${receipt.createdAt.day}/${receipt.createdAt.month}/${receipt.createdAt.year}',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.Text(
          'Status: ${receipt.status.name.toUpperCase()}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
      ],
    );
  }

  /// Build customer info section
  pw.Widget buildCustomerInfo(ReceiptModel receipt) {
    final customer = receipt.customer;
    if (customer == null || customer.isEmpty) return pw.SizedBox();

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('BILL TO',
              style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey600)),
          pw.SizedBox(height: 4),
          pw.Text(customer.name,
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          if (customer.email != null && customer.email!.isNotEmpty)
            pw.Text(customer.email!,
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
          if (customer.phone != null && customer.phone!.isNotEmpty)
            pw.Text(customer.phone!,
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
          if (customer.address != null && customer.address!.isNotEmpty)
            pw.Text(customer.address!,
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        ],
      ),
    );
  }

  /// Build items table
  pw.Widget buildItemsTable(ReceiptModel receipt, {PdfColor headerColor = PdfColors.indigo}) {
    return pw.TableHelper.fromTextArray(
      headerAlignment: pw.Alignment.centerLeft,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(color: headerColor),
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      headers: ['#', 'Item', 'Qty', 'Price', 'Total'],
      data: receipt.items.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        return [
          '${i + 1}',
          item.name + (item.description != null && item.description!.isNotEmpty
              ? '\n${item.description}'
              : ''),
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

  /// Build totals section
  pw.Widget buildTotals(ReceiptModel receipt, {PdfColor accentColor = PdfColors.indigo}) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 220,
        child: pw.Column(
          children: [
            _totalRow('Subtotal', receipt.subtotal, receipt.currencySymbol),
            if (receipt.taxRate > 0)
              _totalRow(
                  'Tax (${receipt.taxRate.toStringAsFixed(1)}%)', receipt.taxAmount, receipt.currencySymbol),
            if (receipt.discountRate > 0)
              _totalRow('Discount (${receipt.discountRate.toStringAsFixed(1)}%)',
                  -receipt.discountAmount, receipt.currencySymbol),
            pw.Divider(color: PdfColors.grey300),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 4),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TOTAL',
                      style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: accentColor)),
                  pw.Text(
                    '${receipt.currencySymbol}${receipt.total.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: accentColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _totalRow(String label, double amount, String symbol) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
          pw.Text(
            '${amount < 0 ? '-' : ''}$symbol${amount.abs().toStringAsFixed(2)}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  /// Build notes/footer
  pw.Widget buildFooter(ReceiptModel receipt) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (receipt.paymentMethod != null && receipt.paymentMethod!.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Text('Payment Method: ${receipt.paymentMethod}',
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
        if (receipt.notes != null && receipt.notes!.isNotEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.amber50,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Notes:',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                pw.SizedBox(height: 2),
                pw.Text(receipt.notes!,
                    style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800)),
              ],
            ),
          ),
        pw.SizedBox(height: 20),
        pw.Center(
          child: pw.Text(
            'Thank you for your business!',
            style: pw.TextStyle(
                fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.grey500),
          ),
        ),
      ],
    );
  }
}
