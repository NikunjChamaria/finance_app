import 'package:hive/hive.dart';
import 'category_model.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2)
enum TransactionType {
  @HiveField(0)
  income,

  @HiveField(1)
  expense
}

@HiveType(typeId: 3)
class Transaction {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  TransactionType type;

  @HiveField(4)
  Category category;

  @HiveField(5)
  DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      type: TransactionType.values
          .firstWhere((e) => e.toString().split('.').last == json['type']),
      category: Category.fromJson(json['category']),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.toString().split('.').last,
      'category': category.toJson(),
      'date': date.toIso8601String(),
    };
  }
}
