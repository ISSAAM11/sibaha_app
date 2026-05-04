enum InvitationStatus { pending, accepted, declined }

class Invitation {
  final int id;
  final int toCoach;
  final String toCoachName;
  final String? toCoachPicture;
  final InvitationStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;

  const Invitation({
    required this.id,
    required this.toCoach,
    required this.toCoachName,
    this.toCoachPicture,
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
        toCoach: json['to_coach'] as int,
        toCoachName: (json['to_coach_name'] as String?) ?? '',
        toCoachPicture: json['to_coach_picture'] as String?,
        status: _parseStatus((json['status'] as String?) ?? 'pending'),
        createdAt: DateTime.parse(json['created_at'] as String),
        respondedAt: json['responded_at'] != null
            ? DateTime.parse(json['responded_at'] as String)
            : null,
      );
}
