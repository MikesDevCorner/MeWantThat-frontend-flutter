import 'package:ShoppingList_Flutter/Libs/AuthService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Classes/ShoppingList.dart';
import '../Classes/ShoppingEntry.dart';
import './AuthService.dart';

class ApiService {

  static final String url = 'http://10.0.2.2:8000/api'; //'https://masterthesis2.mikesdevcorner.com/api';

  static Future<bool> test() async {
    final response = await http.get(ApiService.url + '/test');
    if (response.statusCode == 200) return true;
    else return false;
  }


  static Future<bool> login(String email, String password) async {
    Map headers = AuthService.getHeaders();
    final response = await http.post(ApiService.url + '/login',
      headers: {"Content-type": "application/json", "Accept": "application/json"},
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password
      })
    );
    if (response.statusCode == 202) {
      final Map parsed = json.decode(response.body);

      //await AuthService.setToken(jsonResult['success']['token']);
      return true;
    } else if(AuthService.checkUnauthenticated(response)) {
      return false;
    }
    else {
      throw Exception("some error occured during login");
    }
  }

  static Future<bool> register(String email, String password, String passwordConfirm, String name) async {
    final response = await http.post(ApiService.url + '/login',
        headers: AuthService.getHeaders(),
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'name': name,
          'password_confirmation': passwordConfirm
        }));
    if (response.statusCode == 201) {
      await AuthService.setToken(json.decode(response.body).success.token);
      return true;
    } else if(AuthService.checkUnauthenticated(response)) {
      return false;
    }
    else {
      throw Exception("some error occured during register");
    }
  }

  static Future<bool> logout() async {
    //TODO
  }

  static Future<List<ShoppingList>> fetchShoppingLists() async {
    final response = await http.get(ApiService.url + '/lists', headers: AuthService.getHeaders());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((sl) => new ShoppingList.fromJson(sl)).toList();
    } else if(AuthService.checkUnauthenticated(response)) {
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
    } else if(AuthService.checkUnauthenticated(response)) {
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
