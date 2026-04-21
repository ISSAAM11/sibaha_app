class User {
  final int id;
  final String username;
  final String email;
  final UserType userType;
  final String phone;
  final DateTime dateJoined;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.userType,
    required this.phone,
    required this.dateJoined,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      userType: getUserType(json['user_type'] as String),
      phone: json['phone'] as String,
      dateJoined: DateTime.parse(json['date_joined'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'user_type': userType,
      'phone': phone,
      'date_joined': dateJoined.toIso8601String(),
    };
  }

  static UserType getUserType(String thisUserType) {
    switch (thisUserType) {
      case 'academy_owner':
        return UserType.academyOwner;
      case 'coach':
        return UserType.coach;
      default:
        return UserType.user;
    }
  }
}

enum UserType {
  user,
  academyOwner,
  coach,
}
