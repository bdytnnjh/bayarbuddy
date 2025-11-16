import 'package:encrypt/encrypt.dart';

class EncrypterUtil {
  String keyString = '9bLQ8qA79bfCMCDXNPYRbYVNicmi59k';
  String ivString = 'bByZM84tUl6h1djM';

  String encryptData(String plainText) {
    final key = Key.fromUtf8(keyString);
    final iv = IV.fromUtf8(ivString);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base16;
  }

  String decryptData(String encryptedText) {
    final key = Key.fromUtf8(keyString);
    final iv = IV.fromUtf8(ivString);
    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}
