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

class UpdatePool extends MyAcademyEvent {
  final String token;
  final int academyId;
  final int poolId;
  final String name;
  final List<String> speciality;
  final List<String> dimension;
  final bool heated;
  final int showers;
  final Uint8List? pictureBytes;
  final String? pictureFilename;

  UpdatePool({
    required this.token,
    required this.academyId,
    required this.poolId,
    required this.name,
    required this.speciality,
    required this.dimension,
    required this.heated,
    required this.showers,
    this.pictureBytes,
    this.pictureFilename,
  });
}

class DeletePool extends MyAcademyEvent {
  final String token;
  final int academyId;
  final int poolId;

  DeletePool({
    required this.token,
    required this.academyId,
    required this.poolId,
  });
}

class CreatePool extends MyAcademyEvent {
  final String token;
  final int academyId;
  final String name;
  final List<String> speciality;
  final List<String> dimension;
  final bool heated;
  final int showers;
  final Uint8List? pictureBytes;
  final String? pictureFilename;

  CreatePool({
    required this.token,
    required this.academyId,
    required this.name,
    required this.speciality,
    required this.dimension,
    required this.heated,
    required this.showers,
    this.pictureBytes,
    this.pictureFilename,
  });
}

class UpdateAcademy extends MyAcademyEvent {
  final String token;
  final int academyId;
  final String name;
  final String city;
  final String address;
  final String description;
  final List<String> specialities;
  final Uint8List? pictureBytes;
  final String? pictureFilename;
  final double? latitude;
  final double? longitude;

  UpdateAcademy({
    required this.token,
    required this.academyId,
    required this.name,
    required this.city,
    required this.address,
    required this.description,
    required this.specialities,
    this.pictureBytes,
    this.pictureFilename,
    this.latitude,
    this.longitude,
  });
}
