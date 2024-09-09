import 'package:app/bloc/user_account_bloc/user_account_bloc.dart';
import 'package:app/helper/helper.dart';
import 'package:app/widgets/storage_button.dart';
import 'package:app/widgets/storage_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserAccountBloc userAccountBloc = UserAccountBloc();

  void loginUser() async {
    if (emailController.text.isEmpty) {
      displayMessageToUser("Email must not be empty", context);
      return;
    }

    if (passwordController.text.isEmpty) {
      displayMessageToUser("Password must not be empty", context);
      return;
    }

    userAccountBloc.add(LoginUserAccount(
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

            if (state is UserAccountLoggedIn) {
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot Password?",
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      StorageButton(
                        text: "Login",
                        onTap: loginUser,
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              "Register here",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
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
