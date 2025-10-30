import '../../core/api_client.dart';
import 'personal_list_model.dart';

class PersonnelRepository {
  Future<PersonalListModelClass> getPersonnelList(String token) async {
    final response = await ApiClient().get('personnel-details', token: token);
    return PersonalListModelClass.fromJson(response.data);
  }
}