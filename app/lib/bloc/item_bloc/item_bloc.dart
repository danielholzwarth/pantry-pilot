import 'package:app/api/item/item_service.dart';
import 'package:app/helper/jwt_helper.dart';
import 'package:app/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemService _itemService = ItemService.create();

  ItemBloc() : super(ItemInitial()) {
    on<PostItem>(_onPostItem);
    on<PatchItem>(_onPatchItem);
  }

  void _onPostItem(PostItem event, Emitter<ItemState> emit) async {
    emit(ItemPosting());

    String? currentJWT = JWTHelper.getActiveJWT();
    if (currentJWT == null) {
      debugPrint("No active JWT found!");
      return;
    }

    final response = await _itemService.postItem(currentJWT, {
      "name": event.name,
    });

    if (!response.isSuccessful) {
      emit(ItemError(error: response.error.toString()));
      return;
    }

    if (response.body != null) {
      JWTHelper.saveJWTsFromResponse(response);

      Item item = Item.fromJson(response.body);
      emit(ItemPosted(item: item));
    }
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
    });

    if (!response.isSuccessful) {
      emit(ItemError(error: response.error.toString()));
      return;
    }

    if (response.body != null) {
      JWTHelper.saveJWTsFromResponse(response);

      Item item = Item.fromJson(response.body);
      emit(ItemPatched(item: item));
    }
  }
}
