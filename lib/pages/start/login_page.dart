import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/shared/component/pages/start/start_page_scaffold.dart';
import 'package:flutter_preintern_app/shared/component/pages/start/start_primary_button.dart';
import 'package:flutter_preintern_app/shared/component/pages/start/start_text_field.dart';
import 'package:flutter_preintern_app/shared/data/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password.')),
      );
      return;
    }
    // TODO: Handle sign-in logic
    debugPrint('Sign in: $email');
  }

  void _onForgotPassword() {
    // TODO: Navigate to forgot-password flow
    debugPrint('Forgot password tapped');
  }

  void _onSignInWithoutEmail() {
    // TODO: Navigate to sign-in-without-email flow
    debugPrint('Sign in without email tapped');
  }

  void _onSocialSignIn(String provider) {
    // TODO: Handle OAuth for [provider]
    debugPrint('Social sign-in: $provider');
  }

  @override
  Widget build(BuildContext context) {
    return StartPageScaffold(
      additionalAction: _HelpButton(),
      footer: const _FooterText(),
      children: [
        StartTextField(
          controller: _emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 14),

        StartTextField(
          controller: _passwordController,
          hintText: 'Password',
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppTheme.hint,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _onForgotPassword,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
            ),
            child: const Text('Forgot password?'),
          ),
        ),

        const SizedBox(height: 6),

        StartPrimaryButton(label: 'Sign in', onPressed: _onSignIn),

        const SizedBox(height: 28),

        const _OrDivider(),

        const SizedBox(height: 18),

        _SocialSignInRow(onTap: _onSocialSignIn),

        const SizedBox(height: 5),

        TextButton(
          onPressed: _onSignInWithoutEmail,
          child: const Text('Sign in without email'),
        ),
      ],
    );
  }
}

class _HelpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const double size = 25;
    return GestureDetector(
      onTap: () {
        // TODO: Show help / support
        debugPrint('Help tapped');
      },
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppTheme.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.question_mark_rounded,
          color: Colors.white,
          size: size - 5,
          fontWeight: .w900,
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        const Expanded(child: Divider(color: AppTheme.outline)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              color: AppTheme.hint,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppTheme.outline)),
      ],
    );
  }
}

class _SocialSignInRow extends StatelessWidget {
  final void Function(String provider) onTap;
  const _SocialSignInRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    const double size = 20.0;
    const double gap = 14;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          onTap: () => onTap('google'),
          child: Image.asset(
            'asset/img/logo/external/google.png',
            height: size,
          ),
        ),
        const SizedBox(width: gap),
        _SocialButton(
          onTap: () => onTap('microsoft'),
          child: Image.asset(
            'asset/img/logo/external/microsoft.png',
            height: size,
          ),
        ),
        const SizedBox(width: gap),
        _SocialButton(
          onTap: () => onTap('facebook'),
          child: Image.asset(
            'asset/img/logo/external/facebook.png',
            height: size,
          ),
        ),
        const SizedBox(width: gap),
        _SocialButton(
          onTap: () => onTap('line'),
          child: Image.asset('asset/img/logo/external/line.png', height: size),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _SocialButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const double size = 42;
    return Material(
      shape: const CircleBorder(),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        splashColor: AppTheme.primary.withAlpha((0.1 * 255).toInt()),
        highlightColor: AppTheme.primary.withAlpha((0.05 * 255).toInt()),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.outline, width: 1.2),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _FooterText extends StatelessWidget {
  const _FooterText();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontSize: 12, color: AppTheme.hint);

    return Text(
      'By continuing, you agree to our\nTerms & Conditions AND Privacy Policy',
      style: style,
      textAlign: TextAlign.center,
    );
  }
}
