import 'package:shared_preferences/shared_preferences.dart';

Future<void> setGenderPreference(String gender) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_gender', gender);
}

  Future<String> getGenderPreference() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String gender = prefs.getString('user_gender') ?? 'Not set';
    return gender;

}