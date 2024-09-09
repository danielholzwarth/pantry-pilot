part of 'user_account_bloc.dart';

@immutable
abstract class UserAccountState {}

class UserAccountInitial extends UserAccountState {}

class UserAccountPosting extends UserAccountState {}

class UserAccountPosted extends UserAccountState {
  final UserAccount userAccount;

  UserAccountPosted({
    required this.userAccount,
  });
}

class UserAccountLoggingIn extends UserAccountState {}

class UserAccountLoggedIn extends UserAccountState {
  final UserAccount userAccount;

  UserAccountLoggedIn({
    required this.userAccount,
  });
}

class UserAccountError extends UserAccountState {
  final String error;

  UserAccountError({
    required this.error,
  });
}
