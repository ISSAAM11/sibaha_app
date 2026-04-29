import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/data/models/coach_filter.dart';
import 'package:sibaha_app/data/models/coach_summary.dart';
import 'package:sibaha_app/data/repositories/coach_repository.dart';

part 'coach_event.dart';
part 'coach_state.dart';

class CoachBloc extends Bloc<CoachEvent, CoachState> {
  final CoachRepository _coachRepository;

  List<CoachSummary> _allCoaches = [];
  String _activeQuery = '';
  CoachFilter _activeFilter = const CoachFilter();

  CoachBloc({required CoachRepository coachRepository})
      : _coachRepository = coachRepository,
        super(CoachInitial()) {
    on<FetchCoaches>(_onFetchCoaches);
    on<SearchCoaches>(_onSearchCoaches);
    on<FilterCoaches>(_onFilterCoaches);
  }

  List<CoachSummary> get allCoaches => _allCoaches;

  void _applyFilters(Emitter<CoachState> emit) {
    var results = _allCoaches;

    if (_activeQuery.isNotEmpty) {
      results = results
          .where((c) => c.username.toLowerCase().contains(_activeQuery))
          .toList();
    }

    if (_activeFilter.languages.isNotEmpty) {
      results = results
          .where((c) =>
              _activeFilter.languages.any((lang) => c.languages.contains(lang)))
          .toList();
    }

    if (_activeFilter.specialities.isNotEmpty) {
      results = results
          .where((c) => _activeFilter.specialities.any((spec) =>
              c.speciality.toLowerCase().contains(spec.toLowerCase())))
          .toList();
    }

    if (_activeFilter.hasExperience) {
      results = results.where((c) => c.yearsOfExperience != null).toList();
    }

    emit(CoachLoaded(results));
  }

  void _onSearchCoaches(SearchCoaches event, Emitter<CoachState> emit) {
    _activeQuery = event.query.toLowerCase();
    _applyFilters(emit);
  }

  void _onFilterCoaches(FilterCoaches event, Emitter<CoachState> emit) {
    _activeFilter = event.filter;
    _applyFilters(emit);
  }

  Future<void> _onFetchCoaches(
      FetchCoaches event, Emitter<CoachState> emit) async {
    emit(CoachLoading());
    try {
      _allCoaches = await _coachRepository.getCoaches();
      _activeQuery = '';
      _activeFilter = const CoachFilter();
      emit(CoachLoaded(_allCoaches));
    } catch (e) {
      emit(CoachFailed(e.toString()));
    }
  }
}
