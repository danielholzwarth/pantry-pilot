import 'package:chopper/chopper.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class JWTHelper {
  static void deleteJWT() {
    Box userBox = Hive.box('userBox');

    userBox.delete("storage-jwt-access");
    userBox.delete("storage-jwt-refresh");
  }

  static String? getActiveJWT() {
    Box userBox = Hive.box('userBox');

    String? jwt = userBox.get("storage-jwt-access");
    if (jwt != null) {
      bool isExpired = isTokenExpired(jwt);
      if (!isExpired) {
        return jwt;
      }
    }

    jwt = userBox.get("storage-jwt-refresh");
    if (jwt != null) {
      bool isExpired = isTokenExpired(jwt);
      if (!isExpired) {
        return jwt;
      }
    }

    return null;
  }

  static bool isTokenExpired(String token) {
    DateTime expiryDate = JwtDecoder.getExpirationDate(token);
    DateTime currentDate = DateTime.now();
    DateTime bufferTime = currentDate.add(const Duration(seconds: 30));
    return expiryDate.isBefore(bufferTime);
  }

  static void saveJWTsFromResponse(Response<dynamic> response) {
    Box userBox = Hive.box('userBox');

    final jwtAccess = response.headers["storage-jwt-access"];
    if (jwtAccess != null) {
      userBox.put("storage-jwt-access", jwtAccess);
    }

    final jwtRefresh = response.headers["storage-jwt-refresh"];
    if (jwtRefresh != null) {
      userBox.put("storage-jwt-refresh", jwtRefresh);
    }
  }
}
