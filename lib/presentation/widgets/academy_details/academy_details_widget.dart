import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/blocs/academy_details_bloc/academy_details_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
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
                            onPressed: () => context.push("/ReviewList"),
                            child: Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < 4
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 20,
                                    );
                                  }),
                                ),
                                const SizedBox(width: 8),
                                const Text('4.1 (42)',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500)),
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
                            child: const Text('Reserve now',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
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
