import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/shared/component/lang_selector_small.dart';
import 'package:flutter_preintern_app/shared/data/app_theme.dart';

class StartPageScaffold extends StatelessWidget {
  final List<Widget>? children;
  const StartPageScaffold({this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.5,
          colors: [
            Color.alphaBlend(Colors.white.withAlpha(210), AppTheme.primary),
            AppTheme.warmBackground,
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          actionsPadding: const EdgeInsets.only(right: 30),
          actions: [LangSelectorSmall(lang: .th)],
          foregroundColor: AppTheme.primary,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox.square(
                    dimension: 125,
                    child: Image.asset(
                      'asset/img/EmpeoLogo.png',
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (children != null) ...children!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
