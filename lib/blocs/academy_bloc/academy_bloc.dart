import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/Model/academy.dart';
import 'package:sibaha_app/service/academy_service.dart';

part 'academy_event.dart';
part 'academy_state.dart';

class AcademyBloc extends Bloc<AcademyEvent, AcademyState> {
  final academyService = AcademyService();
  List<Academy> academyData = [];

  AcademyBloc() : super(AcademyInitial()) {
    on<FetchAcademies>(_onFetchAcademies);
  }

  Future<void> _onFetchAcademies(
      FetchAcademies event, Emitter<AcademyState> emit) async {
    emit(AcademyLoading());
    try {
      List<Academy> academies = await academyService.fetchAcademies();
      academyData = academies;
      emit(AcademyLoaded(academyData));
    } catch (e) {
      emit(AcademyFailed(e.toString()));
    }
  }
}
