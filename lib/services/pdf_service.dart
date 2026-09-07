import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:receipt_management_flutter/core/enums/template_type.dart';
import 'package:receipt_management_flutter/data/models/receipt_model.dart';
import 'package:receipt_management_flutter/receipt_templates/modern_minimal_template.dart';
import 'package:receipt_management_flutter/receipt_templates/classic_formal_template.dart';
import 'package:receipt_management_flutter/receipt_templates/bold_colorful_template.dart';
import 'package:receipt_management_flutter/receipt_templates/dark_premium_template.dart';
import 'package:receipt_management_flutter/receipt_templates/vintage_template.dart';

/// PDF generation and sharing service
class PdfService {
  /// Generate PDF from receipt using selected template
  Future<Uint8List> generatePdf(ReceiptModel receipt) async {
    final pw.Document doc;

    switch (receipt.templateType) {
      case TemplateType.modernMinimal:
        doc = await ModernMinimalTemplate().generate(receipt);
        break;
      case TemplateType.classicFormal:
        doc = await ClassicFormalTemplate().generate(receipt);
        break;
      case TemplateType.boldColorful:
        doc = await BoldColorfulTemplate().generate(receipt);
        break;
      case TemplateType.darkPremium:
        doc = await DarkPremiumTemplate().generate(receipt);
        break;
      case TemplateType.vintage:
        doc = await VintageTemplate().generate(receipt);
        break;
    }

    return doc.save();
  }

  /// Save PDF to device storage and return file path
  Future<String> savePdf(ReceiptModel receipt) async {
    final bytes = await generatePdf(receipt);
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
        '${dir.path}/receipt_${receipt.receiptNumber.replaceAll('-', '_')}.pdf');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// Share PDF via system share sheet
  Future<void> sharePdf(ReceiptModel receipt) async {
    final filePath = await savePdf(receipt);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(filePath)],
        subject: 'Receipt ${receipt.receiptNumber}',
        text: 'Receipt from ${receipt.businessProfile?.name ?? 'Business'} - '
            'Total: ${receipt.currencySymbol}${receipt.total.toStringAsFixed(2)}',
      ),
    );
  }

  /// Print PDF
  Future<void> printPdf(ReceiptModel receipt) async {
    final bytes = await generatePdf(receipt);
    await Printing.layoutPdf(
      onLayout: (_) => bytes,
      name: 'Receipt_${receipt.receiptNumber}',
    );
  }

  /// Generate preview image of receipt
  Future<Uint8List?> generatePreview(ReceiptModel receipt) async {
    try {
      final bytes = await generatePdf(receipt);
      final pages = Printing.raster(bytes, pages: [0], dpi: 150);
      await for (final page in pages) {
        return await page.toPng();
      }
    } catch (_) {}
    return null;
  }
}
