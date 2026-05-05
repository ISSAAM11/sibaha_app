import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/academy_client.dart';
import 'package:sibaha_app/data/repositories/subscription_repository.dart';

part 'academy_clients_event.dart';
part 'academy_clients_state.dart';

class AcademyClientsBloc extends Bloc<AcademyClientsEvent, AcademyClientsState> {
  final SubscriptionRepository _subscriptionRepository;

  AcademyClientsBloc({required SubscriptionRepository subscriptionRepository})
      : _subscriptionRepository = subscriptionRepository,
        super(AcademyClientsInitial()) {
    on<FetchAcademyClientsEvent>(_onFetch);
    on<RemoveAcademyClientEvent>(_onRemove);
  }

  Future<void> _onFetch(
      FetchAcademyClientsEvent event, Emitter<AcademyClientsState> emit) async {
    emit(AcademyClientsLoading());
    try {
      final clients = await _subscriptionRepository.getAcademyClients(event.token, event.academyId);
      emit(AcademyClientsLoaded(clients));
    } on TokenExpiredException {
      emit(AcademyClientsTokenExpired());
    } catch (e) {
      emit(AcademyClientsFailed(e.toString()));
    }
  }

  Future<void> _onRemove(
      RemoveAcademyClientEvent event, Emitter<AcademyClientsState> emit) async {
    final current = state;
    if (current is! AcademyClientsLoaded) return;

    emit(AcademyClientsRemoving(current.clients, event.subscriptionId));
    try {
      await _subscriptionRepository.removeClient(event.token, event.academyId, event.subscriptionId);
      final updated = current.clients.where((c) => c.subscriptionId != event.subscriptionId).toList();
      emit(AcademyClientsLoaded(updated));
    } on TokenExpiredException {
      emit(AcademyClientsTokenExpired());
    } catch (e) {
      emit(AcademyClientsLoaded(current.clients));
      emit(AcademyClientsFailed(e.toString()));
    }
  }
}
