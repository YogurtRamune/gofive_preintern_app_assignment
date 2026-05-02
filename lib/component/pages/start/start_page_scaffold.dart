import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/component/pages/start/lang_selector_small.dart';
import 'package:flutter_preintern_app/core/app_theme.dart';

class StartPageScaffold extends StatelessWidget {
  final List<Widget>? children;
  final Widget? additionalAction;
  final Widget? footer;

  const StartPageScaffold({
    this.children,
    this.additionalAction,
    this.footer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget>? additionalActionProcessed = (additionalAction == null)
        ? null
        : [additionalAction!, const SizedBox(width: 12)];

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.5,
          colors: [
            Color.alphaBlend(Colors.white.withAlpha(230), AppTheme.primary),
            AppTheme.warmBackground,
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: 145,
            left: -10,
            child: Image.asset('asset/img/deco/cloud.png', height: 60),
          ),
          Positioned(
            top: 100,
            right: -10,
            child: Image.asset('asset/img/deco/cloud.png', height: 60),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              actionsPadding: const EdgeInsets.only(right: 30),
              actions: [
                ...?additionalActionProcessed,
                const LangSelectorSmall(lang: .th),
              ],
            ),
            body: SizedBox.expand(
              child: Stack(
                children: [
                  // ── Scrollable content (Inside SafeArea) ─────────────────────
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: SafeArea(
                      bottom:
                          false, // Allows content to flow down to the footer
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox.square(
                                dimension: 100,
                                child: Image.asset(
                                  'asset/img/logo/EmpeoLogo.png',
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                      ),
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

                  // ── Footer (Outside SafeArea) ────────────────────────────────
                  if (footer != null)
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: Padding(
                        // Custom padding: bottom: 24 will now start from the
                        // absolute edge of the screen.
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        child: footer!,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
