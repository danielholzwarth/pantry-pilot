import 'package:app/api/user_account/user_account_service.dart';
import 'package:app/helper/jwt_helper.dart';
import 'package:app/models/user_account.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'user_account_event.dart';
part 'user_account_state.dart';

class UserAccountBloc extends Bloc<UserAccountEvent, UserAccountState> {
  final UserAccountService _userAccountService = UserAccountService.create();

  UserAccountBloc() : super(UserAccountInitial()) {
    on<PostUserAccount>(_onPostUserAccount);
    on<LoginUserAccount>(_onLoginUserAccount);
  }

  void _onPostUserAccount(PostUserAccount event, Emitter<UserAccountState> emit) async {
    emit(UserAccountPosting());

    final response = await _userAccountService.postUserAccount({
      "email": event.email,
      "password": event.password,
    });

    if (!response.isSuccessful) {
      emit(UserAccountError(error: response.error.toString()));
      return;
    }

    if (response.body != null) {
      JWTHelper.saveJWTsFromResponse(response);

      UserAccount userAccount = UserAccount.fromJson(response.body);
      emit(UserAccountPosted(userAccount: userAccount));
    }
  }

  void _onLoginUserAccount(LoginUserAccount event, Emitter<UserAccountState> emit) async {
    emit(UserAccountLoggingIn());

    final response = await _userAccountService.loginUserAccount({
      "email": event.email,
      "password": event.password,
    });

    if (!response.isSuccessful) {
      emit(UserAccountError(error: response.error.toString()));
      return;
    }

    if (response.body != null) {
      JWTHelper.saveJWTsFromResponse(response);

      UserAccount userAccount = UserAccount.fromJson(response.body);
      emit(UserAccountLoggedIn(userAccount: userAccount));
    }
  }
}
