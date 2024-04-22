// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, await_only_futures, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_app_22apr/models/todo.dart';
import 'package:flutter_todo_app_22apr/models/user.dart';
import 'package:flutter_todo_app_22apr/services/todo_service.dart';
import 'package:flutter_todo_app_22apr/services/user_service.dart';
import 'package:flutter_todo_app_22apr/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TextEditingController todoController;

  @override
  void initState() {
    super.initState();
    todoController = TextEditingController();
  }

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Text('Create a new To-Do'),
                              content: TextField(
                                decoration: const InputDecoration(
                                    hintText: 'Please enter To-Do'),
                                controller: todoController,
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: const Text('Save'),
                                  onPressed: () async {
                                    if (todoController.text.isEmpty) {
                                      showSnackBar(context,
                                          'Please enter a to-do first.');
                                    } else {
                                      String username = await context
                                          .read<UserService>()
                                          .currentUser
                                          .username;
                                      Todo todo = Todo(
                                        username: username,
                                        title: todoController.text.trim(),
                                        created: DateTime.now(),
                                      );
                                      if (context
                                          .read<TodoService>()
                                          .todos
                                          .contains(todo)) {
                                        showSnackBar(context,
                                            'Duplicate value. Please enter a different to-do');
                                      } else {
                                        String result = await context
                                            .read<TodoService>()
                                            .createTodo(todo);
                                        if (result == 'OK') {
                                          showSnackBar(context,
                                              'New to-do added successfully!');
                                          todoController.text = '';
                                        } else {
                                          showSnackBar(context, result);
                                        }
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Selector<UserService, User>(
                  selector: (context, value) => value.currentUser,
                  builder: (context, value, child) {
                    return Text(
                      '${value.name}\'s Todo list',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w200,
                          color: Colors.white),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: Consumer<TodoService>(
                    builder: (context, value, child) {
                      return ListView.builder(
                        itemCount: value.todos.length,
                        itemBuilder: (context, index) {
                          return TodoCard(
                            todo: value.todos[index],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  const TodoCard({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      child: Slidable(
        child: CheckboxListTile(
          checkColor: Colors.green,
          activeColor: Colors.green,
          value: todo.done,
          onChanged: (value) async {
            String result =
                await context.read<TodoService>().toggleTodoDone(todo);
            if (result != 'OK') {
              showSnackBar(context, result);
            }
          },
          subtitle: Text(
            '${todo.created.day}/${todo.created.month}/${todo.created.year}',
            style: const TextStyle(color: Colors.white),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              decoration:
                  todo.done ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ),
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SlidableAction(
            onPressed: (context) async {
              String result =
                  await context.read<TodoService>().deleteTodo(todo);
              if (result == 'OK') {
                showSnackBar(context, 'To-do deleted!');
              } else {
                showSnackBar(context, result);
              }
            },
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ]),
      ),
    );
  }
}
