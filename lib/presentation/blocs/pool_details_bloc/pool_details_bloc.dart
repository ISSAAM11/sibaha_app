import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/pool.dart';
import 'package:sibaha_app/data/repositories/pool_repository.dart';

part 'pool_details_event.dart';
part 'pool_details_state.dart';

class PoolDetailsBloc extends Bloc<PoolDetailsEvent, PoolDetailsState> {
  final PoolRepository _poolRepository;

  PoolDetailsBloc({required PoolRepository poolRepository})
      : _poolRepository = poolRepository,
        super(PoolDetailsInitial()) {
    on<FetchPoolDetailsEvent>(_onFetchPoolDetails);
  }

  Future<void> _onFetchPoolDetails(
      FetchPoolDetailsEvent event, Emitter<PoolDetailsState> emit) async {
    emit(PoolDetailsLoading());
    try {
      final pool =
          await _poolRepository.getPoolDetails(event.token, event.id);
      emit(PoolDetailsLoaded(pool));
    } on TokenExpiredException {
      emit(PoolDetailsTokenExpired());
    } catch (e) {
      emit(PoolDetailsFailed(e.toString()));
    }
  }
}
