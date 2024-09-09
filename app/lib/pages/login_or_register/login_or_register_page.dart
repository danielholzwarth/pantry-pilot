import 'package:app/pages/home_page.dart';
import 'package:app/pages/login_or_register/login_page.dart';
import 'package:app/pages/login_or_register/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterPage extends StatefulWidget {
  final bool isLogin;

  const LoginOrRegisterPage({
    super.key,
    required this.isLogin,
  });

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {

  bool showLoginPage = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    showLoginPage = widget.isLogin;
    super.initState();
  }

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return const HomePage();
    }

    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    }

    return RegisterPage(onTap: togglePages);
  }
}
