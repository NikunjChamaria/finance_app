import 'package:get/get.dart';
import 'package:my_finance/contollers/category_controller.dart';
import 'package:my_finance/contollers/transaction_controller.dart';

class AppDependencies {
  void inject() {
    Get.put(CategoryController());
    Get.put(TransactionController());
  }
}
