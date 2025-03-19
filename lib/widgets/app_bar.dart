import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_finance/utils/app_text/app_text.dart';
import 'package:my_finance/utils/app_text/app_text_type.dart';
import 'package:my_finance/utils/color.dart';

class CustomAppBar {
  static AppBar getAppbar(String title, bool leading) {
    return AppBar(
      backgroundColor: AppColor.background,
      automaticallyImplyLeading: false,
      leading: leading
          ? InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColor.text,
                size: 20.sp,
              ),
            )
          : null,
      title: AppText(text: title, appTextType: AppTextType.heading2),
    );
  }
}
