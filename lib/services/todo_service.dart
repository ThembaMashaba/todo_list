import 'package:flutter/material.dart';
import 'package:flutter_todo_app_22apr/database/todo_database.dart';
import 'package:flutter_todo_app_22apr/models/todo.dart';

class TodoService with ChangeNotifier {
  final List<Todo> _todos = [];

//getters
  List<Todo> get todos => _todos;

//Get todo from user
  Future<String> getTodos(String username) async {
    try {
      await TodoDatabase.instance.getToDos(username);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'OK';
  }

//Delete a todo
  Future<String> deleteTodo(Todo todo) async {
    try {
      await TodoDatabase.instance.deleteTodo(todo);
    } catch (e) {
      return e.toString();
    }
    String result = await getTodos(todo.username);
    return result;
  }

//Create a todo
  Future<String> createTodo(Todo todo) async {
    try {
      await TodoDatabase.instance.createTodo(todo);
    } catch (e) {
      return e.toString();
    }
    String result = await getTodos(todo.username);
    return result;
  }

//Toggle checkbox
  Future<String> toggleTodoDone(Todo todo) async {
    try {
      await TodoDatabase.instance.toggleToDo(todo);
    } catch (e) {
      return e.toString();
    }
    String result = await getTodos(todo.username);
    return result;
  }
}
