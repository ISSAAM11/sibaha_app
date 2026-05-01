part of 'my_academy_bloc.dart';

@immutable
sealed class MyAcademyEvent {}

class FetchMyAcademies extends MyAcademyEvent {
  final String token;
  FetchMyAcademies(this.token);
}

class CreateAcademy extends MyAcademyEvent {
  final String token;
  final String name;
  final String city;
  final String address;
  final String description;
  final List<String> specialities;
  final Uint8List pictureBytes;
  final String pictureFilename;
  final double? latitude;
  final double? longitude;

  CreateAcademy({
    required this.token,
    required this.name,
    required this.city,
    required this.address,
    required this.description,
    required this.specialities,
    required this.pictureBytes,
    required this.pictureFilename,
    this.latitude,
    this.longitude,
  });
}
