import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_finance/utils/app_text/app_text.dart';
import 'package:my_finance/utils/app_text/app_text_type.dart';
import 'package:my_finance/utils/color.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? buttonColor;
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.h),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? AppColor.primary,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child: AppText(
          text: text,
          appTextType: AppTextType.heading3Primary,
        ),
      ),
    );
  }
}
