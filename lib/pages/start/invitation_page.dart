import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/shared/data/app_theme.dart';

class InvitationCodePage extends StatefulWidget {
  const InvitationCodePage({super.key});

  @override
  State<InvitationCodePage> createState() => _InvitationCodePageState();
}

class _InvitationCodePageState extends State<InvitationCodePage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an Invitation Code.')),
      );
      return;
    }
    // TODO: Handle confirmation logic
    debugPrint('Invitation Code: $code');
  }

  void _onSkip() {
    // TODO: Handle skip logic
    debugPrint('Skipped invitation code entry.');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primary.withAlpha(20),
              AppTheme.primary.withAlpha(0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.35],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              Column(
                children: [
                  // Language selector row
                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 16),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: const SizedBox(
                        width: 10,
                        height: 10,
                        child: Placeholder(),
                      ), //_LanguageSelector(),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),

                          // Logo
                          SizedBox.square(
                            dimension: 125,
                            child: Image.asset('asset/img/EmpeoLogo.png'),
                          ),

                          const SizedBox(height: 10),

                          // Description text — uses bodyMedium from theme
                          Text(
                            'Please fill in the Invitation Code provided by your administrator to access empeo within your company.',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium,
                          ),

                          const SizedBox(height: 36),

                          // Invitation Code input — decoration comes from InputDecorationTheme
                          TextField(
                            controller: _codeController,
                            style: textTheme.bodyLarge,
                            decoration: const InputDecoration(
                              hintText: 'Invitation Code',
                            ),
                          ),

                          const SizedBox(height: 22),

                          // Confirm button — style comes from ElevatedButtonTheme
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _onConfirm,
                              child: const Text('Confirm'),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Skip link — style comes from TextButtonTheme
                          TextButton(
                            onPressed: _onSkip,
                            child: const Text('Skip'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
