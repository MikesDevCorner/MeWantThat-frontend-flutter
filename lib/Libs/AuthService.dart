import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {

  static final storage = new FlutterSecureStorage();
  static String _token=null;
  static final Map<String, String> _headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json'
  };

  static String getToken() {
    return AuthService._token;
  }

  static setToken(String token, [bool skipSecureWriting]) async {
    AuthService._token = token;
    if(token != null) {
      AuthService._headers['Authorization'] = 'Bearer $token';
      if(skipSecureWriting != true) await AuthService.storage.write(key: 'token', value: token);
    } else {
      AuthService._headers.remove('Authorization');
      if(skipSecureWriting != true) await AuthService.storage.delete(key: 'token');
    }
  }

  static init() async {
    String token = await storage.read(key: 'token');
    AuthService.setToken(token, true);
  }

  static Map<String, String> getHeaders() {
    return AuthService._headers;
  }

  static checkUnauthenticated(Response response) async {
    if(response.statusCode == 401) {
      await AuthService.setToken(null);
      return true;
    }
    else return false;
  }

  static bool isAuth() {
    return AuthService._token != null;
  }

}