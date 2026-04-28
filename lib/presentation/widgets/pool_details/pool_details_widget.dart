import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/blocs/pool_details_bloc/pool_details_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';

class PoolDetailsWidget extends StatefulWidget {
  final int id;

  const PoolDetailsWidget({super.key, required this.id});

  @override
  State<PoolDetailsWidget> createState() => _PoolDetailsWidgetState();
}

class _PoolDetailsWidgetState extends State<PoolDetailsWidget> {
  bool _fetchTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchTriggered) {
      final tokenState = context.read<TokenBloc>().state;
      final token = tokenState is TokenRetrieved ? tokenState.token : null;
      context
          .read<PoolDetailsBloc>()
          .add(FetchPoolDetailsEvent(token, widget.id));
      _fetchTriggered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PoolDetailsBloc, PoolDetailsState>(
      listenWhen: (_, s) => s is PoolDetailsTokenExpired,
      listener: (context, _) {
        context.read<TokenBloc>().add(TokenRefresh());
      },
      child: SingleChildScrollView(
        child: BlocBuilder<PoolDetailsBloc, PoolDetailsState>(
          builder: (context, state) {
            if (state is PoolDetailsInitial ||
                state is PoolDetailsLoading ||
                state is PoolDetailsTokenExpired) {
              return const SizedBox(
                height: 400,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is PoolDetailsFailed) {
              return SizedBox(
                height: 400,
                child: Center(child: Text(state.message)),
              );
            }
            if (state is PoolDetailsLoaded) {
              final pool = state.poolDetails;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[200],
                          image: pool.image != null && pool.image!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(pool.image!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: pool.image == null || pool.image!.isEmpty
                            ? const Center(
                                child: Icon(Icons.pool,
                                    size: 64, color: Colors.white54),
                              )
                            : null,
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.arrow_back,
                                  color: Colors.black87, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                pool.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: pool.heated
                                    ? Colors.orange.withOpacity(0.1)
                                    : Colors.blueGrey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: pool.heated
                                      ? Colors.orange
                                      : Colors.blueGrey,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    pool.heated
                                        ? Icons.whatshot
                                        : Icons.ac_unit,
                                    color: pool.heated
                                        ? Colors.orange
                                        : Colors.blueGrey,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    pool.heated ? 'Heated' : 'Unheated',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: pool.heated
                                          ? Colors.orange
                                          : Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () =>
                              context.push('/AcademyDetails/${pool.academyId}'),
                          child: Row(
                            children: [
                              Icon(Icons.school,
                                  size: 16, color: Colors.blue[600]),
                              const SizedBox(width: 6),
                              Text(
                                pool.academyName,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios,
                                  size: 12, color: Colors.blue[600]),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Divider(height: 0, color: Colors.grey[300]),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Icon(Icons.shower,
                                  size: 22, color: Colors.grey[600]),
                              const SizedBox(width: 10),
                              Text(
                                '${pool.showers} shower${pool.showers != 1 ? 's' : ''}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 0, color: Colors.grey[300]),
                        if (pool.dimension.isNotEmpty) ...[
                          const SizedBox(height: 25),
                          const Text(
                            'Dimensions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: pool.dimension
                                .map((d) => Chip(
                                      label: Text(d),
                                      avatar: const Icon(Icons.straighten,
                                          size: 16),
                                      backgroundColor: Colors.blue[50],
                                      side: BorderSide(
                                          color: Colors.blue[200]!),
                                    ))
                                .toList(),
                          ),
                        ],
                        if (pool.speciality.isNotEmpty) ...[
                          const SizedBox(height: 25),
                          const Text(
                            'Specialities',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: pool.speciality
                                .map((s) => Chip(
                                      label: Text(s),
                                      backgroundColor: Colors.grey[100],
                                      side: BorderSide(
                                          color: Colors.grey[300]!),
                                    ))
                                .toList(),
                          ),
                        ],
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Reserve now',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
