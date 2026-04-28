import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/widgets/forgot_password/forgot_password_new_password_form.dart';

class ForgotPasswordNewPasswordScreen extends StatelessWidget {
  final String email;
  final String code;

  const ForgotPasswordNewPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/forgot-password/otp', extra: email)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ForgotPasswordNewPasswordForm(email: email, code: code),
    );
  }
}
