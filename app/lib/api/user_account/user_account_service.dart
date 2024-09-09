import 'package:app/helper/settings_helper.dart';
import 'package:chopper/chopper.dart';

part 'user_account_service.chopper.dart';

@ChopperApi(baseUrl: '/user_accounts')
abstract class UserAccountService extends ChopperService {
  @Post()
  Future<Response> postUserAccount(
    @Body() Map<String, dynamic> body,
  );

  @Get(path: '/login')
  Future<Response> loginUserAccount(
    @Body() Map<String, dynamic> body,
  );

  static UserAccountService create() {
    final client = ChopperClient(
        baseUrl: Uri.parse(SettingsHelper.getCurrentURL()),
        services: [
          _$UserAccountService(),
        ],
        converter: const JsonConverter());
    return _$UserAccountService(client);
  }
}
