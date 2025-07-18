import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:conveydyn_wizard/Service/DataManager.dart';
import 'package:conveydyn_wizard/Service/SharedPref.dart';
import 'package:conveydyn_wizard/Utils/constant.dart';
import 'dart:convert';

import 'package:conveydyn_wizard/Utils/helper.dart';


class CookieConsentDialog extends StatelessWidget {
  const CookieConsentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataManager>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Titre
          Container(
            width: double.infinity,
            color: const Color(0xFF142559),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Center(
              child: Text(
                "Terms of Use",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          // Contenu
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "By clicking on the 'OK' button, you indicate that you have read and fully accept Hutchinson's terms of use and privacy policy.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: "CustomFont",
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "To find out more:",
                  style: TextStyle(
                    fontFamily: "CustomFont",
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 7),
                GestureDetector(
                  onTap: () {
                    HelpersFunct().launch_Url(Constant_Url().url_terms_of_use);
                  },
                  child: const Text(
                    "Terms of Use",
                    style: TextStyle(
                      fontFamily: "CustomFont",
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      color: Color.fromARGB(255, 15, 34, 207),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bouton
          Container(
            width: double.infinity,
            color: const Color(0xFF142559),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Center(
              child: FilledButton.icon(
                onPressed: () async {
                  dataProvider.updateAcceptTerms(true);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('pop_conf', true);
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    // Mettre à jour l'état de l'application
                    HelpersFunct().checkAndShowSettingPopup(context);
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(MediaQuery.of(context).size.width / 6, 45),
                  ),
                ),
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text(
                  "Ok",
                  style: TextStyle(
                    fontFamily: "CustomFont",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


void showCookiesDialogWithBlur(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Cookies",
    barrierColor: Colors.black.withOpacity(0.2), // fond assombri flouté
    transitionDuration: const Duration(milliseconds: 800),
    pageBuilder: (_, __, ___) => CookiesDialogWithBlur(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1), // vient du bas
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(
          opacity: curvedAnimation,
          child: child,
        ),
      );
    },
  );
}

class CookiesDialogWithBlur extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY:2.5),
            child: Container(color: Colors.black.withOpacity(0)),
          ),
          CookieConsentDialog(),
        ],
      )  
    );
  }
}