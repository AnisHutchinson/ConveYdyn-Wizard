import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conveydyn_wizard/Presentation/Home.dart';
import 'package:conveydyn_wizard/Presentation/StraightConveyor/TransmissionGeometry.dart';
import 'package:conveydyn_wizard/Presentation/widgets/userAccount.dart';
import 'package:conveydyn_wizard/Service/Customroute.dart';
import 'package:conveydyn_wizard/Service/PageManager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utils/helper.dart';
import '../Utils/constant.dart';
import '../Service/DataManager.dart';
import '../Service/PageManager.dart';
import '../Component/drawer.dart';
import '../Utils/Inpute.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class UserAccount extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const UserAccount({super.key, required this.navigatorKey});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {

  @override
  void initState() {
    super.initState();
  }

  Widget _buildTextFormField(String labelText, String validatorMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(labelText, style: TextStyle(fontFamily: "CustomFont")),
        TextFormField(
          decoration: InputDecoration(
            fillColor: Colors.grey[200],
            filled: true,
            labelText: labelText,
            labelStyle: TextStyle(fontFamily: "CustomFont"),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validatorMessage;
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 238, 237, 237),
            width: MediaQuery.of(context).size.width,
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 5),
                IconButton(
                  icon: Image.asset("images/back.png", scale: 2.0),
                  onPressed: () {
                    widget.navigatorKey.currentState?.push(
                      CustomPageRoute.RoutHome(Home(), "home"),
                    );
                    Provider.of<PageManager>(
                      context,
                      listen: false,
                    ).updatePage(0);
                    print("back in user account");
                  },
                ),
                Spacer(),
                Center(
                  child: Text(
                    "User account",
                    style: TextStyle(
                      fontFamily: 'CustomFont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(width: 40),
              ],
            ),
          ),
          UserAccountWidget(navigatorKey: widget.navigatorKey),
        ],
      ),
    );
  }
}
