import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/data/repositories/academy_repository.dart';

part 'my_academy_event.dart';
part 'my_academy_state.dart';

class MyAcademyBloc extends Bloc<MyAcademyEvent, MyAcademyState> {
  final AcademyRepository _academyRepository;
  List<Academy> _academies = [];

  MyAcademyBloc({required AcademyRepository academyRepository})
      : _academyRepository = academyRepository,
        super(MyAcademyInitial()) {
    on<FetchMyAcademies>(_onFetchMyAcademies);
    on<CreateAcademy>(_onCreateAcademy);
  }

  Future<void> _onFetchMyAcademies(
      FetchMyAcademies event, Emitter<MyAcademyState> emit) async {
    emit(MyAcademyLoading());
    try {
      _academies = await _academyRepository.getMyAcademies(event.token);
      emit(MyAcademyLoaded(_academies));
    } on TokenExpiredException {
      emit(MyAcademyTokenExpired());
    } catch (e) {
      emit(MyAcademyFailed(e.toString()));
    }
  }

  Future<void> _onCreateAcademy(
      CreateAcademy event, Emitter<MyAcademyState> emit) async {
    emit(AcademyCreating());
    try {
      final academy = await _academyRepository.createAcademy(
        token: event.token,
        name: event.name,
        city: event.city,
        address: event.address,
        description: event.description,
        specialities: event.specialities,
        pictureBytes: event.pictureBytes,
        pictureFilename: event.pictureFilename,
        latitude: event.latitude,
        longitude: event.longitude,
      );
      _academies = [..._academies, academy];
      emit(AcademyCreated(academy));
      emit(MyAcademyLoaded(_academies));
    } on TokenExpiredException {
      emit(MyAcademyTokenExpired());
    } catch (e) {
      emit(AcademyCreateFailed(e.toString()));
    }
  }
}
