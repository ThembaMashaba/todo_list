// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_todo_app_22apr/routes/routes.dart';
import 'package:flutter_todo_app_22apr/services/todo_service.dart';
import 'package:flutter_todo_app_22apr/services/user_service.dart';
import 'package:flutter_todo_app_22apr/widgets/app_textfield.dart';
import 'package:flutter_todo_app_22apr/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Text(
                    'To-Do App',
                    style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                AppTextField(
                    controller: usernameController,
                    labelText: 'Please enter username'),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (usernameController.text.isEmpty) {
                        showSnackBar(
                            context, 'Please enter the username first.');
                      } else {
                        String result = await context
                            .read<UserService>()
                            .getUser(usernameController.text.trim());
                        if (result != 'OK') {
                          showSnackBar(context, result);
                        } else {
                          String username =
                              context.read<UserService>().currentUser.username;
                          context.read<TodoService>().getTodos(username);
                          Navigator.of(context)
                              .pushNamed(RouteManager.todoPage);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteManager.registerPage);
                  },
                  child: Text(
                    'New? Register here',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
