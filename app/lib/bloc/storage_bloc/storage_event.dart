part of 'storage_bloc.dart';

@immutable
abstract class StorageEvent {}

class PostStorage extends StorageEvent {
  final String name;

  PostStorage({
    required this.name,
  });
}

class GetStorages extends StorageEvent {}

class GetStoragesSearch extends StorageEvent {
  final String keyword;

  GetStoragesSearch({
    required this.keyword,
  });
}

class PatchStorage extends StorageEvent {
  final int storageID;
  final String name;

  PatchStorage({
    required this.storageID,
    required this.name,
  });
}

class DeleteStorage extends StorageEvent {
  final int storageID;

  DeleteStorage({
    required this.storageID,
  });
}
