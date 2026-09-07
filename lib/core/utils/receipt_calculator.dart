import 'package:receipt_management_flutter/data/models/receipt_item_model.dart';

/// Receipt calculation utilities
class ReceiptCalculator {
  ReceiptCalculator._();

  /// Calculate subtotal from items
  static double calculateSubtotal(List<ReceiptItemModel> items) {
    return items.fold(0.0, (sum, item) => sum + item.total);
  }

  /// Calculate tax amount
  static double calculateTax(double subtotal, double taxRate) {
    return subtotal * (taxRate / 100);
  }

  /// Calculate discount amount
  static double calculateDiscount(double subtotal, double discountRate) {
    return subtotal * (discountRate / 100);
  }

  /// Calculate total = subtotal + tax - discount
  static double calculateTotal({
    required double subtotal,
    required double taxRate,
    required double discountRate,
  }) {
    final tax = calculateTax(subtotal, taxRate);
    final discount = calculateDiscount(subtotal, discountRate);
    return subtotal + tax - discount;
  }

  /// Calculate item total = quantity * unitPrice
  static double calculateItemTotal(double quantity, double unitPrice) {
    return quantity * unitPrice;
  }

  /// Recalculate all totals for a list of items
  static Map<String, double> recalculateAll({
    required List<ReceiptItemModel> items,
    required double taxRate,
    required double discountRate,
  }) {
    final subtotal = calculateSubtotal(items);
    final taxAmount = calculateTax(subtotal, taxRate);
    final discountAmount = calculateDiscount(subtotal, discountRate);
    final total = subtotal + taxAmount - discountAmount;

    return {
      'subtotal': double.parse(subtotal.toStringAsFixed(2)),
      'taxAmount': double.parse(taxAmount.toStringAsFixed(2)),
      'discountAmount': double.parse(discountAmount.toStringAsFixed(2)),
      'total': double.parse(total.toStringAsFixed(2)),
    };
  }
}
