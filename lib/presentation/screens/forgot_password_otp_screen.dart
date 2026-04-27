import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/widgets/forgot_password/forgot_password_otp_form.dart';

class ForgotPasswordOtpScreen extends StatelessWidget {
  final String email;

  const ForgotPasswordOtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/forgot-password')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ForgotPasswordOtpForm(email: email),
    );
  }
}
