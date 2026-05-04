class PoolSummaryDTO {
  final int id;
  final String name;
  final String? image;
  final List<String> speciality;
  final List<String> dimension;
  final bool heated;
  final int showers;

  PoolSummaryDTO({
    required this.id,
    required this.name,
    this.image,
    this.speciality = const [],
    this.dimension = const [],
    this.heated = false,
    this.showers = 0,
  });

  factory PoolSummaryDTO.fromJson(Map<String, dynamic> json) {
    return PoolSummaryDTO(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String?,
      speciality: List<String>.from(json['speciality'] ?? []),
      dimension: List<String>.from(json['dimension'] ?? []),
      heated: json['heated'] as bool? ?? false,
      showers: json['showers'] as int? ?? 0,
    );
  }
}
