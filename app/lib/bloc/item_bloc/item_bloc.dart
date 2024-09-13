import 'package:app/api/item/item_service.dart';
import 'package:app/helper/jwt_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemService _itemService = ItemService.create();

  ItemBloc() : super(ItemInitial()) {
    on<PostItem>(_onPostItem);
    on<PatchItem>(_onPatchItem);
    on<DeleteItem>(_onDeleteItem);
  }

  void _onPostItem(PostItem event, Emitter<ItemState> emit) async {
    emit(ItemPosting());

    String? currentJWT = JWTHelper.getActiveJWT();
    if (currentJWT == null) {
      debugPrint("No active JWT found!");
      return;
    }

    final response = await _itemService.postItem(currentJWT, {
      "storageID": event.storageID,
      "name": event.name,
      "quantity": event.quantity,
      "targetQuantity": event.targetQuantity,
      "details": event.details,
      "barcode": event.barCode,
    });

    if (!response.isSuccessful) {
      emit(ItemError(error: response.error.toString()));
      return;
    }

    JWTHelper.saveJWTsFromResponse(response);
    emit(ItemPosted());
  }

  void _onPatchItem(PatchItem event, Emitter<ItemState> emit) async {
    emit(ItemPatching());

    String? currentJWT = JWTHelper.getActiveJWT();
    if (currentJWT == null) {
      debugPrint("No active JWT found!");
      return;
    }

    final response = await _itemService.patchItem(currentJWT, event.itemID, {
      "name": event.name,
      "storageID": event.storageID,
      'quantity': event.quantity,
      'targetQuantity': event.targetQuantity,
      'details': event.details,
      'barCode': event.barCode,
    });

    if (!response.isSuccessful) {
      emit(ItemError(error: response.error.toString()));
      return;
    }

    JWTHelper.saveJWTsFromResponse(response);
    emit(ItemPatched());
  }

  void _onDeleteItem(DeleteItem event, Emitter<ItemState> emit) async {
    emit(ItemDeleting());

    String? currentJWT = JWTHelper.getActiveJWT();
    if (currentJWT == null) {
      debugPrint("No active JWT found!");
      return;
    }

    final response = await _itemService.deleteItem(currentJWT, event.itemID);

    if (!response.isSuccessful) {
      emit(ItemError(error: response.error.toString()));
      return;
    }

    JWTHelper.saveJWTsFromResponse(response);
    emit(ItemDeleted());
  }
}
