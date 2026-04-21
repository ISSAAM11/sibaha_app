import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/blocs/academy_details_bloc/academy_details_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/widgets/academy_details/day_schedule.dart';

class AcademyDetailsWidget extends StatelessWidget {
  final int id;

  const AcademyDetailsWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final academyDetailsBloc = BlocProvider.of<AcademyDetailsBloc>(context);
    final tokenBloc = BlocProvider.of<TokenBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: BlocBuilder<AcademyDetailsBloc, AcademyDetailsState>(
          builder: (context, state) {
            if (state is AcademyDetailsInitial) {
              if (tokenBloc.state is TokenRetrieved) {
                academyDetailsBloc.add(FetchAcademyDetailsEvent(
                  (tokenBloc.state as TokenRetrieved).token,
                  id,
                ));
              }
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AcademyDetailsLoading) {
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
                          image: DecorationImage(
                            image: NetworkImage(state.academyDetails.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.arrow_back,
                                  color: Colors.black87, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
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
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  SizedBox(height: 4),
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
                            Icon(Icons.favorite, color: Colors.red, size: 28),
                          ],
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
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
                                SizedBox(width: 8),
                                Text('4.1 (42)',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500)),
                                Spacer(),
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              side: BorderSide.none,
                            ),
                            onPressed: () => context.push("/AcademyCoachs"),
                            child: Row(
                              children: [
                                Text('Coach list (8)',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87)),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios,
                                    size: 16, color: Colors.grey[600]),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Text('Opening time',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                        SizedBox(height: 15),
                        Column(
                          children: state.academyDetails.weekdayAvailability !=
                                  null
                              ? state.academyDetails.weekdayAvailability!
                                  .map((slot) => DaySchedule(
                                        day: slot.weekday,
                                        time:
                                            '${slot.startTime} - ${slot.endTime}',
                                      ))
                                  .toList()
                              : [],
                        ),
                        SizedBox(height: 25),
                        Text('Specialities',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                        SizedBox(height: 15),
                        Column(
                          children: state.academyDetails.specialities
                              .map((s) => ListTile(title: Text(s)))
                              .toList(),
                        ),
                        SizedBox(height: 40),
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
                            child: Text('Reserve now',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
