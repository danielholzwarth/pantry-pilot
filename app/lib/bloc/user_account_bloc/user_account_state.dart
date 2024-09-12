part of 'user_account_bloc.dart';

@immutable
abstract class UserAccountState {}

class UserAccountInitial extends UserAccountState {}

class UserAccountPosting extends UserAccountState {}

class UserAccountPosted extends UserAccountState {}

class UserAccountLoggingIn extends UserAccountState {}

class UserAccountLoggedIn extends UserAccountState {}

class UserAccountError extends UserAccountState {
  final String error;

  UserAccountError({
    required this.error,
  });
}
