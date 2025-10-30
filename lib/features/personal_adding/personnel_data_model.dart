class PersonnelAddResponse {
  final bool status;
  final int id;
  final String message;

  const PersonnelAddResponse({
    required this.status,
    required this.id,
    required this.message,
  });

  factory PersonnelAddResponse.fromJson(Map<String, dynamic> json) {
    return PersonnelAddResponse(
      status: json['status'] == true || json['status'] == 1,
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'id': id,
    'message': message,
  };
}
