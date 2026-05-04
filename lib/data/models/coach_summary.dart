class CoachSummary {
  final int id;
  final String username;
  final String phone;
  final String? picture;
  final List<String> languages;
  final String speciality;
  final String aboutMe;
  final int? yearsOfExperience;

  const CoachSummary({
    required this.id,
    required this.username,
    required this.phone,
    this.picture,
    this.languages = const [],
    this.speciality = '',
    this.aboutMe = '',
    this.yearsOfExperience,
  });

  factory CoachSummary.fromJson(Map<String, dynamic> json) {
    return CoachSummary(
      id: json['id'] as int,
      username: json['username'] as String,
      phone: (json['phone'] as String?) ?? '',
      picture: json['picture'] as String?,
      languages: List<String>.from(json['languages'] ?? []),
      speciality: (json['speciality'] as String?) ?? '',
      aboutMe: (json['about_me'] as String?) ?? '',
      yearsOfExperience: json['years_of_experience'] as int?,
    );
  }
}
