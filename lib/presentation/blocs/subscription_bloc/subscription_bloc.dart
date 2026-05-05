import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/repositories/subscription_repository.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository _subscriptionRepository;

  SubscriptionBloc({required SubscriptionRepository subscriptionRepository})
      : _subscriptionRepository = subscriptionRepository,
        super(SubscriptionInitial()) {
    on<SubscribeToAcademyEvent>(_onSubscribe);
  }

  Future<void> _onSubscribe(
      SubscribeToAcademyEvent event, Emitter<SubscriptionState> emit) async {
    emit(SubscriptionLoading());
    try {
      await _subscriptionRepository.subscribe(event.token, event.academyId);
      emit(SubscriptionSuccess());
    } on TokenExpiredException {
      emit(SubscriptionTokenExpired());
    } catch (e) {
      emit(SubscriptionFailed(e.toString()));
    }
  }
}
