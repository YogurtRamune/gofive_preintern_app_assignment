import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/shared/component/lang_selector_small.dart';
import 'package:flutter_preintern_app/shared/data/app_theme.dart';

class StartPageScaffold extends StatelessWidget {
  final List<Widget>? children;

  const StartPageScaffold({this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // The decoration goes here to act as the base layer
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.alphaBlend(Colors.white.withAlpha(230), AppTheme.primary),
            AppTheme.warmBackground,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.5],
        ),
      ),
      child: Scaffold(
        // Makes the Scaffold see-through to reveal the Container's gradient
        backgroundColor: Colors.transparent,

        // Allows the body/gradient to flow underneath the AppBar area
        extendBodyBehindAppBar: true,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0, // Prevents color change on scroll
          actionsPadding: EdgeInsets.only(right: 30),
          actions: [
             LangSelectorSmall(lang: .th,)
          ],
        ),

        body: SafeArea(
          // SafeArea ensures content doesn't hit notches/status bars
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Logo
                  SizedBox.square(
                    dimension: 125,
                    child: Image.asset(
                      'asset/img/EmpeoLogo.png',
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Spread the children widgets if they exist
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
