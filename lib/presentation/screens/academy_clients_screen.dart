import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/academy_client.dart';
import 'package:sibaha_app/presentation/blocs/academy_clients_bloc/academy_clients_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';

class AcademyClientsScreen extends StatefulWidget {
  final int academyId;
  final String academyName;

  const AcademyClientsScreen({
    super.key,
    required this.academyId,
    required this.academyName,
  });

  @override
  State<AcademyClientsScreen> createState() => _AcademyClientsScreenState();
}

class _AcademyClientsScreenState extends State<AcademyClientsScreen> {
  bool _fetchTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchTriggered) {
      final tokenState = context.read<TokenBloc>().state;
      if (tokenState is TokenRetrieved) {
        context.read<AcademyClientsBloc>().add(
              FetchAcademyClientsEvent(tokenState.token, widget.academyId),
            );
        _fetchTriggered = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Clients',
          style: AppTextStyles.subtitle.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.outlineVariant.withOpacity(0.4),
          ),
        ),
      ),
      body: BlocConsumer<AcademyClientsBloc, AcademyClientsState>(
        listenWhen: (_, s) => s is AcademyClientsFailed || s is AcademyClientsTokenExpired,
        listener: (context, state) {
          if (state is AcademyClientsFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.mdRadius),
            ));
          } else if (state is AcademyClientsTokenExpired) {
            context.read<TokenBloc>().add(TokenRefresh());
          }
        },
        builder: (context, state) {
          if (state is AcademyClientsInitial || state is AcademyClientsLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is AcademyClientsFailed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.errorColor, size: 48),
                    const SizedBox(height: AppSpacing.lg),
                    Text(state.message,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subtitle
                            .copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
            );
          }

          final clients = switch (state) {
            AcademyClientsLoaded s => s.clients,
            AcademyClientsRemoving s => s.clients,
            _ => <AcademyClient>[],
          };

          if (clients.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_outline,
                        size: 56, color: AppColors.outlineVariant),
                    const SizedBox(height: AppSpacing.lg),
                    Text('No clients yet',
                        style: AppTextStyles.subtitle
                            .copyWith(color: AppColors.onSurfaceVariant)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Users who subscribe to your academy will appear here',
                      style: AppTextStyles.caption.copyWith(color: AppColors.outline),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            itemCount: clients.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final client = clients[index];
              final isRemoving = state is AcademyClientsRemoving &&
                  state.removingSubscriptionId == client.subscriptionId;
              return _ClientCard(
                client: client,
                isRemoving: isRemoving,
                onRemove: () => _confirmRemove(context, client),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmRemove(BuildContext context, AcademyClient client) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.lgRadius),
        title: const Text('Remove client?'),
        content: Text(
          'This will remove ${client.username} from your academy. They will need to subscribe again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              final tokenState = context.read<TokenBloc>().state;
              if (tokenState is TokenRetrieved) {
                context.read<AcademyClientsBloc>().add(
                      RemoveAcademyClientEvent(
                          tokenState.token, widget.academyId, client.subscriptionId),
                    );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.errorColor),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final AcademyClient client;
  final bool isRemoving;
  final VoidCallback onRemove;

  const _ClientCard({
    required this.client,
    required this.isRemoving,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: AppBorderRadius.lgRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.lgRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            _Avatar(username: client.username, pictureUrl: client.userPicture),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.username,
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(client.email, style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      if (client.priceAtSubscription != null)
                        _Chip(
                          label:
                              '${client.priceAtSubscription!.toStringAsFixed(2)} TND/mo',
                          color: AppColors.primary,
                        ),
                      if (client.priceAtSubscription != null)
                        const SizedBox(width: AppSpacing.xs),
                      _Chip(
                        label: _formatDate(client.subscribedAt),
                        color: AppColors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            isRemoving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.errorColor),
                  )
                : IconButton(
                    icon: const Icon(Icons.person_remove_outlined,
                        color: AppColors.errorColor, size: 22),
                    tooltip: 'Remove client',
                    onPressed: onRemove,
                  ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _Avatar extends StatelessWidget {
  final String username;
  final String? pictureUrl;

  const _Avatar({required this.username, this.pictureUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: AppColors.primaryContainer.withOpacity(0.15),
      backgroundImage:
          pictureUrl != null && pictureUrl!.isNotEmpty ? NetworkImage(pictureUrl!) : null,
      child: pictureUrl == null || pictureUrl!.isEmpty
          ? Text(
              username.isNotEmpty ? username[0].toUpperCase() : '?',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary),
            )
          : null,
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: AppBorderRadius.smRadius,
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
