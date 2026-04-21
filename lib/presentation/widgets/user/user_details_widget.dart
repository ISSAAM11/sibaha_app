import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/blocs/user_details_bloc/user_details_bloc.dart';

class UserDetailsWidget extends StatelessWidget {
  const UserDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenBloc = BlocProvider.of<TokenBloc>(context);

    return Expanded(
      child: Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
            builder: (context, state) {
              if (state is UserDetailsInitial) {
                context.read<UserDetailsBloc>().add(FetchUserEvent(
                    (tokenBloc.state as TokenRetrieved).token));
                return SizedBox();
              } else if (state is UserDetailsLoading) {
                return CircularProgressIndicator();
              } else if (state is UserDetailsError) {
                return Text(state.message,
                    style: TextStyle(color: Colors.red));
              } else if (state is UserDetailsLoaded) {
                return Column(children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.grey[50],
                    child: Column(children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(children: [
                          _buildDetailRow('Age', '30'),
                          _buildDetailRow('Gender', 'Male'),
                          _buildDetailRow('Nationalities', 'Tunisia, UAE'),
                          _buildDetailRow('Specialities', 'kids'),
                          _buildDetailRow('Languages', 'English, Italian',
                              isLast: true),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Save",
                              style: TextStyle(color: Colors.blue)),
                        ),
                      )
                    ]),
                  ),
                ]);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(label,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600)),
            ),
            Expanded(
              child: Text(value,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            ),
          ],
        ),
        if (!isLast) ...[
          SizedBox(height: 16),
          Divider(color: Colors.grey[200], height: 1),
          SizedBox(height: 16),
        ],
      ],
    );
  }
}
