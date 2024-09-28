import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

class UserService {
  static String _userKey = '_user';
  static String _newUserKey = '_newUserKey';

  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", user.id);
    prefs.setString("user_token", user.token);
    prefs.setString(_userKey, jsonEncode(user.toJson()));
    prefs.setBool(_newUserKey, true);
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString(_userKey);
    if (userString != null) {
      return User.fromJson(jsonDecode(userString));
    }
    return null;
  }

  Future<void> clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_userKey);
    prefs.remove(_newUserKey);
  }

  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }
}

class User {
  final String id;
  final String? name;
  final String email;
  final String password;
  final String token;

  User({
    required this.id,
    this.name,
    required this.email,
    required this.password,
    required this.token,
  });

  static String encryptPassword(String password) {
    var bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // Generate UUID
  static String generateUUID() {
    var uuid = Uuid();
    return uuid.v4();
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'token': token,
    };
  }
}


class UserModel {
  final String uuid;
  final String email;
  final String username;
  final String password;

  UserModel({
    required this.uuid,
    required this.email,
    required this.username,
    required this.password,
  });

  // Convert a UserModel into a Map.
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'email': email,
      'username': username,
      'password': password,
    };
  }

  // Encrypt password
  static String encryptPassword(String password) {
    var bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // Generate UUID
  static String generateUUID() {
    var uuid = Uuid();
    return uuid.v4();
  }
}
