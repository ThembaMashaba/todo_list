//Translates to To-Do table in SQL
const String todoTable = 'todo';

//Translates to the columns in the to-do database
class TodoFields {
  static const String username = 'username';
  static const String title = 'title';
  static const String done = 'done';
  static const String created = 'created';
  static final List<String> allFields = [username, title, done, created];
}

//Object that populates the to-do table
class Todo {
  final String username;
  final String title;
  bool done;
  final DateTime created;

//constructor
  Todo({
    required this.username,
    required this.title,
    this.done = false,
    required this.created,
  });

//Converts To-do object to Json map
  Map<String, Object?> toJson() => {
        TodoFields.username: username,
        TodoFields.title: title,
        TodoFields.done: done ? 1 : 0,
        TodoFields.created: created.toIso8601String(),
      };

//Used to get data (Json) back from database
  static Todo fromJson(Map<String, Object?> json) => Todo(
        username: json[TodoFields.username] as String,
        title: json[TodoFields.title] as String,
        done: json[TodoFields.done] == 1 ? true : false,
        created: DateTime.parse(json[TodoFields.created] as String),
      );

//Compare to stop duplicates -> override equals operator
  @override
  bool operator ==(covariant Todo todo) {
    return (username == todo.username) &&
        (title.toUpperCase().compareTo(todo.title.toUpperCase()) == 0);
  }

  @override
  int get hashCode {
    return Object.hash(username, title);
  }
}
