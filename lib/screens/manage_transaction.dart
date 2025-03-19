import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_finance/contollers/category_controller.dart';
import 'package:my_finance/contollers/transaction_controller.dart';
import 'package:my_finance/models/category_model.dart';
import 'package:my_finance/models/transaction_model.dart';
import 'package:my_finance/screens/categories_manager.dart';
import 'package:my_finance/utils/app_text/app_text.dart';
import 'package:my_finance/utils/color.dart';
import 'package:my_finance/utils/date_picker.dart';
import 'package:my_finance/widgets/app_bar.dart';
import 'package:my_finance/utils/app_text/app_text_type.dart';
import 'package:my_finance/widgets/app_button.dart';
import 'package:uuid/uuid.dart';

class ManageTransaction extends StatefulWidget {
  final Transaction? transaction;
  const ManageTransaction({
    super.key,
    this.transaction,
  });

  @override
  State<ManageTransaction> createState() => _ManageTransactionState();
}

class _ManageTransactionState extends State<ManageTransaction> {
  TransactionController transactionController = Get.find();
  CategoryController categoryController = Get.find();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? selectedTransactionType = "Income";
  Category? selectedCategory;
  DateTime selectedDate = DateTime.now();
  final List<String> transactionTypes = ["Income", "Expense"];

  @override
  void initState() {
    if (widget.transaction != null) {
      _titleController.text = widget.transaction?.title ?? '';
      _amountController.text = widget.transaction?.amount.toString() ?? '';
      selectedTransactionType =
          widget.transaction?.type == TransactionType.income
              ? "Income"
              : "Expense";
      selectedCategory = widget.transaction?.category;
      selectedDate = widget.transaction?.date ?? DateTime.now();
    }
    super.initState();
  }

  void _addOrEditTransaction() {
    String title = _titleController.text.trim();
    String amountText = _amountController.text.trim();
    if (title.isEmpty) {
      _showErrorSnackbar("Title is required!");
      return;
    }
    if (amountText.isEmpty) {
      _showErrorSnackbar("Amount is required!");
      return;
    }

    if (categoryController.categories.length == 1) {
      selectedCategory = categoryController.categories[0];
    }

    if (selectedCategory == null) {
      _showErrorSnackbar("Please select a category!");
      return;
    }

    double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showErrorSnackbar("Enter a valid amount!");
      return;
    }

    Transaction newTransaction = Transaction(
      id: widget.transaction?.id ?? const Uuid().v4(),
      title: title,
      amount: amount,
      type: selectedTransactionType == "Income"
          ? TransactionType.income
          : TransactionType.expense,
      category: selectedCategory!,
      date: selectedDate,
    );

    if (widget.transaction != null) {
      transactionController.updateTransaction(newTransaction);
    } else {
      transactionController.addTransaction(newTransaction);
    }
    Get.back();
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar("Error", message,
        backgroundColor: Colors.redAccent, colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: CustomAppBar.getAppbar(
          "${widget.transaction == null ? "Add" : "Edit"} Transaction", true),
      body: GetBuilder<CategoryController>(builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField("Title", _titleController),
              _buildInputField("Amount", _amountController, isNumeric: true),
              _buildDropdown(
                  "Transaction Type", selectedTransactionType, transactionTypes,
                  (value) {
                setState(() {
                  selectedTransactionType = value;
                });
              }),
              _buildCategoryDropdown(
                  "Category", selectedCategory, controller.categories, (value) {
                setState(() {
                  selectedCategory = value;
                });
              }),
              _buildCategoryButton(),
              _buildMonthYearSelector(),
              _buildSubmitButton(),
              _buildDeleteButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCategoryButton() {
    return GestureDetector(
      onTap: () {
        Get.to(() => CategoryManagementScreen());
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 140.w,
            padding: EdgeInsets.all(3.h),
            decoration: BoxDecoration(
                border: Border.all(color: AppColor.primary),
                borderRadius: BorderRadius.circular(12.h)),
            child: const Center(
              child: AppText(
                  text: "Manage Category", appTextType: AppTextType.heading3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(text: label, appTextType: AppTextType.title),
          SizedBox(
            height: 5.h,
          ),
          TextField(
            controller: controller,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            style: getTextStyle(AppTextType.title),
            cursorColor: AppColor.primary,
            decoration: InputDecoration(
              hintText: label,
              focusColor: AppColor.primary,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColor.primary)),
              hintStyle: getTextStyle(AppTextType.heading3),
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColor.primary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String? selectedValue, List<String> items,
      Function(String?) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(text: label, appTextType: AppTextType.title),
          SizedBox(
            height: 5.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.primary,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                style: getTextStyle(AppTextType.title),
                dropdownColor: AppColor.primary,
                icon: const Icon(Icons.arrow_drop_down,
                    color: AppColor.background),
                isExpanded: true,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: AppText(
                        text: item, appTextType: AppTextType.heading3Primary),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown(String label, Category? selectedValue,
      List<Category> items, Function(Category?) onChanged) {
    return items.isEmpty
        ? AppButton(
            text: "Add Category",
            onPressed: () => Get.to(() => CategoryManagementScreen()))
        : items.length == 1
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.primary,
                  ),
                  child: Center(
                    child: AppText(
                        text: items[0].name,
                        appTextType: AppTextType.heading3Primary),
                  ),
                ))
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(text: label, appTextType: AppTextType.title),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.primary,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Category>(
                          value: selectedValue,
                          style: getTextStyle(AppTextType.title),
                          dropdownColor: AppColor.primary,
                          icon: const Icon(Icons.arrow_drop_down,
                              color: AppColor.background),
                          isExpanded: true,
                          items: items.map((Category item) {
                            return DropdownMenuItem<Category>(
                              value: item,
                              child: AppText(
                                  text: item.name,
                                  appTextType: AppTextType.heading3Primary),
                            );
                          }).toList(),
                          onChanged: onChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }

  Widget _buildMonthYearSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(text: "Date", appTextType: AppTextType.title),
        SizedBox(
          height: 5.h,
        ),
        GestureDetector(
          onTap: () async {
            selectedDate =
                await pickDate(context, selectedDate) ?? selectedDate;
            setState(() {});
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.h),
            margin: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.calendar_month, color: Colors.white),
                AppText(
                  text: DateFormat('dd MMMM yyyy').format(selectedDate),
                  appTextType: AppTextType.heading3,
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
        width: double.infinity,
        child: AppButton(
          text: "${widget.transaction == null ? "Add" : "Edit"} Transaction",
          onPressed: _addOrEditTransaction,
        ));
  }

  Widget _buildDeleteButton() {
    return widget.transaction == null
        ? const SizedBox.shrink()
        : SizedBox(
            width: double.infinity,
            child: AppButton(
              buttonColor: AppColor.red,
              text: "Delete Transaction",
              onPressed: () {
                transactionController
                    .deleteTransaction(widget.transaction?.id ?? '');
                Get.back();
              },
            ));
  }
}
