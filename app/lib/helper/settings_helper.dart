class SettingsHelper {
  static String serverURL = 'http://213.109.162.134:8080'; //0
  static String localPhoneURL = 'http://10.0.2.2:8080'; //1
  static String localWindowsURL = 'http://192.168.178.82:8080'; //2 not working?!
  static int currentURLIndex = 1;

  static String getCurrentURL() {
    switch (currentURLIndex) {
      case 0:
        return serverURL;

      case 1:
        return localPhoneURL;

      case 2:
        return localWindowsURL;

      default:
        return "not existing";
    }
  }
}
