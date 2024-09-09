import 'package:app/bloc/user_account_bloc/user_account_bloc.dart';
import 'package:app/helper/helper.dart';
import 'package:app/widgets/storage_button.dart';
import 'package:app/widgets/storage_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final UserAccountBloc userAccountBloc = UserAccountBloc();

  void registerUser() async {
    if (emailController.text.isEmpty) {
      displayMessageToUser("Email must not be empty", context);
      return;
    }

    if (passwordController.text.isEmpty) {
      displayMessageToUser("Password must not be empty", context);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      displayMessageToUser("Passwords don't match!", context);
      return;
    }

    userAccountBloc.add(PostUserAccount(
      email: emailController.text,
      password: passwordController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: BlocConsumer(
          bloc: userAccountBloc,
          listener: (context, state) {
            if (state is UserAccountError) {
              displayMessageToUser("Error occurred: ${state.error}", context);
            }

            if (state is UserAccountPosted) {
              Navigator.pushNamed(context, "/home_page");
            }
          },
          builder: (context, state) {
            if (state is UserAccountPosting) {
              return const CircularProgressIndicator();
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.storage,
                        size: 80,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "P A N T R Y    P I L O T",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 50),
                      StorageTextfield(
                        hintText: "Email",
                        obscureText: false,
                        controller: emailController,
                      ),
                      const SizedBox(height: 10),
                      StorageTextfield(
                        hintText: "Password",
                        obscureText: true,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 10),
                      StorageTextfield(
                        hintText: "Confirm password",
                        obscureText: true,
                        controller: confirmPasswordController,
                      ),
                      const SizedBox(height: 25),
                      StorageButton(
                        text: "Register",
                        onTap: registerUser,
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              "Login here",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
