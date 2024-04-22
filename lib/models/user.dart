//Translates to user table in SQL

const String userTable = 'user';

//Used in todo_database to refer to column names
class UserFields {
  static const String username = 'username';
  static const String name = 'name';
  static final List<String> allFields = [username, name];
}

class User {
  //Object that populates user table
  final String username;
  String name;

//Constructor
  User({
    required this.username,
    required this.name,
  });

//Used to convert User object to Json file
  Map<String, Object?> toJson() => {
        UserFields.username: username,
        UserFields.name: name,
      };

//Used to get data back from database
  static User fromJson(Map<String, Object?> json) => User(
      username: json[UserFields.username] as String,
      name: json[UserFields.name] as String);
}
