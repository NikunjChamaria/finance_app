import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_finance/dependecies/dependencies.dart';
import 'package:my_finance/local_service/local_services.dart';
import 'package:my_finance/screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDBService.init();
  AppDependencies().inject();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 788),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'MyFinance',
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },
      child: const Dashboard(),
    );
  }
}
