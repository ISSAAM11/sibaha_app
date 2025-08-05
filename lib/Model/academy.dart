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
  final String image;

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
    required this.image,
  });

  // Factory constructor for creating an Academy instance from a JSON map
  factory Academy.fromJson(Map<String, dynamic> json) {
    return Academy(
      id: json['id'],
      name: json['name'],
      poolList: List<String>.from(json['pool_list'] ?? []),
      city: json['city'],
      address: json['address'],
      specialities: List<String>.from(json['specialities'] ?? []),
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      weekdayAvailability: json['weekday_availabilities'] != null
          ? (json['weekday_availabilities'] as List)
              .map((i) => WeekdayAvailability.fromJson(i))
              .toList()
          : [],
      image: json['image'],
    );
  }

  // Method to convert an Academy instance to a JSON map
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
  final String startTime;
  final String endTime;

  WeekdayAvailability({
    required this.weekday,
    required this.startTime,
    required this.endTime,
  });

  factory WeekdayAvailability.fromJson(Map<String, dynamic> json) {
    return WeekdayAvailability(
      weekday: json['weekday'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekday': weekday,
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}
