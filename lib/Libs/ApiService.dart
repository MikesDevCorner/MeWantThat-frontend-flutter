import 'package:ShoppingList_Flutter/Libs/AuthService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Classes/ShoppingList.dart';
import '../Classes/ShoppingEntry.dart';
import './AuthService.dart';

class ApiService {

  static final String url = 'https://me-want-that.com/api';


  static Future<dynamic> login(String email, String password) async {
      final response = await http.post(ApiService.url + '/login',
          headers: AuthService.getHeaders(),
          body: jsonEncode(<String, String>{
            'email': email,
            'password': password
          })
      );
      if (response.statusCode == 202) {
        final Map parsed = json.decode(response.body);
        await AuthService.setToken(parsed['success']['token']);
        return true;
      } else {
        if (await AuthService.checkUnauthenticated(response))
          return false;
        else
          throw Exception("some error occured during login: ");
      }
  }

  static Future<dynamic> register(String email, String password, String passwordConfirm, String name) async {
    final response = await http.post(ApiService.url + '/register',
        headers: AuthService.getHeaders(),
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'name': name,
          'password_confirmation': passwordConfirm
        }));
    final Map parsed = json.decode(response.body);
    if (response.statusCode == 201) {
      await AuthService.setToken(parsed['success']['token']);
      return "success";
    } else if(response.statusCode == 400) {
      String msg = "";
      Map errors = parsed["error"];
      errors.forEach((key, value) {
        for(int i = 0; i < value.length; i++) {
          msg += key + ": " + value[i] + "\r\n";
        }
      });
      return msg;
    } else if(await AuthService.checkUnauthenticated(response)) {
      return "somehow, the server says you are not authenticated. he should not say that.";
    }
    else {
      return "sorry, some unknown error occured during register";
    }
  }

  static bool logout() {
    http.post(ApiService.url + '/logout', headers: AuthService.getHeaders());
    AuthService.setToken(null);
    return true;
  }

  static bool unregister() {
    http.post(ApiService.url + '/unregister', headers: AuthService.getHeaders());
    AuthService.setToken(null);
    return true;
  }


  static Future<List<ShoppingList>> fetchShoppingLists() async {
    final response = await http.get(ApiService.url + '/lists', headers: AuthService.getHeaders());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((sl) => new ShoppingList.fromJson(sl)).toList();
    } else if(await AuthService.checkUnauthenticated(response)) {
      throw Exception("401"); //Unauthenticated
    }
    else {
      throw Exception("failed to load shopping lists from API");
    }
  }


  static Future<List<ShoppingEntry>> fetchShoppingEntries(int listId) async {
    final response = await http.get(ApiService.url + '/list/' +
        listId.toString() + '/entries', headers: AuthService.getHeaders());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((se) => new ShoppingEntry.fromJson(se)).toList();
    } else if(await AuthService.checkUnauthenticated(response)) {
      throw Exception("401"); //Unauthenticated
    }
    else {
      throw Exception("failed to load shopping entries from API");
    }
  }


  static Future<http.Response> deleteShoppingList(int id) async {
    final response = await http.delete(ApiService.url + '/list/' +
        id.toString(), headers: AuthService.getHeaders());
    AuthService.checkUnauthenticated(response);
    if(response.statusCode == 200 || response.statusCode == 401) return response;
    else throw Exception("failed to delete list over API");
  }


  static Future<http.Response> deleteListEntry(int id) async {
    final response = await http.delete(ApiService.url + '/entry/' +
        id.toString(), headers: AuthService.getHeaders());
    AuthService.checkUnauthenticated(response);
    if(response.statusCode == 200 || response.statusCode == 401) return response;
    else throw Exception("failed to delete entry over API");
  }


  static Future<http.Response> addShoppingList(String name) async {
    final response = await http.post(
      ApiService.url + '/list',
      headers: AuthService.getHeaders(),
      body: jsonEncode(<String, String>{
        'listname': name,
      }),
    );
    AuthService.checkUnauthenticated(response);
    if(response.statusCode == 201 || response.statusCode == 401) return response;
    else throw Exception("failed to save new list over API");
  }


  static Future<http.Response> addListEntry(int listId, int amount,
      String entryName) async {
    final response = await http.post(
      ApiService.url + '/list/' + listId.toString() +'/entry',
      headers: AuthService.getHeaders(),
      body: jsonEncode(<String, String>{
        'entryname': entryName,
        'amount': amount.toString()
      })
    );
    AuthService.checkUnauthenticated(response);
    if(response.statusCode == 201 || response.statusCode == 401) return response;
    else throw Exception("failed to save new entry over API");
  }

}
