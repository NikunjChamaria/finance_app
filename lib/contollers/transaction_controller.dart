import 'package:get/get.dart';
import 'package:my_finance/local_service/local_services.dart';
import 'package:my_finance/models/transaction_model.dart';
import 'package:hive/hive.dart';

class TransactionController extends GetxController {
  late Box<Transaction> _transactionBox;

  List<Transaction> transactions = [];
  List<Transaction> selectedTransactions = [];
  DateTime selectedDate = DateTime.now();
  double expense = 0;
  double income = 0;
  double balance = 0;

  @override
  void onInit() {
    super.onInit();
    _transactionBox = LocalDBService.transactionBox;
    transactions = _transactionBox.values.toList();
    updateSelectedTransactions();
  }

  void addTransaction(Transaction transaction) {
    _transactionBox.put(transaction.id, transaction);
    transactions = _transactionBox.values.toList();
    updateSelectedTransactions();
    update();
  }

  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    updateSelectedTransactions();
  }

  void updateSelectedTransactions() {
    selectedTransactions = transactions
        .where((e) =>
            e.date.month == selectedDate.month &&
            e.date.year == selectedDate.year)
        .toList();

    expense = selectedTransactions
        .where((e) => e.type == TransactionType.expense)
        .fold(0, (sum, e) => sum + e.amount);
    income = selectedTransactions
        .where((e) => e.type == TransactionType.income)
        .fold(0, (sum, e) => sum + e.amount);
    balance = income - expense;
    update();
  }

  List<Transaction> get allSelectedTransactions {
    selectedTransactions.sort((a, b) => a.date.compareTo(b.date));
    return selectedTransactions;
  }

  List<Transaction> get allTransactions {
    transactions.sort((a, b) => a.date.compareTo(b.date));
    return transactions;
  }

  void updateTransaction(Transaction updatedTransaction) {
    _transactionBox.put(updatedTransaction.id, updatedTransaction);
    transactions = _transactionBox.values.toList();
    updateSelectedTransactions();
    update();
  }

  void deleteTransaction(String id) {
    _transactionBox.delete(id);
    transactions = _transactionBox.values.toList();
    updateSelectedTransactions();
    update();
  }
}
