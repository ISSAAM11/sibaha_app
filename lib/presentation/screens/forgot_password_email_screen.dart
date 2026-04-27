import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/widgets/forgot_password/forgot_password_email_form.dart';

class ForgotPasswordEmailScreen extends StatelessWidget {
  const ForgotPasswordEmailScreen({super.key});

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
              shadowColor: Colors.black.withOpacity(0.08),
              surfaceTintColor: Colors.transparent,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                    height: 1, color: Colors.white.withOpacity(0.1)),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Color(0xFF0058BC), size: 24),
                onPressed: () => GoRouter.of(context).go('/login'),
              ),
              title: const Text(
                'Forgot Password',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0058BC),
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
          // Top-right blob
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
                    const Color(0xFF0070EB).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Bottom-left blob
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
                    const Color(0xFF00DBE7).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          const SafeArea(child: ForgotPasswordEmailForm()),
        ],
      ),
    );
  }
}
