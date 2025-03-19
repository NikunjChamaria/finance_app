import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datepicker;
import 'package:get/get.dart';
import 'package:my_finance/contollers/transaction_controller.dart';
import 'package:my_finance/utils/app_text/app_text.dart';
import 'package:my_finance/utils/app_text/app_text_type.dart';
import 'package:my_finance/utils/color.dart';

class CustomMonthYearPicker extends datepicker.DatePickerModel {
  CustomMonthYearPicker({
    required DateTime minTime,
    required DateTime maxTime,
    required DateTime currentTime,
    required datepicker.LocaleType locale,
  }) : super(
          minTime: minTime,
          maxTime: maxTime,
          currentTime: currentTime,
          locale: locale,
        );

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}

class CustomDaterPicker extends datepicker.DatePickerModel {
  CustomDaterPicker({
    required DateTime minTime,
    required DateTime maxTime,
    required DateTime currentTime,
    required datepicker.LocaleType locale,
  }) : super(
          minTime: minTime,
          maxTime: maxTime,
          currentTime: currentTime,
          locale: locale,
        );

  @override
  List<int> layoutProportions() {
    return [1, 1, 1];
  }
}

TransactionController transactionController = Get.find();

Future<DateTime?> pickMonthYear(BuildContext context) async {
  DateTime? selectedDate;

  await datepicker.DatePicker.showPicker(
    context,
    showTitleActions: true,
    theme: datepicker.DatePickerTheme(
      backgroundColor: AppColor.background,
      itemStyle: getTextStyle(AppTextType.heading2),
      doneStyle: getTextStyle(AppTextType.profit),
      cancelStyle: getTextStyle(AppTextType.loss),
    ),
    pickerModel: CustomMonthYearPicker(
      minTime: DateTime(2020, 1),
      maxTime: DateTime.now(),
      currentTime: transactionController.selectedDate,
      locale: datepicker.LocaleType.en,
    ),
    onConfirm: (date) {
      selectedDate = date;
    },
  );
  return selectedDate;
}

Future<DateTime?> pickDate(BuildContext context, DateTime currentDate) async {
  DateTime? selectedDate;
  await datepicker.DatePicker.showPicker(
    context,
    showTitleActions: true,
    theme: datepicker.DatePickerTheme(
      backgroundColor: AppColor.background,
      itemStyle: getTextStyle(AppTextType.heading2),
      doneStyle: getTextStyle(AppTextType.profit),
      cancelStyle: getTextStyle(AppTextType.loss),
    ),
    pickerModel: CustomDaterPicker(
      minTime: DateTime(2020, 1),
      maxTime: DateTime.now(),
      currentTime: currentDate,
      locale: datepicker.LocaleType.en,
    ),
    onConfirm: (date) {
      selectedDate = date;
    },
  );
  return selectedDate;
}
