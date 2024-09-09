import 'package:app/api/storage/storage_service.dart';
import 'package:app/helper/jwt_helper.dart';
import 'package:app/models/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'storage_event.dart';
part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final StorageService _storageService = StorageService.create();

  StorageBloc() : super(StorageInitial()) {
    on<PostStorage>(_onPostStorage);
    on<GetStorages>(_onGetStorages);
  }

  void _onPostStorage(PostStorage event, Emitter<StorageState> emit) async {
    emit(StoragePosting());

    String? currentJWT = JWTHelper.getActiveJWT();
    if (currentJWT == null) {
      debugPrint("No active JWT found!");
      return;
    }

    final response = await _storageService.postStorage(currentJWT, {"name": event.name});

    if (!response.isSuccessful) {
      emit(StorageError(error: response.error.toString()));
      return;
    }

    if (response.body != null) {
      JWTHelper.saveJWTsFromResponse(response);

      Storage storage = Storage.fromJson(response.body);
      emit(StoragePosted(storage: storage));
    }
  }

  void _onGetStorages(GetStorages event, Emitter<StorageState> emit) async {
    emit(StoragesLoading());

    String? currentJWT = JWTHelper.getActiveJWT();
    if (currentJWT == null) {
      debugPrint("No active JWT found!");
      return;
    }

    final response = await _storageService.getStorages(currentJWT);

    if (!response.isSuccessful) {
      emit(StorageError(error: response.error.toString()));
      return;
    }

    if (response.body != null) {
      JWTHelper.saveJWTsFromResponse(response);

      List<Storage> storages = [];
      if (response.body != "null") {
        storages = List<Storage>.from(response.body.map((json) {
          return Storage.fromJson(json);
        }));
      }

      emit(StoragesLoaded(storages: storages));
    }
  }
}
