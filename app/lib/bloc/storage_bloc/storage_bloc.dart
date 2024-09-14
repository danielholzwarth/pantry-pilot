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
    on<GetStoragesSearch>(_onGetStoragesSearch);
    on<PatchStorage>(_onPatchStorage);
    on<DeleteStorage>(_onDeleteStorage);
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

    JWTHelper.saveJWTsFromResponse(response);
    emit(StoragePosted());
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
      if (response.bodyString.isNotEmpty) {
        storages = List<Storage>.from(response.body.map((json) {
          return Storage.fromJson(json);
        }));
      }

      emit(StoragesLoaded(storages: storages));
    }
  }

  void _onGetStoragesSearch(GetStoragesSearch event, Emitter<StorageState> emit) async {
    emit(StoragesLoadingSearch());

    String? currentJWT = JWTHelper.getActiveJWT();
    if (currentJWT == null) {
      debugPrint("No active JWT found!");
      return;
    }

    final response = await _storageService.getStoragesSearch(currentJWT, event.keyword);

    if (!response.isSuccessful) {
      emit(StorageError(error: response.error.toString()));
      return;
    }

    if (response.body != null) {
      JWTHelper.saveJWTsFromResponse(response);

      List<Storage> storages = [];
      if (response.bodyString.isNotEmpty) {
        storages = List<Storage>.from(response.body.map((json) {
          return Storage.fromJson(json);
        }));
      }

      emit(StoragesLoadedSearch(storages: storages));
    }
  }

  void _onPatchStorage(PatchStorage event, Emitter<StorageState> emit) async {
    emit(StoragePatching());

    await Future.delayed(Durations.extralong4);

    String? currentJWT = JWTHelper.getActiveJWT();
    if (currentJWT == null) {
      debugPrint("No active JWT found!");
      return;
    }

    final response = await _storageService.patchStorage(currentJWT, event.storageID, {"name": event.name});

    if (!response.isSuccessful) {
      emit(StorageError(error: response.error.toString()));
      return;
    }

    JWTHelper.saveJWTsFromResponse(response);
    emit(StoragePatched());
  }

  void _onDeleteStorage(DeleteStorage event, Emitter<StorageState> emit) async {
    emit(StorageDeleting());

    await Future.delayed(Durations.extralong4);

    String? currentJWT = JWTHelper.getActiveJWT();
    if (currentJWT == null) {
      debugPrint("No active JWT found!");
      return;
    }

    final response = await _storageService.deleteStorage(currentJWT, event.storageID);

    if (!response.isSuccessful) {
      emit(StorageError(error: response.error.toString()));
      return;
    }

    JWTHelper.saveJWTsFromResponse(response);
    emit(StorageDeleted());
  }
}
