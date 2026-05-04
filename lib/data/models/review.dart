class Review {
  final int id;
  final int userId;
  final String username;
  final String? userPicture;
  final int rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.username,
    this.userPicture,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      username: json['username'] as String,
      userPicture: json['user_picture'] as String?,
      rating: json['rating'] as int,
      comment: json['comment'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
