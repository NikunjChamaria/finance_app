import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_finance/contollers/category_controller.dart';
import 'package:my_finance/models/category_model.dart';
import 'package:my_finance/utils/app_text/app_text.dart';
import 'package:my_finance/utils/app_text/app_text_type.dart';
import 'package:my_finance/utils/color.dart';
import 'package:my_finance/widgets/app_bar.dart';

class CategoryManagementScreen extends StatelessWidget {
  final CategoryController categoryController = Get.find();

  CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: CustomAppBar.getAppbar("Manage Categories", true),
      body: GetBuilder<CategoryController>(builder: (controller) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: AppText(
                    text: category.name, appTextType: AppTextType.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColor.primary),
                      onPressed: () => _showCategoryDialog(context, category),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: AppColor.red),
                      onPressed: () =>
                          categoryController.deleteCategory(category.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primary,
        onPressed: () => _showCategoryDialog(context),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, [Category? category]) {
    final TextEditingController controller =
        TextEditingController(text: category?.name ?? '');

    Get.defaultDialog(
      backgroundColor: AppColor.background,
      title: category == null ? "Add Category" : "Edit Category",
      titleStyle: getTextStyle(AppTextType.heading2),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          style: getTextStyle(AppTextType.title),
          decoration: InputDecoration(
            hintText: "Category Name",
            hintStyle: getTextStyle(AppTextType.subtitle),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.primary)),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child:
              const AppText(text: "Cancel", appTextType: AppTextType.heading3),
        ),
        TextButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              if (category == null) {
                categoryController.addCategory(controller.text);
              } else {
                categoryController.editCategory(category.id, controller.text);
              }
            }
            Get.back();
          },
          child: const AppText(text: "Save", appTextType: AppTextType.heading3),
        ),
      ],
    );
  }
}
