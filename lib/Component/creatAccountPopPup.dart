import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:conveydyn_wizard/Presentation/widgets/settings.dart';
import 'package:conveydyn_wizard/Presentation/widgets/userAccount.dart';
import 'package:conveydyn_wizard/Service/DataManager.dart';
import 'package:conveydyn_wizard/Service/interaction.dart';
import 'package:conveydyn_wizard/Service/SharedPref.dart';
import 'package:conveydyn_wizard/Utils/Inpute.dart';
import 'package:conveydyn_wizard/Utils/shape.dart';
import 'package:conveydyn_wizard/Utils/constant.dart';
import 'dart:convert';
import '../Presentation/widgets/formWidget.dart';
import 'package:conveydyn_wizard/Utils/helper.dart';

void createAccountPopPup(BuildContext context) {
  
  /*var DataProvider = Provider.of<DataManager>(context, listen: false);
  final _formkey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  late String label;
  bool showError = false;
  */
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // carré
        ),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bordure bleue en haut avec titre
            Container(
              width: double.infinity,
              color: const Color(0xFF142559),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Center(
                child: Text(
                  "User account",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            // Contenu principal
            //UserAccountWidget(navigatorKey: navigatorKey,),
            Formwidget(),
            
            Container(
              width: double.infinity,
              color: const Color(0xFF142559),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Center(
                child: FilledButton.icon(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    shape: ButtonStyleButton.allOrNull<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    backgroundColor: ButtonStyleButton.allOrNull<Color>(
                      Colors.red,
                    ),
                    minimumSize: ButtonStyleButton.allOrNull<Size>(
                      Size(MediaQuery.of(context).size.width / 6, 45),
                    ),
                  ),
                  // Définit des coins non arrond),
                  label: Text(
                    "Registred",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "CustomFont",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  icon: Icon(Icons.check, color: Colors.white),
                  iconAlignment: IconAlignment.end,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
