/// Firestore collection and field name constants
class FirestoreConstants {
  FirestoreConstants._();

  // Collections
  static const String usersCollection = 'users';
  static const String receiptsCollection = 'receipts';
  static const String businessProfilesCollection = 'business_profiles';
  static const String customersCollection = 'customers';

  // Receipt Fields
  static const String fieldId = 'id';
  static const String fieldReceiptNumber = 'receiptNumber';
  static const String fieldBusinessName = 'businessName';
  static const String fieldCustomerName = 'customerName';
  static const String fieldItems = 'items';
  static const String fieldSubtotal = 'subtotal';
  static const String fieldTaxRate = 'taxRate';
  static const String fieldTaxAmount = 'taxAmount';
  static const String fieldDiscountRate = 'discountRate';
  static const String fieldDiscountAmount = 'discountAmount';
  static const String fieldTotal = 'total';
  static const String fieldTemplateType = 'templateType';
  static const String fieldNotes = 'notes';
  static const String fieldStatus = 'status';
  static const String fieldCurrency = 'currency';
  static const String fieldCurrencySymbol = 'currencySymbol';
  static const String fieldPaymentMethod = 'paymentMethod';
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldUpdatedAt = 'updatedAt';

  // Item Fields
  static const String fieldItemName = 'name';
  static const String fieldItemDescription = 'description';
  static const String fieldItemQuantity = 'quantity';
  static const String fieldItemUnitPrice = 'unitPrice';
  static const String fieldItemTotal = 'total';

  // Business Profile Fields
  static const String fieldName = 'name';
  static const String fieldAddress = 'address';
  static const String fieldPhone = 'phone';
  static const String fieldEmail = 'email';
  static const String fieldTaxId = 'taxId';
  static const String fieldLogoUrl = 'logoUrl';
  static const String fieldWebsite = 'website';
}
