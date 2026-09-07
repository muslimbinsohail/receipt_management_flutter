import 'package:get/get.dart';
import 'package:receipt_management_flutter/modules/receipt/controllers/create_receipt_controller.dart';

class ReceiptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateReceiptController());
  }
}
