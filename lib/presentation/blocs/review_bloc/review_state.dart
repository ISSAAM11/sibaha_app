part of 'review_bloc.dart';

@immutable
sealed class ReviewState {}

final class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<Review> reviews;

  ReviewLoaded(this.reviews);
}

class ReviewSubmitting extends ReviewState {
  final List<Review> reviews;

  ReviewSubmitting(this.reviews);
}

class ReviewSubmitted extends ReviewState {
  final List<Review> reviews;

  ReviewSubmitted(this.reviews);
}

class ReviewFailed extends ReviewState {
  final String message;

  ReviewFailed(this.message);
}

class ReviewTokenExpired extends ReviewState {}
