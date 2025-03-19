import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_finance/utils/app_text/app_text_type.dart';
import 'package:my_finance/utils/color.dart';

TextStyle getTextStyle(AppTextType appTextType) {
  if (appTextType == AppTextType.heading) {
    return GoogleFonts.roboto(
      color: AppColor.text,
      fontWeight: FontWeight.w400,
      fontSize: 40.r,
    );
  }
  if (appTextType == AppTextType.headingProfit) {
    return GoogleFonts.roboto(
      color: AppColor.green,
      fontWeight: FontWeight.w400,
      fontSize: 40.r,
    );
  }
  if (appTextType == AppTextType.headingLoss) {
    return GoogleFonts.roboto(
      color: AppColor.red,
      fontWeight: FontWeight.w400,
      fontSize: 40.r,
    );
  }
  if (appTextType == AppTextType.heading2) {
    return GoogleFonts.roboto(
      color: AppColor.text,
      fontWeight: FontWeight.w500,
      fontSize: 22.r,
    );
  }
  if (appTextType == AppTextType.heading2Primary) {
    return GoogleFonts.roboto(
      color: AppColor.background,
      fontWeight: FontWeight.w500,
      fontSize: 22.r,
    );
  }
  if (appTextType == AppTextType.heading3) {
    return GoogleFonts.roboto(
      color: AppColor.text.withOpacity(0.6),
      fontWeight: FontWeight.w300,
      fontSize: 14.r,
    );
  }
  if (appTextType == AppTextType.heading3Primary) {
    return GoogleFonts.roboto(
      color: AppColor.background,
      fontWeight: FontWeight.w300,
      fontSize: 14.r,
    );
  }
  if (appTextType == AppTextType.title) {
    return GoogleFonts.roboto(
      color: AppColor.text,
      fontWeight: FontWeight.w400,
      fontSize: 16.r,
    );
  }
  if (appTextType == AppTextType.subtitle) {
    return GoogleFonts.roboto(
      color: AppColor.text.withOpacity(0.5),
      fontWeight: FontWeight.w300,
      fontSize: 14.r,
    );
  }
  if (appTextType == AppTextType.titleProfit) {
    return GoogleFonts.roboto(
      color: AppColor.green,
      fontWeight: FontWeight.w500,
      fontSize: 28.r,
    );
  }
  if (appTextType == AppTextType.titleLoss) {
    return GoogleFonts.roboto(
      color: AppColor.red,
      fontWeight: FontWeight.w500,
      fontSize: 28.r,
    );
  }
  if (appTextType == AppTextType.loss) {
    return GoogleFonts.roboto(
      color: AppColor.red,
      fontWeight: FontWeight.w400,
      fontSize: 14.r,
    );
  }
  if (appTextType == AppTextType.profit) {
    return GoogleFonts.roboto(
      color: AppColor.green,
      fontWeight: FontWeight.w400,
      fontSize: 14.r,
    );
  }
  return const TextStyle();
}

class AppText extends StatelessWidget {
  final String text;
  final AppTextType appTextType;
  const AppText({
    super.key,
    required this.text,
    required this.appTextType,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getTextStyle(appTextType),
    );
  }
}
