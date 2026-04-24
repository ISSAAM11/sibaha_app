import 'package:sibaha_app/data/models/pool_summary_dto.dart';

class Academy {
  int id;
  String name;
  List<PoolSummaryDTO> poolList;
  String city;
  String address;
  List<String> specialities;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  List<WeekdayAvailability>? weekdayAvailability;
  final String? image;

  Academy({
    required this.id,
    required this.name,
    required this.poolList,
    required this.description,
    required this.city,
    required this.address,
    required this.specialities,
    required this.createdAt,
    required this.updatedAt,
    this.weekdayAvailability,
    this.image,
  });

  factory Academy.fromJson(Map<String, dynamic> json) {
    return Academy(
      id: json['id'],
      name: json['name'],
      poolList: (json['pool_list'] as List? ?? [])
          .map((e) => PoolSummaryDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      city: json['city'] as String? ?? '',
      address: json['address'] as String? ?? '',
      specialities: List<String>.from(json['specialities'] ?? []),
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      weekdayAvailability: json['weekday_availabilities'] != null
          ? (json['weekday_availabilities'] as List)
              .map((i) => WeekdayAvailability.fromJson(i))
              .toList()
          : [],
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pool_list': poolList.map((p) => {'id': p.id, 'name': p.name, 'image': p.image}).toList(),
      'city': city,
      'address': address,
      'specialities': specialities,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'image': image,
    };
  }
}

class WeekdayAvailability {
  final String weekday;
  final String? startTime;
  final String? endTime;
  final bool isClosed;

  WeekdayAvailability({
    required this.weekday,
    this.startTime,
    this.endTime,
    this.isClosed = false,
  });

  factory WeekdayAvailability.fromJson(Map<String, dynamic> json) {
    return WeekdayAvailability(
      weekday: json['weekday'] as String,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      isClosed: json['is_closed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekday': weekday,
      'start_time': startTime,
      'end_time': endTime,
      'is_closed': isClosed,
    };
  }
}
