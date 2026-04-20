import 'package:flutter/material.dart';

/// A full-width, fixed-height [ElevatedButton] used on every start-flow page.
///
/// Extracted from [InvitationCodePage] and [LoginPage] to avoid repeating the
/// same [SizedBox] + [ElevatedButton] boilerplate.
class StartPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const StartPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}
