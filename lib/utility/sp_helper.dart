import 'package:shared_preferences/shared_preferences.dart';

class SPHelper{

  static late SharedPreferences prefs;

  Future init() async{
    prefs = await SharedPreferences.getInstance();
  }

  void clear(){
    prefs.clear();
  }

  void remove(String key){
    prefs.remove(key);
  }

  Future writeIsLoggedIn(bool isLoggedIn) async{
    prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future writeJWT(String jwt) async{
    await prefs.setString('jwt', jwt);
  }

  Future writeIsRegistered(bool isRegistered) async{
    prefs.setBool('isRegistered', isRegistered);
  }

  Future writeStoreId(int storeId) async{
    prefs.setInt('storeId', storeId);
  }

  Future writeStoreName(String storeName) async{
    prefs.setString('storeName', storeName);
  }

  Future writeAlias(String alias) async{
    prefs.setString('alias', alias);
  }

  Future writeRoleId(int roleId) async{
    prefs.setInt('roleId', roleId);
  }

  String getJWT(){
    return prefs.getString('jwt') ?? '';
  }

  bool getIsLoggedIn(){
    return prefs.getBool('isLoggedIn') ?? false;
  }

  bool getIsRegistered() {
    return prefs.getBool('isRegistered') ?? false;
  }

  int? getStoreId(){
    return prefs.getInt('storeId');
  }

  String? getStoreName(){
    return prefs.getString('storeName');
  }

  String? getAlias(){
    return prefs.getString('alias');
  }

  int? getRoleId(){
    return prefs.getInt('roleId');
  }
}