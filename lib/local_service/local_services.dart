import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_finance/models/category_model.dart';
import 'package:my_finance/models/transaction_model.dart';

class LocalDBService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
    await Hive.openBox<Category>('categories');
    await Hive.openBox<Transaction>('transactions');
  }

  static Box<Category> get categoryBox => Hive.box<Category>('categories');
  static Box<Transaction> get transactionBox =>
      Hive.box<Transaction>('transactions');
}
