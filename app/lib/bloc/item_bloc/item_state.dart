part of 'item_bloc.dart';

@immutable
abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemPosting extends ItemState {}

class ItemPosted extends ItemState {
  final Item item;

  ItemPosted({
    required this.item,
  });
}

class ItemPatching extends ItemState {}

class ItemPatched extends ItemState {
  final Item item;

  ItemPatched({
    required this.item,
  });
}

class ItemError extends ItemState {
  final String error;

  ItemError({
    required this.error,
  });
}
