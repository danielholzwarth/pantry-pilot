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

class StoragePosted extends StorageState {}

class StoragePatching extends StorageState {}

class StoragePatched extends StorageState {}

class StorageDeleting extends StorageState {}

class StorageDeleted extends StorageState {}

class StorageError extends StorageState {
  final String error;

  StorageError({
    required this.error,
  });
}
