class Pool {
  int id;
  String name;
  String academyName;
  int academyId;
  List<String> speciality;
  List<String> dimension;
  bool heated;
  int showers;
  String? image;
  DateTime createdAt;

  Pool({
    required this.id,
    required this.name,
    required this.academyName,
    required this.academyId,
    required this.speciality,
    required this.dimension,
    required this.heated,
    required this.showers,
    required this.createdAt,
    this.image,
  });

  factory Pool.fromJson(Map<String, dynamic> json) {
    return Pool(
      id: json['id'],
      name: json['name'],
      academyName: json['academy_name'] as String? ?? '',
      academyId: json['academy_id'],
      speciality: List<String>.from(json['speciality'] ?? []),
      dimension: List<String>.from(json['dimension'] ?? []),
      heated: json['heated'] as bool? ?? false,
      showers: json['showers'] as int? ?? 0,
      image: json['image'] as String?,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'academy_name': academyName,
      'academy_id': academyId,
      'speciality': speciality,
      'dimension': dimension,
      'heated': heated,
      'showers': showers,
      'image': image,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
