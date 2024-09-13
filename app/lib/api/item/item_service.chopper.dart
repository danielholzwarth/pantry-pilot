// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ItemService extends ItemService {
  _$ItemService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ItemService;

  @override
  Future<Response<dynamic>> postItem(
    String storageJWT,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/items');
    final Map<String, String> $headers = {
      'storage-jwt': storageJWT,
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> patchItem(
    String storageJWT,
    int itemID,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/items/${itemID}');
    final Map<String, String> $headers = {
      'storage-jwt': storageJWT,
    };
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteItem(
    String storageJWT,
    int itemID,
  ) {
    final Uri $url = Uri.parse('/items/${itemID}');
    final Map<String, String> $headers = {
      'storage-jwt': storageJWT,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
