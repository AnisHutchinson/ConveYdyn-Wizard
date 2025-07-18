import 'package:shared_preferences/shared_preferences.dart';

// Save an integer value to 'counter' key.
// Obtain shared preferences.

class SharedPreferenceHelper {
  static String PianoCookkey = "PianoCook";
  static String Signalkey = "Signal";
  static String Marketkey = "Market";
  static String Unitkey = "Unit";
  static String Languagekey = "Language";
  static String AcceptTermskey = "AgreeToTerms";
  static String AgreeToContactekey = "AgreeToContact";
  static String UnitListkey = "UnitList";
  static String UnitIndexkey = "UnitIndex";

  static String Companykey = "Company";
  static String FirstNamekey = "FirstName";
  static String LastNamekey = "LastName";
  static String Emailkey = "Email";
  static String Numberkey = "Number";

  static String SettingPopupKey = "SettingPopupSeen";

  Future<void> saveAccount(
    String company,
    lastName,
    firstName,
    email,
    int? phoneNumber,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Companykey, company);
    await prefs.setString(LastNamekey, lastName);
    await prefs.setString(FirstNamekey, firstName);
    await prefs.setString(Emailkey, email);
    //await prefs.setInt(Numberkey, phoneNumber);
    if (phoneNumber != null) {
      await prefs.setInt(Numberkey, phoneNumber);
    } else {
      await prefs.remove(Numberkey); // Supprime l'ancienne valeur si elle existe
    }
  }

  Future<List<dynamic>> loadAccount() async {
    final prefs = await SharedPreferences.getInstance();
    List<dynamic> userCoordinates = [];
    userCoordinates.add(await prefs.getString(Companykey));
    userCoordinates.add(await prefs.getString(FirstNamekey));
    userCoordinates.add(await prefs.getString(LastNamekey));
    userCoordinates.add(await prefs.getString(Emailkey));
    userCoordinates.add(await prefs.getInt(Numberkey));
    return userCoordinates;
  }

  Future<void> saveSettingPopupSeen(bool seen) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SettingPopupKey, seen);
  }

  Future<bool?> loadSettingPopupSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SettingPopupKey)??false;
  }

  Future<void> savedPianoCook(bool chose) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PianoCookkey, chose);
  }

  Future<void> savedSignalPush(bool chose) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Signalkey, chose);
  }

  Future<void> savedAcceptTerms(bool chose) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AcceptTermskey, chose);
  }

  Future<void> savedAgreeToContact(bool chose) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AgreeToContactekey, chose);
  }

  Future<void> savedMarket(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Marketkey, value);
  }

  Future<void> savedUnit(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Unitkey, value);
  }

  Future<void> savedLanguage(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Languagekey, value);
  }

  Future<void> savedListUnit(List<String> UnitList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(UnitListkey, UnitList);
  }

  Future<void> savedUnitIndex(int UnitIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(UnitIndexkey, UnitIndex);
  }

  Future<bool?> loadPianoCook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PianoCookkey);
  }

  Future<bool?> loadSignalPush() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Signalkey);
  }

  Future<bool?> loadAcceptTerms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AcceptTermskey);
  }

  Future<bool?> loadAgreeToContact() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AgreeToContactekey);
  }

  Future<String?> loadMarket() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Marketkey);
  }

  Future<String?> loadUnit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Unitkey);
  }

  Future<String?> loadLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Languagekey);
  }

  Future<List<String>?> LoadUnitList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(UnitListkey);
  }

  Future<int?> LoadUnitIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(UnitIndexkey);
  }
}
