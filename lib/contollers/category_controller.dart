import 'package:get/get.dart';
import 'package:my_finance/local_service/local_services.dart';
import 'package:my_finance/models/category_model.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

class CategoryController extends GetxController {
  late Box<Category> _categoryBox;

  List<Category> categories = [];

  @override
  void onInit() {
    super.onInit();
    _categoryBox = LocalDBService.categoryBox;
    categories = _categoryBox.values.toList();
    update();
  }

  Category getCategory(String id) {
    return categories.firstWhere((e) => e.id == id);
  }

  void addCategory(String name) {
    final category = Category(id: const Uuid().v4(), name: name);
    _categoryBox.put(category.id, category);
    categories = _categoryBox.values.toList();
    update();
  }

  void editCategory(String id, String newName) {
    final category = _categoryBox.get(id);
    if (category != null) {
      _categoryBox.put(id, Category(id: id, name: newName));
      categories = _categoryBox.values.toList();
      update();
    }
  }

  void deleteCategory(String id) {
    _categoryBox.delete(id);
    categories = _categoryBox.values.toList();
    update();
  }
}
