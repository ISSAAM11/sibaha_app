enum InvitationStatus { pending, accepted, declined }

class Invitation {
  final int id;
  final int fromOwner;
  final String fromOwnerName;
  final int toCoach;
  final String toCoachName;
  final String? toCoachPicture;
  final int? academyId;
  final String? academyName;
  final int? courseId;
  final String? courseName;
  final InvitationStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;

  const Invitation({
    required this.id,
    required this.fromOwner,
    required this.fromOwnerName,
    required this.toCoach,
    required this.toCoachName,
    this.toCoachPicture,
    this.academyId,
    this.academyName,
    this.courseId,
    this.courseName,
    required this.status,
    required this.createdAt,
    this.respondedAt,
  });

  static InvitationStatus _parseStatus(String s) => switch (s) {
        'accepted' => InvitationStatus.accepted,
        'declined' => InvitationStatus.declined,
        _ => InvitationStatus.pending,
      };

  factory Invitation.fromJson(Map<String, dynamic> json) => Invitation(
        id: json['id'] as int,
        fromOwner: json['from_owner'] as int? ?? 0,
        fromOwnerName: (json['from_owner_name'] as String?) ?? '',
        toCoach: json['to_coach'] as int? ?? 0,
        toCoachName: (json['to_coach_name'] as String?) ?? '',
        toCoachPicture: json['to_coach_picture'] as String?,
        academyId: json['academy_id'] as int?,
        academyName: json['academy_name'] as String?,
        courseId: json['course'] as int?,
        courseName: json['course_name'] as String?,
        status: _parseStatus((json['status'] as String?) ?? 'pending'),
        createdAt: DateTime.parse(json['created_at'] as String),
        respondedAt: json['responded_at'] != null
            ? DateTime.parse(json['responded_at'] as String)
            : null,
      );

  Invitation copyWith({InvitationStatus? status, DateTime? respondedAt}) =>
      Invitation(
        id: id,
        fromOwner: fromOwner,
        fromOwnerName: fromOwnerName,
        toCoach: toCoach,
        toCoachName: toCoachName,
        toCoachPicture: toCoachPicture,
        academyId: academyId,
        academyName: academyName,
        courseId: courseId,
        courseName: courseName,
        status: status ?? this.status,
        createdAt: createdAt,
        respondedAt: respondedAt ?? this.respondedAt,
      );
}
