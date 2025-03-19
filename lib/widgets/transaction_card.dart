import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_finance/models/transaction_model.dart';
import 'package:my_finance/screens/manage_transaction.dart';
import 'package:my_finance/utils/app_text/app_text.dart';
import 'package:my_finance/utils/app_text/app_text_type.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => ManageTransaction(
            transaction: transaction,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: transaction.title,
                appTextType: AppTextType.title,
              ),
              AppText(
                text: transaction.category.name,
                appTextType: AppTextType.subtitle,
              ),
            ],
          ),
          AppText(
              text:
                  "${transaction.type == TransactionType.expense ? "-" : "+"}\$${transaction.amount}",
              appTextType: transaction.type == TransactionType.expense
                  ? AppTextType.loss
                  : AppTextType.profit)
        ],
      ),
    );
  }
}
