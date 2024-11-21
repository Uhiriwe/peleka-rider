import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:peleka_rides/pages/rider_dashboard.dart';
import 'package:peleka_rides/pages/view_map_route.dart';

import 'authentication/forget_password.dart';
import 'authentication/login.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return const MaterialApp(
          home: Scaffold(
            body: ViewMapRoute(),
          ),
        );
      },
    );
  }
}
