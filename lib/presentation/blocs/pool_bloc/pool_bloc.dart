import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/pool.dart';
import 'package:sibaha_app/data/repositories/pool_repository.dart';

part 'pool_event.dart';
part 'pool_state.dart';

class PoolBloc extends Bloc<PoolEvent, PoolState> {
  final PoolRepository _poolRepository;
  List<Pool> poolData = [];

  PoolBloc({required PoolRepository poolRepository})
      : _poolRepository = poolRepository,
        super(PoolInitial()) {
    on<FetchPools>(_onFetchPools);
  }

  Future<void> _onFetchPools(FetchPools event, Emitter<PoolState> emit) async {
    emit(PoolLoading());
    try {
      final pools = await _poolRepository.getPools(event.token);
      poolData = pools;
      emit(PoolLoaded(poolData));
    } on TokenExpiredException {
      emit(PoolTokenExpired());
    } catch (e) {
      emit(PoolFailed(e.toString()));
    }
  }
}
