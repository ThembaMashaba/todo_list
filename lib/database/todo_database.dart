// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter_todo_app_22apr/models/todo.dart';
import 'package:flutter_todo_app_22apr/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//DATABASE (DB)
class TodoDatabase {
  //Ensure you only have 1 instance of DB - instance creates an object of DB
  static final TodoDatabase instance = TodoDatabase._initialize();
  static Database? _database;
  TodoDatabase._initialize();

  Future _createDB(Database db, int version) async {
    const usersUsernameType = 'TEXT PRIMARY KEY NOT NULL';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    //Create user table
    await db.execute('''CREATE TABLE $userTable (
      ${UserFields.username} $usersUsernameType,
      ${UserFields.name} $textType,
)''');

    //Create todo table
    await db.execute('''CREATE TABLE $todoTable (
      ${TodoFields.username} $textType,
      ${TodoFields.title} $textType,
      ${TodoFields.created} $textType,
      ${TodoFields.done} $boolType,
      FOREIGN KEY (${TodoFields.username}) REFERENCES $userTable (${UserFields.username})
)''');
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

//Uses the parsed filename to make a link to the DB - Opens DB
  Future<Database> _initDB(String fileName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

//Closes the DB
  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  Future<Database?> get database async {
    if (_database != Null) {
      return _database;
    } else {
      _database = await _initDB('todo.db');
      return _database;
    }
  }

  //CRUD
  //Create User
  Future<User> createUser(User user) async {
    final db = await instance.database;
    await db!.insert(userTable, user.toJson());
    return user;
  }

  //Read User
  Future<User> getUser(String username) async {
    final db = await instance.database;
    final maps = await db!.query(
      userTable,
      columns: UserFields.allFields,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('$username not found in the database.');
    }
  }

  //Get all users (Ascending and descending) - Do later
  // Future<List<User>> getAllUsers() {
  //   final db = await instance.database;
  //   final result = await db!.query(
  //     userTable,
  //     orderBy: '${UserFields.username} ASC',
  //   );
  //   return result.map((e) => User.fromJson(e)).toList();
  // }

//Update User
  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return db!.update(
      userTable,
      user.toJson(),
      where: '${UserFields.username} = ?',
      whereArgs: [user.username],
    );
  }

  //Delete User
  Future<int> deleteUser(String username) async {
    final db = await instance.database;
    return db!.delete(
      userTable,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );
  }

  //Create ToDo
  Future<Todo> createTodo(Todo todo) async {
    final db = await instance.database;
    await db!.insert(
      todoTable,
      todo.toJson(),
    );
    return todo;
  }

  //Update ToDo
  Future<int> toggleToDo(Todo todo) async {
    final db = await instance.database;
    todo.done = !todo.done;
    return db!.update(
      todoTable,
      todo.toJson(),
      where: '${TodoFields.title} = ? AND ${TodoFields.username} = ?',
      whereArgs: [todo.title, todo.username],
    );
  }

//List of all Todos
  Future<List<Todo>> getToDos(String username) async {
    final db = await instance.database;
    final result = await db!.query(
      todoTable,
      orderBy: '${TodoFields.created} DESC',
      where: '${TodoFields.username} = ?',
      whereArgs: [username],
    );
    return result.map((e) => Todo.fromJson(e)).toList();
  }

//Delete Todo
  Future<int> deleteTodo(Todo todo) async {
    final db = await instance.database;
    return db!.delete(
      todoTable,
      where: '${TodoFields.title} = ? AND ${TodoFields.username} = ?',
      whereArgs: [todo.title, todo.username],
    );
  }
}
