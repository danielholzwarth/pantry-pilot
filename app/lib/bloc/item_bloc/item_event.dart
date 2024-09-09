part of 'item_bloc.dart';

@immutable
abstract class ItemEvent {}

class PostItem extends ItemEvent {
  final int storageID;
  final String name;
  final int quantity;
  final String? details;
  final String? barCode;
  final int? targetQuantity;

  PostItem({
    required this.storageID,
    required this.name,
    required this.quantity,
    this.details,
    this.barCode,
    this.targetQuantity,
  });
}

class PatchItem extends ItemEvent {
  final int itemID;
  final String? name;
  final int? quantity;
  final String? details;
  final String? barCode;
  final int? targetQuantity;

  PatchItem({
    required this.itemID,
    this.name,
    this.quantity,
    this.details,
    this.barCode,
    this.targetQuantity,
  });
}
