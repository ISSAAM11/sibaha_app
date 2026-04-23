import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/data/repositories/academy_repository.dart';

part 'academy_details_event.dart';
part 'academy_details_state.dart';

class AcademyDetailsBloc
    extends Bloc<AcademyDetailsEvent, AcademyDetailsState> {
  final AcademyRepository _academyRepository;

  AcademyDetailsBloc({required AcademyRepository academyRepository})
      : _academyRepository = academyRepository,
        super(AcademyDetailsInitial()) {
    on<FetchAcademyDetailsEvent>(_onFetchAcademyDetails);
  }

  Future<void> _onFetchAcademyDetails(
      FetchAcademyDetailsEvent event, Emitter<AcademyDetailsState> emit) async {
    emit(AcademyDetailsLoading());
    try {
      final academy =
          await _academyRepository.getAcademyDetails(event.token, event.id);
      emit(AcademyDetailsLoaded(academy));
    } on TokenExpiredException {
      emit(AcademyDetailsTokenExpired());
    } catch (e) {
      emit(AcademyDetailsFailed(e.toString()));
    }
  }
}
