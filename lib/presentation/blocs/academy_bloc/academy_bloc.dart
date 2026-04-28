import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/data/repositories/academy_repository.dart';

part 'academy_event.dart';
part 'academy_state.dart';

class AcademyBloc extends Bloc<AcademyEvent, AcademyState> {
  final AcademyRepository _academyRepository;

  List<Academy> academyData = [];
  String _activeQuery = '';
  String? _activeCity;
  List<String> _activeSpecialities = [];

  AcademyBloc({required AcademyRepository academyRepository})
      : _academyRepository = academyRepository,
        super(AcademyInitial()) {
    on<FetchAcademies>(_onFetchAcademies);
    on<SearchAcademies>(_onSearchAcademies);
    on<FilterAcademies>(_onFilterAcademies);
  }

  void _applyFilters(Emitter<AcademyState> emit) {
    var result = academyData;
    if (_activeQuery.isNotEmpty) {
      result = result
          .where((a) => a.name.toLowerCase().contains(_activeQuery))
          .toList();
    }
    if (_activeCity != null) {
      result = result.where((a) => a.city == _activeCity).toList();
    }
    if (_activeSpecialities.isNotEmpty) {
      result = result
          .where((a) =>
              _activeSpecialities.every((s) => a.specialities.contains(s)))
          .toList();
    }
    emit(AcademyLoaded(result));
  }

  void _onSearchAcademies(SearchAcademies event, Emitter<AcademyState> emit) {
    _activeQuery = event.query.toLowerCase();
    _applyFilters(emit);
  }

  void _onFilterAcademies(FilterAcademies event, Emitter<AcademyState> emit) {
    _activeCity = event.city;
    _activeSpecialities = event.specialities;
    _applyFilters(emit);
  }

  Future<void> _onFetchAcademies(
      FetchAcademies event, Emitter<AcademyState> emit) async {
    emit(AcademyLoading());
    try {
      final academies = await _academyRepository.getAcademies(event.token);
      academyData = academies;
      _activeQuery = '';
      _activeCity = null;
      _activeSpecialities = [];
      emit(AcademyLoaded(academyData));
    } on TokenExpiredException {
      emit(AcademyTokenExpired());
    } catch (e) {
      emit(AcademyFailed(e.toString()));
    }
  }
}
