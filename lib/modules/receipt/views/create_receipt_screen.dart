import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receipt_management_flutter/app/theme/app_colors.dart';
import 'package:receipt_management_flutter/app/theme/app_text_styles.dart';
import 'package:receipt_management_flutter/core/enums/template_type.dart';
import 'package:receipt_management_flutter/core/utils/formatters.dart';
import 'package:receipt_management_flutter/core/utils/validators.dart';
import 'package:receipt_management_flutter/modules/receipt/controllers/create_receipt_controller.dart';

class CreateReceiptScreen extends GetView<CreateReceiptController> {
  const CreateReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Edit Receipt' : 'New Receipt'),
        actions: [
          Obx(() => controller.isSaving.value
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                )
              : TextButton(
                  onPressed: () => controller.saveReceipt(finalize: false),
                  child: const Text('Save Draft'),
                )),
        ],
      ),
      body: Column(
        children: [
          // Step indicator
          Obx(() => _buildStepIndicator()),

          // Page view
          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => controller.currentStep.value = i,
              children: [
                _buildBusinessStep(),
                _buildCustomerStep(),
                _buildItemsStep(),
                _buildReviewStep(),
              ],
            ),
          ),

          // Navigation buttons
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Business', 'Customer', 'Items', 'Review'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = controller.currentStep.value >= i;
          return Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      isActive ? AppColors.primary : AppColors.surfaceVariant,
                  child: Text(
                    '${i + 1}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isActive ? Colors.white : AppColors.textTertiary,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    steps[i],
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isActive
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (i < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 1.5,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: isActive
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : AppColors.divider,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBusinessStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: controller.businessFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Business Information', style: AppTextStyles.h3),
            const SizedBox(height: 4),
            Text('Add your business details for the receipt header.',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            TextFormField(
              controller: controller.businessNameController,
              decoration: const InputDecoration(
                labelText: 'Business Name *',
                prefixIcon: Icon(Icons.store_rounded),
              ),
              validator: Validators.businessName,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: controller.businessAddressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              maxLines: 2,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.businessPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: Validators.phone,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: controller.businessEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.businessTaxIdController,
                    decoration: const InputDecoration(
                      labelText: 'Tax ID / NTN',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: controller.businessWebsiteController,
                    decoration: const InputDecoration(
                      labelText: 'Website',
                      prefixIcon: Icon(Icons.language_rounded),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: controller.customerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Information', style: AppTextStyles.h3),
            const SizedBox(height: 4),
            Text('Optional — add buyer details for the receipt.',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            TextFormField(
              controller: controller.customerNameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: controller.customerEmailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: controller.customerPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: controller.customerAddressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Receipt Items', style: AppTextStyles.h3),
                  const SizedBox(height: 2),
                  Text('Add products or services.',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
              FilledButton.tonalIcon(
                onPressed: controller.addItem,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add Item'),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() => ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: controller.items.length,
                itemBuilder: (context, index) =>
                    _buildItemCard(index),
              )),
        ),
        // Tax & Discount row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.taxRateController,
                  decoration: const InputDecoration(
                    labelText: 'Tax %',
                    prefixIcon: Icon(Icons.percent_rounded, size: 18),
                    isDense: true,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => controller.recalculateTotals(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller.discountRateController,
                  decoration: const InputDecoration(
                    labelText: 'Discount %',
                    prefixIcon: Icon(Icons.discount_outlined, size: 18),
                    isDense: true,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => controller.recalculateTotals(),
                ),
              ),
            ],
          ),
        ),
        // Totals display
        Obx(() => Container(
              margin: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  _totalRow('Subtotal', controller.subtotal.value),
                  if (controller.taxAmount.value > 0)
                    _totalRow('Tax', controller.taxAmount.value),
                  if (controller.discountAmount.value > 0)
                    _totalRow('Discount', -controller.discountAmount.value),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total',
                          style: AppTextStyles.h4
                              .copyWith(color: AppColors.primary)),
                      Text(
                        Formatters.currency(controller.total.value,
                            symbol: controller.currencySymbol.value),
                        style: AppTextStyles.currencyAmount
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildItemCard(int index) {
    final controllers = controller.itemControllers[index];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text('${index + 1}',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.primary)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controllers['name'],
                    decoration: const InputDecoration(
                      hintText: 'Item name',
                      isDense: true,
                      border: InputBorder.none,
                    ),
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontWeight: FontWeight.w500),
                    onChanged: (_) => controller.updateItem(index),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded,
                      size: 18, color: AppColors.error),
                  onPressed: () => controller.removeItem(index),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controllers['quantity'],
                    decoration: const InputDecoration(
                      labelText: 'Qty',
                      isDense: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    onChanged: (_) => controller.updateItem(index),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: controllers['unitPrice'],
                    decoration: InputDecoration(
                      labelText: 'Unit Price',
                      prefixText: '${controller.currencySymbol.value} ',
                      isDense: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    onChanged: (_) => controller.updateItem(index),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() {
                    final item = index < controller.items.length
                        ? controller.items[index]
                        : null;
                    return Text(
                      Formatters.currency(item?.total ?? 0,
                          symbol: controller.currencySymbol.value),
                      style: AppTextStyles.currencyAmountSmall
                          .copyWith(color: AppColors.primary),
                      textAlign: TextAlign.right,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review & Finalize', style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text('Review your receipt before saving.',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 20),

          // Template selector
          Text('Receipt Design', style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: TemplateType.values.map((type) {
                  final isSelected =
                      controller.selectedTemplate.value == type;
                  return ChoiceChip(
                    label: Text(type.label),
                    selected: isSelected,
                    onSelected: (_) =>
                        controller.selectedTemplate.value = type,
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  );
                }).toList(),
              )),
          const SizedBox(height: 20),

          // Payment method
          Text('Payment Method', style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.paymentMethod.value,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.payment_rounded),
                ),
                items: controller.paymentMethods
                    .map((m) => DropdownMenuItem(
                          value: m,
                          child: Text(m),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) controller.paymentMethod.value = v;
                },
              )),
          const SizedBox(height: 16),

          // Notes
          TextField(
            controller: controller.notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
              prefixIcon: Icon(Icons.note_outlined),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            maxLength: 500,
          ),
          const SizedBox(height: 20),

          // Final totals
          Obx(() => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.08),
                      AppColors.secondary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15)),
                ),
                child: Column(
                  children: [
                    _totalRow('Subtotal', controller.subtotal.value),
                    if (controller.taxAmount.value > 0)
                      _totalRow('Tax', controller.taxAmount.value),
                    if (controller.discountAmount.value > 0)
                      _totalRow('Discount', -controller.discountAmount.value),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TOTAL',
                            style: AppTextStyles.h3
                                .copyWith(color: AppColors.primary)),
                        Text(
                          Formatters.currency(controller.total.value,
                              symbol: controller.currencySymbol.value),
                          style: AppTextStyles.currencyAmount
                              .copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _totalRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            '${amount < 0 ? '-' : ''}${Formatters.currency(amount.abs(), symbol: controller.currencySymbol.value)}',
            style: AppTextStyles.bodyMedium
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(Get.context!).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                  color: Theme.of(Get.context!).dividerColor, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              if (controller.currentStep.value > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.previousStep,
                    child: const Text('Back'),
                  ),
                ),
              if (controller.currentStep.value > 0)
                const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: controller.currentStep.value ==
                        controller.totalSteps - 1
                    ? ElevatedButton(
                        onPressed: controller.isSaving.value
                            ? null
                            : () => controller.saveReceipt(finalize: true),
                        child: controller.isSaving.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Finalize Receipt'),
                      )
                    : ElevatedButton(
                        onPressed: controller.nextStep,
                        child: const Text('Next'),
                      ),
              ),
            ],
          ),
        ));
  }
}
