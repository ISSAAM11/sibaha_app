import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/Model/academy.dart';
import 'package:sibaha_app/service/academy_service.dart';

part 'academy_details_event.dart';
part 'academy_details_state.dart';

class AcademyDetailsBloc
    extends Bloc<AcademyDetailsEvent, AcademyDetailsState> {
  final academyService = AcademyService();

  AcademyDetailsBloc() : super(AcademyDetailsInitial()) {
    on<FetchAcademyDetailsEvent>(_onFetchAcademies);
  }

  Future<void> _onFetchAcademies(
      FetchAcademyDetailsEvent event, Emitter<AcademyDetailsState> emit) async {
    emit(AcademyDetailsLoading());
    try {
      Academy academyDetailsData;

      Academy academy = await academyService.fetchAcademyDetails(event.id);
      academyDetailsData = academy;
      emit(AcademyDetailsLoaded(academyDetailsData));
    } catch (e) {
      emit(AcademyDetailsFailed(e.toString()));
    }
  }
}
