class RoleModelClass {
  final int id;
  final String role;

  RoleModelClass({
    required this.id,
    required this.role,
  });

  factory RoleModelClass.fromJson(Map<String, dynamic> json) {
    return RoleModelClass(
      id: json['id'] ?? 0,
      role: json['role']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
  };
}
