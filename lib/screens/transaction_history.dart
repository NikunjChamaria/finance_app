import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_finance/contollers/transaction_controller.dart';
import 'package:my_finance/screens/manage_transaction.dart';
import 'package:my_finance/utils/app_text/app_text.dart';
import 'package:my_finance/utils/app_text/app_text_type.dart';
import 'package:my_finance/utils/color.dart';
import 'package:my_finance/widgets/app_bar.dart';
import 'package:my_finance/widgets/app_button.dart';
import 'package:my_finance/widgets/transaction_card.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionController transactionController = Get.find();
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: CustomAppBar.getAppbar("Transaction History", true),
      body: Column(
        children: [
          AppButton(
              text: "Add Transaction",
              onPressed: () => Get.to(() => const ManageTransaction())),
          transactionController.transactions.isEmpty
              ? const Center(
                  child: AppText(
                      text: "No Transactions",
                      appTextType: AppTextType.heading3),
                )
              : GetBuilder<TransactionController>(builder: (controller) {
                  return ListView.separated(
                    itemCount: controller.allTransactions.length,
                    padding: EdgeInsets.all(20.h),
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 10.h);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return FadeInLeft(
                        duration: const Duration(milliseconds: 200),
                        delay: Duration(milliseconds: index * 20),
                        child: TransactionCard(
                          transaction: controller.allTransactions[index],
                        ),
                      );
                    },
                  );
                })
        ],
      ),
    );
  }
}
