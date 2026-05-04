import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/presentation/blocs/review_bloc/review_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/widgets/academy_details/review_list.dart';

class ReviewScreen extends StatefulWidget {
  final int academyId;
  final String academyName;

  const ReviewScreen({
    super.key,
    required this.academyId,
    required this.academyName,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tokenState = context.read<TokenBloc>().state;
    final token = tokenState is TokenRetrieved ? tokenState.token : null;
    context
        .read<ReviewBloc>()
        .add(FetchReviewsEvent(token, widget.academyId));
  }

  @override
  Widget build(BuildContext context) {
    return ReviewList(
      academyId: widget.academyId,
      academyName: widget.academyName,
    );
  }
}
