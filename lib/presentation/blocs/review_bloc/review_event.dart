part of 'review_bloc.dart';

@immutable
sealed class ReviewEvent {}

class FetchReviewsEvent extends ReviewEvent {
  final String? token;
  final int academyId;

  FetchReviewsEvent(this.token, this.academyId);
}

class SubmitReviewEvent extends ReviewEvent {
  final String token;
  final int academyId;
  final int rating;
  final String comment;

  SubmitReviewEvent({
    required this.token,
    required this.academyId,
    required this.rating,
    required this.comment,
  });
}
