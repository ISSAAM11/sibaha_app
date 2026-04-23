class Academy {
  int id;
  String name;
  List<String> poolList;
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
      poolList: List<String>.from(json['pool_list'] ?? []),
      city: json['city'] as String? ?? '',
      address: json['address'] as String? ?? '',
      specialities: List<String>.from(json['specialities'] ?? []),
      description: json['description'],
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
      'pool_list': poolList,
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
