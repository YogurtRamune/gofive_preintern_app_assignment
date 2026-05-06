import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/component/pages/start/start_page_scaffold.dart';
import 'package:flutter_preintern_app/component/pages/start/start_primary_button.dart';
import 'package:flutter_preintern_app/component/pages/start/start_text_field.dart';
import 'package:flutter_preintern_app/pages/start/login_page.dart';

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

  void _onSkip(BuildContext context) {
    // TODO: Handle skip logic
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage(),));
    debugPrint('Skipped invitation code entry.');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return StartPageScaffold(
      children: [
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
        StartPrimaryButton(label: 'Confirm', onPressed: _onConfirm),
        const SizedBox(height: 10),
        TextButton(onPressed: () => _onSkip(context), child: const Text('Skip')),
      ],
    );
  }
}
