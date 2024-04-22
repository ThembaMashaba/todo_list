// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_todo_app_22apr/widgets/app_progressIndicator.dart';
import 'package:flutter_todo_app_22apr/models/user.dart';
import 'package:flutter_todo_app_22apr/services/user_service.dart';
import 'package:flutter_todo_app_22apr/widgets/app_textfield.dart';
import 'package:flutter_todo_app_22apr/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController usernameController;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Text(
                        'Register User',
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    //Check if user exists after typing in username textfield
                    Focus(
                      onFocusChange: (value) async {
                        if (!value) {
                          String result = await context
                              .read<UserService>()
                              .checkIfUserExists(
                                  usernameController.text.trim());
                          if (result == 'OK') {
                            context.read<UserService>().userExists = true;
                          } else {
                            context.read<UserService>().userExists = false;
                            if (!result.contains(
                                'The user does not exist in the database. Please register first.')) {
                              showSnackBar(context, result);
                            }
                          }
                        }
                      },
                      child: AppTextField(
                          controller: usernameController,
                          labelText: 'Please enter your username'),
                    ),
                    Selector<UserService, bool>(
                      selector: (context, value) => value.userExists,
                      builder: (context, value, child) {
                        return value
                            ? const Text(
                                'username exists, please choose another',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800),
                              )
                            : Container();
                      },
                    ),
                    AppTextField(
                        controller: nameController,
                        labelText: 'Please enter your name'),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (usernameController.text.isEmpty ||
                              nameController.text.isEmpty) {
                            showSnackBar(context, 'Please enter all fields!');
                          } else {
                            User user = User(
                              username: usernameController.text.trim(),
                              name: nameController.text.trim(),
                            );
                            String result = await context
                                .read<UserService>()
                                .createUser(user);
                            if (result != 'OK') {
                              showSnackBar(context, result);
                            } else {
                              showSnackBar(
                                  context, 'New user successfully created!');
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 30,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          Selector<UserService, bool>(
            selector: (context, value) => value.busyCreate,
            builder: (context, value, child) {
              return value ? const AppProgressIndicator() : Container();
            },
          ),
        ],
      ),
    );
  }
}
