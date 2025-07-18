import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conveydyn_wizard/Component/settingPopPup.dart';
import 'package:conveydyn_wizard/Component/showCookiesDialog.dart' hide SettingsDialogWithBlur, showSettingsPopupWithBlur;
import 'package:conveydyn_wizard/Service/DataManager.dart';
import 'package:conveydyn_wizard/Service/SharedPref.dart';
//import 'package:open_mail_app/open_mail_app.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../Service/customroute.dart';

class HelpersFunct {
  Future<void> launch_Url(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchCaller() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '+33-247-483-999');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false; // Pas de réseau du tout
    }

    try {
      // Vérifie si Internet est vraiment accessible
      final result = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> sendEmail(BuildContext context) async {
    bool hasInternet = await isConnectedToInternet();

    if (!hasInternet) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No connection was")));
      return;
    }

    var DataProvider = Provider.of<DataManager>(context, listen: false);

    final Email email = Email(
      body: ' ?',
      subject: 'Essay subject',
      recipients: [DataProvider.email],
      //cc: ['anismekbal11@gmail.com'],
      //bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(platformResponse)));
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> checkAndShowSettingPopup(BuildContext context) async {
    var dataProvider = Provider.of<DataManager>(context, listen: false);
    bool alreadySeen = dataProvider.settingPopPupSeen;

    print("Mise a joure au DEbut : $alreadySeen");

    // 2 eme méthode 

    final prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('popup_seen') ?? false;

    print("nouvelle méthode with swaaaaaaaap: $alreadySeen");

    if (!seen) {
      showSettingsPopupWithBlur(context);
    }
  }

  Future<void> checkAndShowConsent(BuildContext context) async {
    var dataProvider = Provider.of<DataManager>(context, listen: false);
    bool acceptTerms = dataProvider.acceptTerms;

    print("Accept terms in function: $acceptTerms");

    //final SharedPreferenceHelper prefs = SharedPreferenceHelper();
    //final accepted = await prefs.loadAcceptTerms() ?? false;
    final prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('pop_conf') ?? false;

    if (!seen) {
      showCookiesDialogWithBlur(context);
    }
  }
}
