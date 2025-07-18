import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_check_box_rounded/flutter_check_box_rounded.dart';
import 'package:provider/provider.dart';
import 'package:conveydyn_wizard/Presentation/Home.dart';
import 'package:conveydyn_wizard/Presentation/StraightConveyor/TransmissionGeometry.dart';
import 'package:conveydyn_wizard/Service/Customroute.dart';
import 'package:conveydyn_wizard/Service/DataManager.dart';
import 'package:conveydyn_wizard/Service/PageManager.dart';
import '../Utils/Style.dart';
import '../Presentation/widgets/settings.dart';

class Settings extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  Settings({super.key, required this.navigatorKey});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String langueValue;

  void updateLangue(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        langueValue = selectedValue;
      });
    }
  }

  @override
  void initState() {
    super.didChangeDependencies();
    // TODO: implement initState
    langueValue = "English";
    super.initState();
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
                    PageManager.back = true;
                  },
                ),
                Spacer(),
                Center(
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontFamily: 'CustomFont',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(width: 40),
              ],
            ),
          ),
          settingswidget(),
        ],
      ),
    );
  }
}
