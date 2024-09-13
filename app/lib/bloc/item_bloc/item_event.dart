part of 'item_bloc.dart';

@immutable
abstract class ItemEvent {}

class PostItem extends ItemEvent {
  final int storageID;
  final String name;
  final int quantity;
  final String details;
  final String barCode;
  final int targetQuantity;

  PostItem({
    required this.storageID,
    required this.name,
    required this.quantity,
    required this.details,
    required this.barCode,
    required this.targetQuantity,
  });
}

class PatchItem extends ItemEvent {
  final int itemID;
  final int oldStorageID;
  final int storageID;
  final String name;
  final int quantity;
  final String details;
  final String barCode;
  final int targetQuantity;

  PatchItem({
    required this.itemID,
    required this.oldStorageID,
    required this.storageID,
    required this.name,
    required this.quantity,
    required this.details,
    required this.barCode,
    required this.targetQuantity,
  });
}

class DeleteItem extends ItemEvent {
  final int itemID;

  DeleteItem({
    required this.itemID,
  });
}
