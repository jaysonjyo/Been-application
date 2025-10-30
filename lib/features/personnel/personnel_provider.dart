import 'package:flutter/material.dart';
import 'personnel_repository.dart';
import 'personal_list_model.dart';

class PersonnelProvider extends ChangeNotifier {
  final PersonnelRepository repository;

  bool loading = false;
  String? error;
  PersonalListModelClass? personnelData;
  List<Datum> filteredList = [];

  PersonnelProvider(this.repository); // ✅ constructor added

  Future<void> fetchPersonnel(String token) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final response = await repository.getPersonnelList(token);
      personnelData = response;
      filteredList = response.data;
    } catch (e) {
      error = "Unable to fetch data. Please check your connection.";
    }

    loading = false;
    notifyListeners();
  }

  void filterPersonnel(String query) {
    if (query.isEmpty) {
      filteredList = personnelData?.data ?? [];
    } else {
      final lower = query.toLowerCase();
      filteredList = (personnelData?.data ?? []).where((p) {
        final fullName = "${p.firstName} ${p.lastName ?? ''}".toLowerCase();
        return fullName.contains(lower);
      }).toList();
    }
    notifyListeners();
  }
}
