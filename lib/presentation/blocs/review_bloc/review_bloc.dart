import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/review.dart';
import 'package:sibaha_app/data/repositories/academy_repository.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AcademyRepository _academyRepository;

  ReviewBloc({required AcademyRepository academyRepository})
      : _academyRepository = academyRepository,
        super(ReviewInitial()) {
    on<FetchReviewsEvent>(_onFetchReviews);
    on<SubmitReviewEvent>(_onSubmitReview);
  }

  Future<void> _onFetchReviews(
      FetchReviewsEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      final reviews =
          await _academyRepository.getReviews(event.token, event.academyId);
      emit(ReviewLoaded(reviews));
    } on TokenExpiredException {
      emit(ReviewTokenExpired());
    } catch (e) {
      emit(ReviewFailed(e.toString()));
    }
  }

  Future<void> _onSubmitReview(
      SubmitReviewEvent event, Emitter<ReviewState> emit) async {
    final current = state;
    final existing =
        current is ReviewLoaded ? current.reviews : <Review>[];
    emit(ReviewSubmitting(existing));
    try {
      await _academyRepository.createReview(
          event.token, event.academyId, event.rating, event.comment);
      final updated =
          await _academyRepository.getReviews(event.token, event.academyId);
      emit(ReviewSubmitted(updated));
    } on TokenExpiredException {
      emit(ReviewTokenExpired());
    } catch (e) {
      emit(ReviewFailed(e.toString()));
    }
  }
}
