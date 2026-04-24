class PoolSummaryDTO {
  final int id;
  final String name;
  final String? image;

  PoolSummaryDTO({
    required this.id,
    required this.name,
    this.image,
  });

  factory PoolSummaryDTO.fromJson(Map<String, dynamic> json) {
    return PoolSummaryDTO(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String?,
    );
  }
}
