class PersonalListModelClass {
  bool status;
  List<Datum> data;

  PersonalListModelClass({
    required this.status,
    required this.data,
  });

  factory PersonalListModelClass.fromJson(Map<String, dynamic> json) {
    return PersonalListModelClass(
      status: json['status'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Datum {
  int id;
  String firstName;
  dynamic lastName;
  String address;
  String? latitude;
  String? longitude;
  String? suburb;
  String? state;
  String? postcode;
  String country;
  String contactNumber;
  String? additionalNotes;
  String status;
  String roleIds;
  String createdBy;
  dynamic updatedBy;
  List<RoleDetail> roleDetails;
  List<String> apiaryRoleArray;

  Datum({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.suburb,
    required this.state,
    required this.postcode,
    required this.country,
    required this.contactNumber,
    required this.additionalNotes,
    required this.status,
    required this.roleIds,
    required this.createdBy,
    required this.updatedBy,
    required this.roleDetails,
    required this.apiaryRoleArray,
  });

  /// ✅ Parse from API JSON
  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'],
      address: json['address'] ?? '',
      latitude: json['latitude'],
      longitude: json['longitude'],
      suburb: json['suburb'],
      state: json['state'],
      postcode: json['postcode'],
      country: json['country'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      additionalNotes: json['additional_notes'],
      status: json['status'] ?? '',
      roleIds: json['role_ids'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'],
      roleDetails: (json['role_details'] as List<dynamic>?)
          ?.map((e) => RoleDetail.fromJson(e))
          .toList() ??
          [],
      apiaryRoleArray: (json['apiary_role_array'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }
}

class RoleDetail {
  int id;
  Role role;

  RoleDetail({
    required this.id,
    required this.role,
  });

  /// ✅ Parse role details
  factory RoleDetail.fromJson(Map<String, dynamic> json) {
    return RoleDetail(
      id: json['id'] ?? 0,
      role: roleFromString(json['role']),
    );
  }
}

/// ✅ Enum for internal consistency
enum Role {
  ADMIN_USER,
  CHEM_APPLICATOR,
  COLONY_OWNER,
  LAND_OWNER,
  SUPER_ADMIN,
}

/// ✅ Convert string from API → Enum
Role roleFromString(String? value) {
  switch (value) {
    case 'Admin User':
      return Role.ADMIN_USER;
    case 'Chem Applicator':
      return Role.CHEM_APPLICATOR;
    case 'Colony Owner':
      return Role.COLONY_OWNER;
    case 'Land Owner':
      return Role.LAND_OWNER;
    case 'Super Admin':
      return Role.SUPER_ADMIN;
    default:
      return Role.ADMIN_USER;
  }
}

/// ✅ Convert Enum → Readable Display Name (for UI)
String roleToDisplay(Role role) {
  switch (role) {
    case Role.ADMIN_USER:
      return 'Admin User';
    case Role.CHEM_APPLICATOR:
      return 'Chem Applicator';
    case Role.COLONY_OWNER:
      return 'Colony Owner';
    case Role.LAND_OWNER:
      return 'Land Owner';
    case Role.SUPER_ADMIN:
      return 'Super Admin';
  }
}
