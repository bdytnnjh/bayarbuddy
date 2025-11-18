import 'package:app/core/utils/session_util.dart';

class AppUtil {
  static Future<String?> getCurrentUserId() async {
    final SessionUtil sessionUtil = SessionUtil();
    final userId = await sessionUtil.readSession(sessionUtil.userKey);
    return userId;
  }
}
