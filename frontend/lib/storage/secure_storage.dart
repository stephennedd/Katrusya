import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static const _keyAccessToken = "accessToken";

  static Future setAccessToken(String accessToken) async {
    await storage.write(key: _keyAccessToken, value: accessToken);
  }

  static Future getAccessToken() async {
    var res = await storage.read(key: _keyAccessToken);
    return res;
  }

  static Future deleteAccessToken() async {
    // Delete the saved token
    await storage.delete(key: _keyAccessToken);
  }
}
