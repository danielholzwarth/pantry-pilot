part of 'storage_bloc.dart';

@immutable
abstract class StorageState {}

class StorageInitial extends StorageState {}

class StoragesLoading extends StorageState {}

class StoragesLoaded extends StorageState {
  final List<Storage> storages;

  StoragesLoaded({
    required this.storages,
  });
}

class StoragePosting extends StorageState {}

class StoragePosted extends StorageState {
  final Storage storage;

  StoragePosted({
    required this.storage,
  });
}

class StorageError extends StorageState {
  final String error;

  StorageError({
    required this.error,
  });
}
