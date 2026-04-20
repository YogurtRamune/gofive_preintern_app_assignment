import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/shared/component/pages/start/start_page_scaffold.dart';
import 'package:flutter_preintern_app/shared/component/pages/start/start_primary_button.dart';
import 'package:flutter_preintern_app/shared/component/pages/start/start_text_field.dart';

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

    return StartPageScaffold(
      children: [
        // Description text — uses bodyMedium from theme
        Text(
          'Please fill in the Invitation Code provided by your administrator to access empeo within your company.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium,
        ),

        const SizedBox(height: 23),

        StartTextField(
          controller: _codeController,
          hintText: 'Invitation Code',
        ),
        
        const SizedBox(height: 22),

        // ← refactored: was SizedBox(height:54) + ElevatedButton inline
        StartPrimaryButton(label: 'Confirm', onPressed: _onConfirm),

        const SizedBox(height: 10),

        // Skip link — style comes from TextButtonTheme
        TextButton(onPressed: _onSkip, child: const Text('Skip')),
      ],
    );
  }
}
