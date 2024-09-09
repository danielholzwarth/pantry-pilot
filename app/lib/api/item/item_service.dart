import 'package:app/helper/settings_helper.dart';
import 'package:chopper/chopper.dart';

part 'item_service.chopper.dart';

@ChopperApi(baseUrl: '/items')
abstract class ItemService extends ChopperService {
  @Post()
  Future<Response> postItem(
    @Header('flexus-jwt') String flexusJWTAccess,
    @Body() Map<String, dynamic> body,
  );

  @Patch(path: '/{itemID}')
  Future<Response> patchItem(
    @Header('flexus-jwt') String flexusJWTAccess,
    @Path('itemID') int itemID,
    @Body() Map<String, dynamic> body,
  );

  static ItemService create() {
    final client = ChopperClient(
        baseUrl: Uri.parse(SettingsHelper.getCurrentURL()),
        services: [
          _$ItemService(),
        ],
        converter: const JsonConverter());
    return _$ItemService(client);
  }
}
