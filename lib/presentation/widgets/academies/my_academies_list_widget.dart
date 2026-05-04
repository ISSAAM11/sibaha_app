import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/presentation/blocs/my_academy_bloc/my_academy_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/widgets/academies/academy_card.dart';

class MyAcademiesListWidget extends StatefulWidget {
  const MyAcademiesListWidget({super.key});

  @override
  State<MyAcademiesListWidget> createState() => _MyAcademiesListWidgetState();
}

class _MyAcademiesListWidgetState extends State<MyAcademiesListWidget> {
  bool _fetchTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchTriggered) {
      final tokenState = context.read<TokenBloc>().state;
      if (tokenState is TokenRetrieved) {
        context.read<MyAcademyBloc>().add(FetchMyAcademies(tokenState.token));
        _fetchTriggered = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyAcademyBloc, MyAcademyState>(
      listenWhen: (_, s) => s is MyAcademyTokenExpired,
      listener: (context, _) => context.read<TokenBloc>().add(TokenRefresh()),
      child: const _MyAcademyList(),
    );
  }
}

class _MyAcademyList extends StatelessWidget {
  const _MyAcademyList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyAcademyBloc, MyAcademyState>(
      buildWhen: (_, s) =>
          s is MyAcademyInitial ||
          s is MyAcademyLoading ||
          s is MyAcademyLoaded ||
          s is MyAcademyFailed ||
          s is MyAcademyTokenExpired,
      builder: (context, state) {
        if (state is MyAcademyInitial ||
            state is MyAcademyLoading ||
            state is MyAcademyTokenExpired) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (state is MyAcademyFailed) {
          return Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.outline),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is MyAcademyLoaded) {
          if (state.academies.isEmpty) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.home_work_outlined,
                        size: 64, color: AppColors.outlineVariant),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      "You haven't created any academy yet",
                      style: AppTextStyles.subtitle
                          .copyWith(color: AppColors.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Tap the + button to create your first academy',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.outline),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            itemCount: state.academies.length,
            itemBuilder: (context, index) {
              final academy = state.academies[index];
              return AcademyCard(
                index: index,
                academy: academy,
                onTap: () => context.push(
                  '/MyAcademies/${academy.id}/dashboard',
                  extra: academy,
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
