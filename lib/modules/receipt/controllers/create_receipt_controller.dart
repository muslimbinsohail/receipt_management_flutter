import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:receipt_management_flutter/core/constants/app_constants.dart';
import 'package:receipt_management_flutter/core/enums/receipt_status.dart';
import 'package:receipt_management_flutter/core/enums/sync_status.dart';
import 'package:receipt_management_flutter/core/enums/template_type.dart';
import 'package:receipt_management_flutter/core/utils/formatters.dart';
import 'package:receipt_management_flutter/core/utils/receipt_calculator.dart';
import 'package:receipt_management_flutter/core/utils/snackbar_helper.dart';
import 'package:receipt_management_flutter/data/models/business_profile_model.dart';
import 'package:receipt_management_flutter/data/models/customer_model.dart';
import 'package:receipt_management_flutter/data/models/receipt_item_model.dart';
import 'package:receipt_management_flutter/data/models/receipt_model.dart';
import 'package:receipt_management_flutter/data/repositories/receipt_repository.dart';
import 'package:receipt_management_flutter/services/error_handler_service.dart';
import 'package:receipt_management_flutter/services/pdf_service.dart';

class CreateReceiptController extends GetxController {
  final ReceiptRepository _receiptRepository = Get.find<ReceiptRepository>();
  final ErrorHandlerService _errorHandler = Get.find<ErrorHandlerService>();
  final PdfService _pdfService = PdfService();

  // Form keys
  final businessFormKey = GlobalKey<FormState>();
  final customerFormKey = GlobalKey<FormState>();
  final itemsFormKey = GlobalKey<FormState>();

  // Editing state (null = creating new)
  ReceiptModel? editingReceipt;
  bool get isEditing => editingReceipt != null;

  // Page controller for multi-step form
  final pageController = PageController();
  final RxInt currentStep = 0.obs;
  final totalSteps = 4;

  // Business Profile
  final businessNameController = TextEditingController();
  final businessAddressController = TextEditingController();
  final businessPhoneController = TextEditingController();
  final businessEmailController = TextEditingController();
  final businessTaxIdController = TextEditingController();
  final businessWebsiteController = TextEditingController();

  // Customer
  final customerNameController = TextEditingController();
  final customerEmailController = TextEditingController();
  final customerPhoneController = TextEditingController();
  final customerAddressController = TextEditingController();

  // Items
  final RxList<ReceiptItemModel> items = <ReceiptItemModel>[].obs;
  final RxList<Map<String, TextEditingController>> itemControllers =
      <Map<String, TextEditingController>>[].obs;

  // Receipt settings
  final Rx<TemplateType> selectedTemplate = TemplateType.modernMinimal.obs;
  final taxRateController = TextEditingController(text: '0');
  final discountRateController = TextEditingController(text: '0');
  final notesController = TextEditingController();
  final RxString paymentMethod = 'Cash'.obs;
  final RxString currency = AppConstants.defaultCurrency.obs;
  final RxString currencySymbol = AppConstants.defaultCurrencySymbol.obs;

  // Totals
  final RxDouble subtotal = 0.0.obs;
  final RxDouble taxAmount = 0.0.obs;
  final RxDouble discountAmount = 0.0.obs;
  final RxDouble total = 0.0.obs;

  // Loading
  final RxBool isSaving = false.obs;

