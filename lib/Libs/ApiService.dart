import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../Classes/ShoppingList.dart';
import '../Classes/ShoppingEntry.dart';


class ApiService {

  static final String url = 'https://masterthesis.mikesdevcorner.com';

  static Future<List<ShoppingList>> fetchShoppingLists() async {
    final response = await http.get(ApiService.url + '/api/lists');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      //debugPrint(jsonResponse[0]["listenname"]);
      return jsonResponse.map((sl) => new ShoppingList.fromJson(sl)).toList();
    } else {
      throw Exception("failed to load shopping lists from API");
    }
  }


  static Future<List<ShoppingEntry>> fetchShoppingEntries(int listId) async {
    final response = await http.get(ApiService.url + '/api/entries/' +
        listId.toString());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((se) => new ShoppingEntry.fromJson(se)).toList();
    } else {
      throw Exception("failed to load shopping entries from API");
    }
  }


  static Future<bool> deleteShoppingList(int id) async {
    debugPrint("delete list with id " + id.toString());
    final response = await http.delete(ApiService.url + '/api/list/' +
        id.toString());
    if(response.statusCode == 204) return true;
    else throw Exception("failed to delete list over API");
  }


  static Future<bool> deleteListEntry(int id) async {
    debugPrint("delete entry with id " + id.toString());
    final response = await http.delete(ApiService.url + '/api/entry/' +
        id.toString());
    if(response.statusCode == 204) return true;
    else throw Exception("failed to delete entry over API");
  }


  static Future<bool> addShoppingList(String name) async {
    debugPrint("added new shopping list with name " + name);
    final response = await http.post(
      ApiService.url + '/api/list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'listenname': name,
      }),
    );
    if(response.statusCode == 201) return true;
    else throw Exception("failed to save new list over API");
  }


  static Future<bool> addListEntry(int listId, int amount,
      String entryName) async {
    debugPrint("added " + amount.toString() + "x " + entryName +
        " to shopping list with id " + listId.toString());
    final sendData = jsonEncode(<String, String>{
      'postenname': entryName,
      'anzahl': amount.toString(),
      'einkaufsliste_id': listId.toString()
    });
    final response = await http.post(
      ApiService.url + '/api/entry',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: sendData,
    );
    if(response.statusCode == 201) return true;
    else throw Exception("failed to save new entry over API");
  }

}
