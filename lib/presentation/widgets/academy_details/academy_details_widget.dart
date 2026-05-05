import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/data/models/course.dart';
import 'package:sibaha_app/presentation/blocs/academy_details_bloc/academy_details_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/widgets/academy_details/academy_map_section.dart';
import 'package:sibaha_app/presentation/widgets/academy_details/day_schedule.dart';

class AcademyDetailsWidget extends StatefulWidget {
  final int id;

  const AcademyDetailsWidget({super.key, required this.id});

  @override
  State<AcademyDetailsWidget> createState() => _AcademyDetailsWidgetState();
}

class _AcademyDetailsWidgetState extends State<AcademyDetailsWidget> {
  bool _fetchTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchTriggered) {
      final tokenState = context.read<TokenBloc>().state;
      final token = tokenState is TokenRetrieved ? tokenState.token : null;
      context
          .read<AcademyDetailsBloc>()
          .add(FetchAcademyDetailsEvent(token, widget.id));
      _fetchTriggered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AcademyDetailsBloc, AcademyDetailsState>(
      listenWhen: (_, s) => s is AcademyDetailsTokenExpired,
      listener: (context, _) {
        context.read<TokenBloc>().add(TokenRefresh());
      },
      child: SingleChildScrollView(
        child: BlocBuilder<AcademyDetailsBloc, AcademyDetailsState>(
          builder: (context, state) {
            if (state is AcademyDetailsInitial ||
                state is AcademyDetailsLoading ||
                state is AcademyDetailsTokenExpired) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AcademyDetailsFailed) {
              return Center(child: Text(state.message));
            }
            if (state is AcademyDetailsLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[200],
                          image: state.academyDetails.image != null &&
                                  state.academyDetails.image!.isNotEmpty
                              ? DecorationImage(
                                  image:
                                      NetworkImage(state.academyDetails.image!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: state.academyDetails.image == null ||
                                state.academyDetails.image!.isEmpty
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
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.academyDetails.name,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(state.academyDetails.city,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  Text(state.academyDetails.address,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                ],
                              ),
                            ),
                            const Icon(Icons.favorite,
                                color: Colors.red, size: 28),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              side: BorderSide.none,
                            ),
                            onPressed: () async {
                              await context.push('/ReviewList', extra: {
                                'academyId': state.academyDetails.id,
                                'academyName': state.academyDetails.name,
                              });
                              if (!context.mounted) return;
                              final tokenState =
                                  context.read<TokenBloc>().state;
                              final token = tokenState is TokenRetrieved
                                  ? tokenState.token
                                  : null;
                              context.read<AcademyDetailsBloc>().add(
                                  FetchAcademyDetailsEvent(token, widget.id));
                            },
                            child: Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    final avg =
                                        state.academyDetails.averageRating;
                                    final filled =
                                        avg != null && index < avg.round();
                                    return Icon(
                                      filled ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                      size: 20,
                                    );
                                  }),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  state.academyDetails.averageRating != null
                                      ? '${state.academyDetails.averageRating!.toStringAsFixed(1)} (${state.academyDetails.reviewCount})'
                                      : '--',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                Icon(Icons.arrow_forward_ios,
                                    size: 16, color: Colors.grey[600]),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 0, color: Colors.grey[300]),
                        SizedBox(
                          height: 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              side: BorderSide.none,
                            ),
                            onPressed: () => context.push("/AcademyCoachs"),
                            child: Row(
                              children: [
                                const Text('Coach list (8)',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87)),
                                const Spacer(),
                                Icon(Icons.arrow_forward_ios,
                                    size: 16, color: Colors.grey[600]),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Text('Opening time',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                        const SizedBox(height: 15),
                        Column(
                          children:
                              state.academyDetails.weekdayAvailability != null
                                  ? state.academyDetails.weekdayAvailability!
                                      .map((slot) => DaySchedule(
                                            day: slot.weekday,
                                            time: slot.isClosed ||
                                                    slot.startTime == null ||
                                                    slot.endTime == null
                                                ? 'Closed'
                                                : '${slot.startTime} - ${slot.endTime}',
                                          ))
                                      .toList()
                                  : [],
                        ),
                        const SizedBox(height: 25),
                        const Text('Specialities',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                        const SizedBox(height: 15),
                        Column(
                          children: state.academyDetails.specialities
                              .map((s) => ListTile(title: Text(s)))
                              .toList(),
                        ),
                        const SizedBox(height: 25),
                        if (state.academyDetails.latitude != null &&
                            state.academyDetails.longitude != null) ...[
                          AcademyMapSection(
                            latitude: state.academyDetails.latitude!,
                            longitude: state.academyDetails.longitude!,
                            academyName: state.academyDetails.name,
                          ),
                          const SizedBox(height: 25),
                        ],
                        const Text('Pools',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                        const SizedBox(height: 15),
                        if (state.academyDetails.poolList.isEmpty)
                          Text('Aucune piscine disponible',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[500]))
                        else
                          SizedBox(
                            height: 150,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.academyDetails.poolList.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final pool =
                                    state.academyDetails.poolList[index];
                                return GestureDetector(
                                  onTap: () =>
                                      context.push('/poolList/${pool.id}'),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 150,
                                          color: Colors.blueGrey[200],
                                          child: pool.image != null &&
                                                  pool.image!.isNotEmpty
                                              ? Image.network(
                                                  pool.image!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      const Center(
                                                          child: Icon(
                                                              Icons.pool,
                                                              size: 36,
                                                              color: Colors
                                                                  .white54)),
                                                )
                                              : const Center(
                                                  child: Icon(Icons.pool,
                                                      size: 36,
                                                      color: Colors.white54)),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 6),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.7),
                                                ],
                                              ),
                                            ),
                                            child: Text(
                                              pool.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 25),
                        const Text('Courses',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                        const SizedBox(height: 15),
                        if (state.academyDetails.courses.isEmpty)
                          Text('No courses available',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[500]))
                        else
                          Column(
                            children: state.academyDetails.courses
                                .map((c) => _CourseEnrollCard(course: c))
                                .toList(),
                          ),
                        // const SizedBox(height: 40),
                        // BlocBuilder<TokenBloc, TokenState>(
                        //   builder: (context, tokenState) {
                        //     if (tokenState is! TokenRetrieved ||
                        //         tokenState.userType != 'user') {
                        //       return const SizedBox();
                        //     }
                        //     return SizedBox(
                        //       width: double.infinity,
                        //       height: 50,
                        //       child: ElevatedButton(
                        //         onPressed: () => context.push(
                        //           '/subscription-confirmation',
                        //           extra: state.academyDetails,
                        //         ),
                        //         style: ElevatedButton.styleFrom(
                        //           backgroundColor: Colors.blue,
                        //           foregroundColor: Colors.white,
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(25),
                        //           ),
                        //           elevation: 2,
                        //         ),
                        //         child: const Text('Reserve now',
                        //             style: TextStyle(
                        //                 fontSize: 18,
                        //                 fontWeight: FontWeight.w600)),
                        //       ),
                        //     );
                        //   },
                        // ),
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

class _CourseEnrollCard extends StatelessWidget {
  final Course course;

  const _CourseEnrollCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadius.lgRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  course.name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
              ),
              _LevelChip(level: course.level),
            ],
          ),
          if (course.description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              course.description,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.payments_outlined, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                course.pricePerMonth != null
                    ? '${course.pricePerMonth!.toStringAsFixed(2)} TND/mo'
                    : '--',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
          if (course.timings.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: course.timings.map((t) {
                final day =
                    t.weekday[0].toUpperCase() + t.weekday.substring(1, 3);
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: AppBorderRadius.smRadius,
                  ),
                  child: Text(
                    '$day ${t.startTime}–${t.endTime}',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          BlocBuilder<TokenBloc, TokenState>(
            builder: (context, tokenState) {
              if (tokenState is! TokenRetrieved ||
                  tokenState.userType != 'user') {
                return const SizedBox();
              }
              return Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () =>
                        context.push('/course-enrollment', extra: course),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.mdRadius),
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    ),
                    child: const Text('Enroll',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  final String level;
  const _LevelChip({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = switch (level) {
      'advanced' => const Color(0xFFBA1A1A),
      'intermediate' => const Color(0xFF0070EB),
      _ => const Color(0xFF007A5E),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppBorderRadius.smRadius,
      ),
      child: Text(
        level[0].toUpperCase() + level.substring(1),
        style:
            TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
