import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/pages/main_page/main_page.dart';
import 'package:flutter_preintern_app/pages/main_page/contact_page.dart';
import 'package:flutter_preintern_app/pages/pin_page.dart';
import 'package:flutter_preintern_app/shared/data/app_theme.dart';

void main() {
  runApp(const EmpeoApp());
}

class EmpeoApp extends StatelessWidget {
  const EmpeoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empeo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: PinPage(),
    );
  }
}
