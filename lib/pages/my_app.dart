import 'package:feedbackapp/apps/routes/routers.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        useMaterial3: true,
      ),
      routerConfig: RouterConfigCustom.router,
    );
  }
}
