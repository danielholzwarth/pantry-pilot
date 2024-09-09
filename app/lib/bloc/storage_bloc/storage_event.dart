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
