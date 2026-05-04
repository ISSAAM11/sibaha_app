class CoachFilter {
  final List<String> languages;
  final List<String> specialities;
  final bool hasExperience;

  const CoachFilter({
    this.languages = const [],
    this.specialities = const [],
    this.hasExperience = false,
  });

  bool get isActive =>
      languages.isNotEmpty || specialities.isNotEmpty || hasExperience;
}
