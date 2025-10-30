import 'package:bee_chem/core/api_client.dart';
import 'package:bee_chem/features/personal_adding/personnel_data_model.dart';
import 'package:bee_chem/features/personal_adding/roles_model_class.dart';


class PersonnelAddingRepository {
  final ApiClient apiClient;

  PersonnelAddingRepository(this.apiClient);

  Future<PersonnelAddResponse> addPersonnel(
      String token, Map<String, dynamic> body) async {
    final response = await apiClient.postWithToken(
      'personnel-details/add',
      token: token,
      data: body,
    );

    if (response.statusCode == 200) {
      return PersonnelAddResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to add personnel: ${response.statusMessage}');
    }
  }

  // ✅ NEW METHOD
  Future<List<RoleModelClass>> fetchRoles(String token) async {
    final response = await apiClient.get(
      'roles/apiary-roles',
      token: token,
    );

   // print("📡 Roles API called → status: ${response.statusCode}");
    //print("📦 Response data: ${response.data}");

    if (response.statusCode == 200) {
      // Defensive parsing
      final resData = response.data;
      if (resData is Map && resData.containsKey('data')) {
        final data = resData['data'] as List;
        //print("✅ Parsed ${data.length} roles");
        return data.map((e) => RoleModelClass.fromJson(e)).toList();
      } else if (resData is List) {
        // Sometimes backend returns a list directly
        //print("⚠️ Response was a list — mapping directly");
        return resData.map((e) => RoleModelClass.fromJson(e)).toList();
      } else {
        //print("❌ Unexpected format: ${resData.runtimeType}");
        throw Exception("Unexpected roles format");
      }
    } else {
      throw Exception('Failed to fetch roles: ${response.statusMessage}');
    }
  }

}