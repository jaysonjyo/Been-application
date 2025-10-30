import 'package:bee_chem/features/personal_adding/personnel_adding_repository.dart';
import 'package:bee_chem/features/personal_adding/roles_model_class.dart';
import 'package:flutter/material.dart';


class PersonnelAddingProvider extends ChangeNotifier {
  final PersonnelAddingRepository repo;
  bool loading = false;
  String? error;

  PersonnelAddingProvider({required this.repo});

  Future<void> addPersonnel(String token, Map<String, dynamic> body) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await repo.addPersonnel(token, body);
      if (!res.status) error = res.message;
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  // ✅ NEW FUNCTION
  Future<List<RoleModelClass>> fetchRoles(String token) async {
    try {
      return await repo.fetchRoles(token);
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return [];
    }
  }
}
