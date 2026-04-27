import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/presentation/widgets/forgot_password/forgot_password_otp_form.dart';

class ForgotPasswordOtpScreen extends StatelessWidget {
  final String email;

  const ForgotPasswordOtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: AppBar(
              backgroundColor: Colors.white.withOpacity(0.8),
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                    height: 1, color: Colors.white.withOpacity(0.1)),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: AppColors.primary, size: 24),
                onPressed: () => GoRouter.of(context).go('/forgot-password'),
              ),
              title: const Text(
                'Forgot Password',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  letterSpacing: -0.18,
                ),
              ),
              centerTitle: false,
              actions: const [SizedBox(width: 48)],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryContainer.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -40,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondaryFixedDim.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(child: ForgotPasswordOtpForm(email: email)),
        ],
      ),
    );
  }
}