  final List<String> paymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'Cheque',
    'Mobile Payment',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    // Check if editing existing receipt
    if (Get.arguments is ReceiptModel) {
      editingReceipt = Get.arguments as ReceiptModel;
      _populateFromReceipt(editingReceipt!);
    } else {
      // Add one empty item by default
      addItem();
    }
  }

  void _populateFromReceipt(ReceiptModel receipt) {
    // Business
    businessNameController.text = receipt.businessProfile?.name ?? '';
    businessAddressController.text = receipt.businessProfile?.address ?? '';
    businessPhoneController.text = receipt.businessProfile?.phone ?? '';
    businessEmailController.text = receipt.businessProfile?.email ?? '';
    businessTaxIdController.text = receipt.businessProfile?.taxId ?? '';
    businessWebsiteController.text = receipt.businessProfile?.website ?? '';

    // Customer
    customerNameController.text = receipt.customer?.name ?? '';
    customerEmailController.text = receipt.customer?.email ?? '';
    customerPhoneController.text = receipt.customer?.phone ?? '';
    customerAddressController.text = receipt.customer?.address ?? '';

    // Items
    for (final item in receipt.items) {
      final controllers = _createItemControllers();
      controllers['name']!.text = item.name;
      controllers['description']!.text = item.description ?? '';
      controllers['quantity']!.text = item.quantity.toString();
      controllers['unitPrice']!.text = item.unitPrice.toString();
      itemControllers.add(controllers);
      items.add(item);
    }

    // Settings
    selectedTemplate.value = receipt.templateType;
    taxRateController.text = receipt.taxRate.toString();
    discountRateController.text = receipt.discountRate.toString();
    notesController.text = receipt.notes ?? '';
    paymentMethod.value = receipt.paymentMethod ?? 'Cash';
    currency.value = receipt.currency;
    currencySymbol.value = receipt.currencySymbol;

    recalculateTotals();
  }

  /// Add a new empty item row
  void addItem() {
    final controllers = _createItemControllers();
    itemControllers.add(controllers);
    items.add(ReceiptItemModel.empty(const Uuid().v4()));
  }

  Map<String, TextEditingController> _createItemControllers() {
    return {
      'name': TextEditingController(),
      'description': TextEditingController(),
      'quantity': TextEditingController(text: '1'),
      'unitPrice': TextEditingController(text: '0'),
    };
  }

  /// Remove an item
  void removeItem(int index) {
    if (items.length <= 1) {
      SnackbarHelper.warning('Receipt must have at least one item.');
      return;
    }
    // Dispose controllers
    itemControllers[index].values.forEach((c) => c.dispose());
    itemControllers.removeAt(index);
    items.removeAt(index);
    recalculateTotals();
  }

  /// Update an item from its controllers
  void updateItem(int index) {
    if (index >= itemControllers.length) return;

    final controllers = itemControllers[index];
    final qty = double.tryParse(controllers['quantity']!.text) ?? 0;
    final price = double.tryParse(controllers['unitPrice']!.text) ?? 0;

    items[index] = ReceiptItemModel(
      id: items[index].id,
      name: controllers['name']!.text,
      description: controllers['description']!.text.isEmpty
          ? null
          : controllers['description']!.text,
      quantity: qty,
      unitPrice: price,
      total: ReceiptCalculator.calculateItemTotal(qty, price),
    );

    recalculateTotals();
  }

  /// Recalculate all totals
  void recalculateTotals() {
    final taxRate = double.tryParse(taxRateController.text) ?? 0;
    final discountRate = double.tryParse(discountRateController.text) ?? 0;

    final totals = ReceiptCalculator.recalculateAll(
      items: items,
      taxRate: taxRate,
      discountRate: discountRate,
    );

    subtotal.value = totals['subtotal']!;
    taxAmount.value = totals['taxAmount']!;
    discountAmount.value = totals['discountAmount']!;
    total.value = totals['total']!;
  }

  /// Navigate to next step
  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      // Validate current step
      if (!_validateCurrentStep()) return;

      currentStep.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Navigate to previous step
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 0: // Business info
        return businessFormKey.currentState?.validate() ?? false;
      case 1: // Customer info (optional, always valid)
        return true;
      case 2: // Items
        // Update all items from controllers
        for (int i = 0; i < items.length; i++) {
          updateItem(i);
        }
        if (items.every((item) => item.name.isEmpty)) {
          SnackbarHelper.warning('Please add at least one item.');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  /// Save receipt (as draft or finalized)
  Future<void> saveReceipt({bool finalize = false}) async {
    isSaving.value = true;

    try {
      // Update items from controllers
      for (int i = 0; i < items.length; i++) {
        updateItem(i);
      }
      recalculateTotals();

      // Filter out empty items
      final validItems =
          items.where((item) => item.name.isNotEmpty).toList();

      if (validItems.isEmpty) {
        SnackbarHelper.warning('Add at least one item to save.');
        isSaving.value = false;
        return;
      }

      final receipt = ReceiptModel(
        id: editingReceipt?.id ?? const Uuid().v4(),
        receiptNumber:
            editingReceipt?.receiptNumber ?? Formatters.generateReceiptNumber(),
        businessProfile: BusinessProfileModel(
          id: editingReceipt?.businessProfile?.id ?? const Uuid().v4(),
          name: businessNameController.text.trim(),
          address: businessAddressController.text.trim(),
          phone: businessPhoneController.text.trim(),
          email: businessEmailController.text.trim(),
          taxId: businessTaxIdController.text.trim(),
          website: businessWebsiteController.text.trim(),
        ),
        customer: customerNameController.text.trim().isNotEmpty
            ? CustomerModel(
                name: customerNameController.text.trim(),
                email: customerEmailController.text.trim(),
                phone: customerPhoneController.text.trim(),
                address: customerAddressController.text.trim(),
              )
            : null,
        items: validItems,
        subtotal: subtotal.value,
        taxRate: double.tryParse(taxRateController.text) ?? 0,
        taxAmount: taxAmount.value,
        discountRate: double.tryParse(discountRateController.text) ?? 0,
        discountAmount: discountAmount.value,
        total: total.value,
        templateType: selectedTemplate.value,
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
        status: finalize ? ReceiptStatus.finalized : ReceiptStatus.draft,
        syncStatus: SyncStatus.pending,
        currency: currency.value,
        currencySymbol: currencySymbol.value,
        paymentMethod: paymentMethod.value,
        createdAt: editingReceipt?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (isEditing) {
        await _receiptRepository.updateReceipt(receipt);
        SnackbarHelper.success('Receipt updated successfully');
      } else {
        await _receiptRepository.createReceipt(receipt);
        SnackbarHelper.success(
            finalize ? 'Receipt finalized!' : 'Draft saved');
      }

      Get.back(result: receipt);
    } catch (e) {
      _errorHandler.handleError(e, context: 'Save Receipt');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    businessNameController.dispose();
    businessAddressController.dispose();
    businessPhoneController.dispose();
    businessEmailController.dispose();
    businessTaxIdController.dispose();
    businessWebsiteController.dispose();
    customerNameController.dispose();
    customerEmailController.dispose();
    customerPhoneController.dispose();
    customerAddressController.dispose();
    taxRateController.dispose();
    discountRateController.dispose();
    notesController.dispose();
    for (final controllers in itemControllers) {
      controllers.values.forEach((c) => c.dispose());
    }
    super.onClose();
  }
}
