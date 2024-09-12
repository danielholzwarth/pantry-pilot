part of 'item_bloc.dart';

@immutable
abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemPosting extends ItemState {}

class ItemPosted extends ItemState {}

class ItemPatching extends ItemState {}

class ItemPatched extends ItemState {}

class ItemError extends ItemState {
  final String error;

  ItemError({
    required this.error,
  });
}
