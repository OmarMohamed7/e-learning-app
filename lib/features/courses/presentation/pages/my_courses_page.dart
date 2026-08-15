import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyCoursesPage extends StatelessWidget {
  const MyCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('myCoursesTitle'.tr())));
  }
}
