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
  String _activeQuery = '';
  bool? _activeHeated;
  List<String> _activeSpecialities = [];

  PoolBloc({required PoolRepository poolRepository})
      : _poolRepository = poolRepository,
        super(PoolInitial()) {
    on<FetchPools>(_onFetchPools);
    on<SearchPools>(_onSearchPools);
    on<FilterPools>(_onFilterPools);
  }

  void _applyFilters(Emitter<PoolState> emit) {
    var result = poolData;
    if (_activeQuery.isNotEmpty) {
      result = result
          .where((p) => p.name.toLowerCase().contains(_activeQuery))
          .toList();
    }
    if (_activeHeated != null) {
      result = result.where((p) => p.heated == _activeHeated).toList();
    }
    if (_activeSpecialities.isNotEmpty) {
      result = result
          .where((p) =>
              _activeSpecialities.every((s) => p.speciality.contains(s)))
          .toList();
    }
    emit(PoolLoaded(result));
  }

  void _onSearchPools(SearchPools event, Emitter<PoolState> emit) {
    _activeQuery = event.query.toLowerCase();
    _applyFilters(emit);
  }

  void _onFilterPools(FilterPools event, Emitter<PoolState> emit) {
    _activeHeated = event.heated;
    _activeSpecialities = event.specialities;
    _applyFilters(emit);
  }

  Future<void> _onFetchPools(FetchPools event, Emitter<PoolState> emit) async {
    emit(PoolLoading());
    try {
      final pools = await _poolRepository.getPools(event.token);
      poolData = pools;
      _activeQuery = '';
      _activeHeated = null;
      _activeSpecialities = [];
      emit(PoolLoaded(poolData));
    } on TokenExpiredException {
      emit(PoolTokenExpired());
    } catch (e) {
      emit(PoolFailed(e.toString()));
    }
  }
}
