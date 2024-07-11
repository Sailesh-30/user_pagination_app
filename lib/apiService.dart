import 'dart:convert';

import 'package:http/http.dart';

import 'user.dart';


class ApiService {
  static const String baseUrl = 'https://reqres.in/api';

  // static Future<List<User>> fetchUsers(int page) async {
  //   var response = await get(Uri.parse(
  //       '$baseUrl/users?page=$page'));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> usersJson = json.decode(response.body)['data'];
  //     print(usersJson);
  //     return usersJson.map((json) => User.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }

  static Future<User> fetchUser(int userId) async {
    var response = await get(Uri.parse(
        '$baseUrl/users/$userId'));
    if (response.statusCode == 200) {
      final dynamic userJson = json.decode(response.body)['data'];
      return User.fromJson(userJson);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
