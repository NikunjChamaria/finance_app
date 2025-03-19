import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_finance/contollers/category_controller.dart';
import 'package:my_finance/contollers/transaction_controller.dart';
import 'package:my_finance/models/category_model.dart';
import 'package:my_finance/models/transaction_model.dart';
import 'package:my_finance/screens/manage_transaction.dart';
import 'package:my_finance/screens/transaction_history.dart';
import 'package:my_finance/utils/app_text/app_text.dart';
import 'package:my_finance/utils/app_text/app_text_type.dart';
import 'package:my_finance/utils/color.dart';
import 'package:my_finance/utils/date_picker.dart';
import 'package:my_finance/widgets/app_button.dart';
import 'package:my_finance/widgets/transaction_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TransactionController transactionController = Get.find();
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                SizedBox(height: 20.h),
                _buildMonthYearSelector(),
                SizedBox(height: 15.h),
                _buildExpenseCard(),
                SizedBox(height: 15.h),
                _buildBalanceCard(),
                SizedBox(height: 15.h),
                _buildGraph(),
                SizedBox(height: 15.h),
                _buildHistory(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return GetBuilder<TransactionController>(builder: (controller) {
      return controller.transactions.isEmpty
          ? AppButton(
              text: "Add Transaction",
              onPressed: () => Get.to(() => const ManageTransaction(),
                  transition: Transition.leftToRightWithFade))
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText(
                        text: "History", appTextType: AppTextType.heading2),
                    InkWell(
                        onTap: () => Get.to(() => const TransactionHistory(),
                            transition: Transition.leftToRightWithFade),
                        child: const AppText(
                            text: "See All",
                            appTextType: AppTextType.heading3)),
                  ],
                ),
                SizedBox(height: 15.h),
                GetBuilder<TransactionController>(builder: (controller) {
                  return ListView.separated(
                    itemCount: controller.allSelectedTransactions.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: 10.h),
                    itemBuilder: (BuildContext context, int index) {
                      final transaction =
                          controller.allSelectedTransactions[index];
                      return FadeInUp(
                          duration: const Duration(milliseconds: 200),
                          delay: Duration(milliseconds: index * 20),
                          child: TransactionCard(transaction: transaction));
                    },
                  );
                })
              ],
            );
    });
  }

  Widget _buildMonthYearSelector() {
    return GestureDetector(
      onTap: () async {
        DateTime selectedDate =
            await pickMonthYear(context) ?? transactionController.selectedDate;
        transactionController.updateSelectedDate(selectedDate);
        transactionController.updateSelectedTransactions();
      },
      child: Container(
        width: 140.w,
        padding: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.primary,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month,
            ),
            SizedBox(
              width: 5.w,
            ),
            GetBuilder<TransactionController>(builder: (controller) {
              return AppText(
                text: DateFormat('MMM yyyy').format(controller.selectedDate),
                appTextType: AppTextType.heading3Primary,
              );
            }),
            SizedBox(
              width: 10.w,
            ),
            const Icon(
              Icons.arrow_drop_down,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGraph() {
    return GetBuilder<CategoryController>(builder: (cont) {
      return GetBuilder<TransactionController>(builder: (controller) {
        Map<Category, double> incomeMap = {};
        Map<Category, double> expenseMap = {};

        for (var category in cont.categories) {
          incomeMap[category] = 0;
          expenseMap[category] = 0;
        }

        for (var transaction in controller.selectedTransactions) {
          if (transaction.type == TransactionType.income) {
            incomeMap[transaction.category] =
                (incomeMap[transaction.category] ?? 0) + transaction.amount;
          } else {
            expenseMap[transaction.category] =
                (expenseMap[transaction.category] ?? 0) + transaction.amount;
          }
        }

        List<Category> sortedCategories = incomeMap.keys.length <= 1
            ? incomeMap.keys.toList()
            : incomeMap.keys.toList()
          ..sort((a, b) => (incomeMap[b] ?? 0.0 + expenseMap[b]!)
              .compareTo(incomeMap[a]! + expenseMap[a]!));
        return sortedCategories.isEmpty
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 250,
                child: BarChart(
                  BarChartData(
                    backgroundColor: AppColor.background,
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < sortedCategories.length) {
                              return AppText(
                                text: sortedCategories[value.toInt()]
                                    .name
                                    .substring(0, 3),
                                appTextType: AppTextType.heading3,
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    barGroups: sortedCategories
                        .asMap()
                        .entries
                        .map(
                          (entry) => BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: incomeMap[entry.value]!,
                                color: AppColor.green,
                                width: 20,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              BarChartRodData(
                                toY: expenseMap[entry.value]!,
                                color: AppColor.red,
                                width: 20,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
      });
    });
  }

  Widget _buildBalanceCard() {
    return GetBuilder<TransactionController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: "Available Balance",
            appTextType: AppTextType.heading3,
          ),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            tween: Tween<double>(begin: 0, end: controller.balance.abs()),
            builder: (context, value, child) {
              return AppText(
                text: "\$${value.toStringAsFixed(2)}",
                appTextType: controller.balance < 0
                    ? AppTextType.headingLoss
                    : AppTextType.headingProfit,
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildExpenseCard() {
    return GetBuilder<TransactionController>(builder: (controller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                text: "Income",
                appTextType: AppTextType.heading3,
              ),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0, end: controller.income),
                builder: (context, value, child) {
                  return AppText(
                    text: "\$${value.toStringAsFixed(2)}",
                    appTextType: AppTextType.titleProfit,
                  );
                },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                text: "Expense",
                appTextType: AppTextType.heading3,
              ),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0, end: controller.expense),
                builder: (context, value, child) {
                  return AppText(
                    text: "\$${value.toStringAsFixed(2)}",
                    appTextType: AppTextType.titleLoss,
                  );
                },
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColor.primary,
              radius: 25.r,
            ),
            SizedBox(
              width: 10.w,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "Hello, User!",
                  appTextType: AppTextType.heading2,
                ),
                AppText(
                  text: "Welcome back",
                  appTextType: AppTextType.heading3,
                )
              ],
            )
          ],
        ),
        InkWell(
          onTap: () => Get.to(() => const ManageTransaction()),
          child: CircleAvatar(
            backgroundColor: AppColor.primary,
            radius: 25.r,
            child: const Icon(
              Icons.add,
              color: AppColor.background,
            ),
          ),
        ),
      ],
    );
  }
}
