import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/data/repositories/academy_repository.dart';

part 'academy_event.dart';
part 'academy_state.dart';

class AcademyBloc extends Bloc<AcademyEvent, AcademyState> {
  final AcademyRepository _academyRepository;
  List<Academy> academyData = [];

  AcademyBloc({required AcademyRepository academyRepository})
      : _academyRepository = academyRepository,
        super(AcademyInitial()) {
    on<FetchAcademies>(_onFetchAcademies);
  }

  Future<void> _onFetchAcademies(
      FetchAcademies event, Emitter<AcademyState> emit) async {
    emit(AcademyLoading());
    try {
      final academies = await _academyRepository.getAcademies(event.token);
      academyData = academies;
      emit(AcademyLoaded(academyData));
    } on TokenExpiredException {
      emit(AcademyTokenExpired());
    } catch (e) {
      emit(AcademyFailed(e.toString()));
    }
  }
}
