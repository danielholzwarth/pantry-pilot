import 'package:app/helper/settings_helper.dart';
import 'package:chopper/chopper.dart';

part 'storage_service.chopper.dart';

@ChopperApi(baseUrl: '/storages')
abstract class StorageService extends ChopperService {
  @Post()
  Future<Response> postStorage(
    @Header('storage-jwt') String storageJWT,
    @Body() Map<String, dynamic> body,
  );

  @Get()
  Future<Response> getStorages(
    @Header('storage-jwt') String storageJWT,
  );

  @Get(path: '/{keyword}')
  Future<Response> getStoragesSearch(
    @Header('storage-jwt') String storageJWT,
    @Path('keyword') String keyword,
  );

  @Patch(path: '/{storageID}')
  Future<Response> patchStorage(
    @Header('storage-jwt') String storageJWT,
    @Path('storageID') int itemID,
    @Body() Map<String, dynamic> body,
  );

  @Delete(path: '/{storageID}')
  Future<Response> deleteStorage(
    @Header('storage-jwt') String storageJWT,
    @Path('storageID') int itemID,
  );

  static StorageService create() {
    final client = ChopperClient(
        baseUrl: Uri.parse(SettingsHelper.getCurrentURL()),
        services: [
          _$StorageService(),
        ],
        converter: const JsonConverter());
    return _$StorageService(client);
  }
}
