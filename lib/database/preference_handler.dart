import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static late SharedPreferences _prefs;
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Keys
  static const _keyIsLogin = "isLogin";
  static const _keyUserId = "userId";
  static const _keyUserUid = "userUid";
  static const _keyRole = "role";
  static const _keyAvatarIndex = "avatarIndex";

  // =================== LOGIN STATUS ===================
  //create login
  static Future<void> setLogin(bool isLogin) async {
    await _prefs.setBool(_keyIsLogin, isLogin);
  }

  //get/read apakah sdh login atau blm
  static bool get isLogin {
    //jika _keyIsLogin null, return false
    return _prefs.getBool(_keyIsLogin) ?? false;
  }

  // =================== USER ID (SQLite - sementara, akan dihapus setelah migrasi selesai) ===================
  //set ID User setelah sukses login
  static Future<void> setUserId(int userId) async {
    await _prefs.setInt(_keyUserId, userId);
  }

  //ambil ID User untuk kebutuhan query/fitur game (bisa null kalau belum login)
  static int? get userId {
    return _prefs.getInt(_keyUserId);
  }

  // =================== USER UID (Firebase) ===================
  //set ID User setelah sukses login (FIREBASE)
  static Future<void> setUserUid(String userUid) async {
    await _prefs.setString(_keyUserUid, userUid);
  }

  //ambil ID User untuk kebutuhan query/fitur game (FIREBASE)
  static String? get userUid {
    return _prefs.getString(_keyUserUid);
  }

  // =================== USER ROLE ===================
  //set Role setelah sukses login
  static Future<void> setRole(String role) async {
    await _prefs.setString(_keyRole, role);
  }

  //ambil Role untuk kondisional UI Navbar Admin/User
  static String get role {
    return _prefs.getString(_keyRole) ?? 'user'; // Default 'user' jika null
  }

  // =================== AVATAR INDEX ===================
  static Future<void> setAvatarIndex(int index) async {
    await _prefs.setInt(_keyAvatarIndex, index);
  }

  static int get avatarIndex {
    return _prefs.getInt(_keyAvatarIndex) ?? 1; // Default avatar ke-1 jika null
  }

  // =================== LOGOUT (CLEAR DATA) ===================
  //delete login, id, role, avatar
  static Future<void> logOut() async {
    await _prefs.remove(_keyIsLogin);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserUid);
    await _prefs.remove(_keyRole);
    await _prefs.remove(_keyAvatarIndex);
  }
}
