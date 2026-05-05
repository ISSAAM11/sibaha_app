import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/presentation/blocs/subscription_bloc/subscription_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';

class SubscriptionConfirmationScreen extends StatelessWidget {
  final Academy academy;

  const SubscriptionConfirmationScreen({super.key, required this.academy});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Subscription confirmed!'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.mdRadius),
            ),
          );
          context.pop();
        } else if (state is SubscriptionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.mdRadius),
            ),
          );
        } else if (state is SubscriptionTokenExpired) {
          context.read<TokenBloc>().add(TokenRefresh());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
            onPressed: () => context.pop(),
          ),
          title: const Text('Confirm Subscription', style: AppTextStyles.fieldLabel),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppBorderRadius.lgRadius,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.blueGrey[200],
                  child: academy.image != null && academy.image!.isNotEmpty
                      ? Image.network(academy.image!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.pool, size: 48, color: Colors.white54)))
                      : const Center(
                          child: Icon(Icons.pool, size: 48, color: Colors.white54)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(academy.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
              if (academy.city.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(academy.city, style: AppTextStyles.subtitle),
              ],
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: AppBorderRadius.mdRadius,
                ),
                child: Column(
                  children: [
                    _SummaryRow(label: 'Academy', value: academy.name),
                    const SizedBox(height: AppSpacing.md),
                    _SummaryRow(
                      label: 'Monthly price',
                      value: academy.monthlyPrice != null
                          ? '${academy.monthlyPrice!.toStringAsFixed(2)} TND'
                          : 'Contact for pricing',
                      valueColor: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _SummaryRow(label: 'Payment', value: 'On-site (no charge now)'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              BlocBuilder<SubscriptionBloc, SubscriptionState>(
                builder: (context, state) {
                  final isLoading = state is SubscriptionLoading;
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _onConfirm(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        disabledBackgroundColor: AppColors.outlineVariant,
                        shape: const RoundedRectangleBorder(
                            borderRadius: AppBorderRadius.pillRadius),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Confirm & Subscribe',
                              style: AppTextStyles.buttonLabel),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Text(
                  'No payment is charged now. You will pay at the academy.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onConfirm(BuildContext context) {
    final tokenState = context.read<TokenBloc>().state;
    if (tokenState is! TokenRetrieved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to subscribe.')),
      );
      return;
    }
    context
        .read<SubscriptionBloc>()
        .add(SubscribeToAcademyEvent(tokenState.token, academy.id));
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
