import 'package:flutter/material.dart';
import 'package:flutter_todo_app_22apr/database/todo_database.dart';
import 'package:flutter_todo_app_22apr/models/user.dart';

class UserService with ChangeNotifier {
  late User _currentUser;
  bool _busyCreate = false;
  bool _userExists = false;

//Getters
  User get currentUser => _currentUser;
  bool get busyCreate => _busyCreate;
  bool get userExists => _userExists;

//setters
  set userExists(bool value) {
    _userExists = value;
    notifyListeners();
  }

  //Make sure user exists in login page
  Future<String> getUser(String username) async {
    String result = 'OK';

    try {
      _currentUser = await TodoDatabase.instance.getUser(username);
      notifyListeners();
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

  //Check if user exists in register page
  Future<String> checkIfUserExists(String username) async {
    String result = 'OK';
    try {
      await TodoDatabase.instance.getUser(username);
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

//Update a user
  Future<String> updateCurrentUser(String name) async {
    String result = 'OK';
    _currentUser.name = name;
    notifyListeners();
    try {
      await TodoDatabase.instance.updateUser(_currentUser);
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

//Create a new user
  Future<String> createUser(User user) async {
    String result = 'OK';
    _busyCreate = true;
    notifyListeners();
    try {
      await TodoDatabase.instance.createUser(user);
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    _busyCreate = false;
    notifyListeners();
    return result;
  }
}

String getHumanReadableError(String message) {
  if (message.contains('UNIQUE constraint failed')) {
    return 'User already exists in the database. Please choose another';
  }
  if (message.contains('not found in database.')) {
    return 'The user does not exist in the database. Please register first.';
  }
  return message;
}
