import 'package:shared_preferences/shared_preferences.dart';
import 'encrypter_util.dart';

class SessionUtil {
  SessionUtil();

  final EncrypterUtil _encrypter = EncrypterUtil();

  final String authKey = 'AUTH';
  final String userKey = 'USER';
  final String boardingKey = 'ONBOARDING';
  final String dateLastLoginKey = 'DATE_LAST_LOGIN';

  Future<void> writeSession(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();

    String valueEncrypted = _encrypter.encryptData(value);

    await prefs.setString(key, valueEncrypted);
  }

  Future<String?> readSession(String key) async {
    final prefs = await SharedPreferences.getInstance();

    String? result = prefs.getString(key);

    if (result != null) {
      return _encrypter.decryptData(result);
    } else {
      return null;
    }
  }

  Future<Map<String, String>> readAllSession() async {
    final prefs = await SharedPreferences.getInstance();

    final Map<String, String> decryptedData = {};
    prefs.getKeys().forEach((key) {
      final encryptedValue = prefs.getString(key);
      if (encryptedValue != null) {
        decryptedData[key] = _encrypter.decryptData(encryptedValue);
      }
    });

    return decryptedData;
  }

  Future<void> deleteSession(String key) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(key);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}
