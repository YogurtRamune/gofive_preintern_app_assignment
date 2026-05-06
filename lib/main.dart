import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preintern_app/bloc/language_bloc.dart';
import 'package:flutter_preintern_app/core/app_theme.dart';
import 'package:flutter_preintern_app/pages/main_page/main_page.dart';
import 'package:flutter_preintern_app/pages/pin_page.dart';
import 'package:flutter_preintern_app/pages/start/invitation_page.dart';

void main() {
  runApp(const EmpeoApp());
}

class EmpeoApp extends StatelessWidget {
  const EmpeoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageBloc(.uk))
      ],
      child: MaterialApp(
        title: 'Empeo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        // home: PinPage()
        home: PinPage(),
      ),
    );
  }
}

