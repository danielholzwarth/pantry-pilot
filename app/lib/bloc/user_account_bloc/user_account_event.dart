part of 'user_account_bloc.dart';

@immutable
abstract class UserAccountEvent {}

class PostUserAccount extends UserAccountEvent {
  final String email;
  final String password;

  PostUserAccount({
    required this.email,
    required this.password,
  });
}

class LoginUserAccount extends UserAccountEvent {
  final String email;
  final String password;

  LoginUserAccount({
    required this.email,
    required this.password,
  });
}