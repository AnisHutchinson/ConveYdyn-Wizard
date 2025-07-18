import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:conveydyn_wizard/Presentation/widgets/settings.dart';
import 'package:conveydyn_wizard/Service/DataManager.dart';
import 'package:conveydyn_wizard/Service/SharedPref.dart';
import 'package:conveydyn_wizard/Utils/constant.dart';
import 'dart:convert';

import 'package:conveydyn_wizard/Utils/helper.dart';


class SettingsPopupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<DataManager>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                "Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          // Contenu
          settingswidget(),

          // Bouton OK
          Container(
            width: double.infinity,
            color: const Color(0xFF142559),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Center(
              child: FilledButton.icon(
                onPressed: () async {
                  dataProvider.updatePopupSettings(true);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('popup_seen', true);
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(MediaQuery.of(context).size.width / 6, 45),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                label: const Text(
                  "Ok",
                  style: TextStyle(
                    fontFamily: "CustomFont",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                icon: const Icon(Icons.check, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showSettingsPopupWithBlur(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Settings",
    barrierColor: Colors.black.withOpacity(0.2), // fond assombri flouté
    transitionDuration: const Duration(milliseconds: 800),
    pageBuilder: (_, __, ___) => SettingsDialogWithBlur(),
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


class SettingsDialogWithBlur extends StatelessWidget {
  const SettingsDialogWithBlur({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Flou de l'arrière-plan
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY:2.5),
              child: Container(color: Colors.black.withOpacity(0)),
            ),
            /*Container(
              color: Colors.black.withOpacity(0.2), // grisage simple sans flou
            ),*/
            // Contenu du popup
            Center(
              child: SettingsPopupPage(), // Ton widget de popup réel
            ),
          ],
        ),
      ),
    );
  }
}
