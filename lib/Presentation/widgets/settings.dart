import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_check_box_rounded/flutter_check_box_rounded.dart';
import 'package:provider/provider.dart';
import 'package:conveydyn_wizard/Presentation/home.dart';
import 'package:conveydyn_wizard/Presentation/StraightConveyor/TransmissionGeometry.dart';
import 'package:conveydyn_wizard/Service/customroute.dart';
import 'package:conveydyn_wizard/Service/DataManager.dart';
import 'package:conveydyn_wizard/Service/PageManager.dart';
import 'package:conveydyn_wizard/Utils/Style.dart';

//import 'package:onesignal_flutter/onesignal_flutter.dart';

class settingswidget extends StatefulWidget {
  const settingswidget({super.key});

  @override
  State<settingswidget> createState() => _settingswidgetState();
}

class _settingswidgetState extends State<settingswidget> {
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
    var DataProvider = Provider.of<DataManager>(context, listen: false);
    List<String> UnitList = DataProvider.unitList;
    String MarketValue = DataProvider.marketValue;
    bool pianoCook = DataProvider.pianoCook;
    bool signalPush = DataProvider.signalPush;
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          width: math.max(300, 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "User interface",
                style: TextStyle(
                  fontFamily: "CustomFont",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Market:",
                      style: TextStyle(fontFamily: "CustomFont"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 127,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 233, 231, 231),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items:
                            DataProvider.marketToUnits.keys.map((
                              String market,
                            ) {
                              return DropdownMenuItem(
                                value: market,
                                child: Text(market, style: DropDownStyle),
                              );
                            }).toList(),
                        value: MarketValue,
                        onChanged: (String? value) {
                          if (value is String) {
                            setState(() {
                              DataProvider.updateMarket(value);
                              if (value == "American") {
                                DataProvider.updateUnit("Imperial");
                                DataProvider.updateUnitIndex();
                              }
                              DataProvider.updateUnitList(value);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Unit system:",
                      style: TextStyle(fontFamily: "CustomFont"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 35,
                    width: 127,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color.fromARGB(255, 233, 231, 231),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items:
                            UnitList.map((String unit) {
                              return DropdownMenuItem<String>(
                                value: unit,
                                child: Text(unit, style: DropDownStyle),
                              );
                            }).toList(),
                        value: Provider.of<DataManager>(context).unit,
                        onChanged: (String? value) {
                          Provider.of<DataManager>(
                            context,
                            listen: false,
                          ).updateUnitSystem(value!); //updateUnit,
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Language:",
                      style: TextStyle(fontFamily: "CustomFont"),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 127, //constraints.maxWidth * 0.4,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    //width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color.fromARGB(255, 233, 231, 231),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: const [
                          DropdownMenuItem(
                            value: "English",
                            child: Text("English", style: DropDownStyle),
                          ),
                        ],
                        isExpanded: true,
                        value: langueValue,
                        onChanged: updateLangue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Personal data",
                style: TextStyle(
                  fontFamily: "CustomFont",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "We use cookies and other trackers to analyse and improve your user experience, perform audience measurement statistics and allow you to recieve notifications. In the event that you refuse the cookies offered, only technical cookies necessary for the proper functioning of the Application will be replaced. Fore more information, you can consult the \"Privacy Policy\" page.",
                style: TextStyle(fontFamily: "CustomFont"),
              ),
              SizedBox(height: 5),
              Text(
                "When you use our Mobile Application, Hutchinson may have to place cookies. You have the option of deactivating cookies:",
                style: TextStyle(fontFamily: "CustomFont"),
              ),
              SizedBox(height: 20),
              Text(
                "Technical cookies",
                style: TextStyle(
                  fontFamily: "CustomFont",
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 5),
              Text(
                "These cookies are necessary to ensure the functioning of our Mobile Application and to configure your choices and cannot be deactivated.",
                style: TextStyle(fontFamily: "CustomFont"),
              ),
              SizedBox(height: 20),
              Text(
                "\"Piano Analytics\" cookies",
                style: TextStyle(
                  fontFamily: "CustomFont",
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  CheckBoxRounded(
                    size: 20,
                    onTap: (bool? value) {
                      setState(() {
                        if (pianoCook == false) {
                          DataProvider.updatePianoCook(true);
                          //pianoCook = true;
                          //pianoRef = false;
                        }
                      });
                    },
                    isChecked: pianoCook,
                    checkedWidget: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.circle,
                          color: Colors.grey[800],
                          size: 14,
                        ),
                      ),
                    ),
                    uncheckedWidget:
                        pianoCook == false
                            ? Container(color: Colors.grey[300])
                            : Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.grey[800],
                                  size: 14,
                                ),
                              ),
                            ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (pianoCook == false) {
                          DataProvider.updatePianoCook(true);
                          //pianoCook = true;
                        }
                      });
                    },
                    child: Text(
                      "ACCEPT",
                      style: TextStyle(
                        fontFamily: "CustomFont",
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  CheckBoxRounded(
                    size: 20,
                    onTap: (bool? value) {
                      setState(() {
                        if (pianoCook == true)
                          DataProvider.updatePianoCook(false);
                      });
                    },
                    isChecked: !pianoCook, //pianoRef,
                    checkedWidget: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.circle,
                          color: Colors.grey[800],
                          size: 14,
                        ),
                      ),
                    ),
                    uncheckedWidget:
                        !pianoCook == false
                            ? Container(color: Colors.grey[300])
                            : Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.grey[800],
                                  size: 14,
                                ),
                              ),
                            ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (pianoCook == true)
                          DataProvider.updatePianoCook(false);
                      });
                    },
                    child: Text(
                      "REFUSE",
                      style: TextStyle(
                        fontFamily: "CustomFont",
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Informative \"One Signal\"",
                style: TextStyle(
                  fontFamily: "CustomFont",
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Cookies to recieve notifications.",
                style: TextStyle(fontFamily: "CustomFont"),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  CheckBoxRounded(
                    size: 20,
                    onTap: (bool? value) {
                      setState(() {
                        if (signalPush == false)
                          DataProvider.updateSignalPush(true);
                      });
                    },
                    isChecked: signalPush,
                    checkedWidget: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.circle,
                          color: Colors.grey[800],
                          size: 14,
                        ),
                      ),
                    ),
                    uncheckedWidget:
                        signalPush == false
                            ? Container(color: Colors.grey[300])
                            : Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.grey[800],
                                  size: 14,
                                ),
                              ),
                            ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (signalPush == false)
                          DataProvider.updateSignalPush(true);
                      });
                    },
                    child: Text(
                      "ACCEPT",
                      style: TextStyle(
                        fontFamily: "CustomFont",
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  CheckBoxRounded(
                    size: 20,
                    onTap: (bool? value) {
                      setState(() {
                        if (signalPush == true)
                          DataProvider.updateSignalPush(false);
                      });
                    },
                    isChecked: !signalPush,
                    checkedWidget: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.circle,
                          color: Colors.grey[800],
                          size: 14,
                        ),
                      ),
                    ),
                    uncheckedWidget:
                        !signalPush == false
                            ? Container(color: Colors.grey[300])
                            : Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.grey[800],
                                  size: 14,
                                ),
                              ),
                            ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (signalPush == true)
                          DataProvider.updateSignalPush(false);
                      });
                    },
                    child: Text(
                      "REFUSE",
                      style: TextStyle(
                        fontFamily: "CustomFont",
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
