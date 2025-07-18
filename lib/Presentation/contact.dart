import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conveydyn_wizard/Presentation/Home.dart';
import 'package:conveydyn_wizard/Presentation/StraightConveyor/TransmissionGeometry.dart';
import 'package:conveydyn_wizard/Service/Customroute.dart';
import 'package:conveydyn_wizard/Service/PageManager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utils/helper.dart';
import '../Utils/constant.dart';
import '../Service/DataManager.dart';
import '../Service/PageManager.dart';
import '../Component/drawer.dart';
import '../Component/showCookiesDialog.dart';

class Contact extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const Contact({super.key, required this.navigatorKey});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  
  @override
  Widget build(BuildContext context) {
    var DataProvider = Provider.of<DataManager>(context, listen: false);
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
                    //Slider_drawer(select_page: 0);
                    widget.navigatorKey.currentState?.push(
                      CustomPageRoute.RoutHome(Home(), "home"),
                    );
                    Provider.of<PageManager>(
                      context,
                      listen: false,
                    ).updatePage(0);
                    print("back contact");
                  },
                ),
                Spacer(),
                Center(
                  child: Text(
                    "Contact",
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
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: 282,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 50),
                      Text(
                        "Hutchinson Belt Drive Systems",
                        style: TextStyle(
                          fontFamily: "CustomFont",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rue des Martyrs",
                        style: TextStyle(fontFamily: "CustomFont"),
                      ),
                      Text(
                        "37304 Joué-les-tours - FRANCE",
                        style: TextStyle(fontFamily: "CustomFont"),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Tel :",
                            style: TextStyle(
                              fontFamily: "CustomFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "+33 2 47 48 39 99",
                            style: TextStyle(fontFamily: "CustomFont"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Fax :",
                            style: TextStyle(
                              fontFamily: "CustomFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "+33 2 47 48 38 34",
                            style: TextStyle(fontFamily: "CustomFont"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Email : ",
                            style: TextStyle(
                              fontFamily: "CustomFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //OpenMail(); // donne le choix entre les apps installer
                              HelpersFunct().launch_Url(Constant_Url().email);
                            },
                            child: Text(
                              "belt.drives@hutchinson.com",
                              style: TextStyle(
                                fontFamily: "CustomFont",
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Website : ",
                            style: TextStyle(
                              fontFamily: "CustomFont",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              HelpersFunct().launch_Url(
                                Constant_Url().url_site_web,
                              );
                            },
                            child: Text(
                              "hutchinsontransmission.com",
                              style: TextStyle(
                                fontFamily: "CustomFont",
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: () {
                          //_launchCaller();
                          HelpersFunct().launch_Url(Constant_Url().tel);
                        },
                        style: ButtonStyle(
                          shape: ButtonStyleButton.allOrNull<
                            RoundedRectangleBorder
                          >(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          backgroundColor: ButtonStyleButton.allOrNull<Color>(
                            Colors.red,
                          ),
                          minimumSize: ButtonStyleButton.allOrNull<Size>(
                            Size(MediaQuery.of(context).size.width, 45),
                          ),
                        ),
                        // Définit des coins non arrond),
                        label: Text(
                          "CALL US",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        icon: Icon(Icons.phone, color: Colors.white),
                        iconAlignment: IconAlignment.end,
                      ),
                      SizedBox(height: 5),
                      FilledButton.icon(
                        onPressed: () {
                          //OpenMail(); ca donne le choix
                          HelpersFunct().launch_Url(Constant_Url().email);
                        },
                        style: ButtonStyle(
                          shape: ButtonStyleButton.allOrNull<
                            RoundedRectangleBorder
                          >(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          backgroundColor: ButtonStyleButton.allOrNull<Color>(
                            Colors.red,
                          ),
                          minimumSize: ButtonStyleButton.allOrNull<Size>(
                            Size(MediaQuery.of(context).size.width, 45),
                          ),
                        ),
                        label: Text(
                          "EMAIL US",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        icon: Icon(Icons.email, color: Colors.white),
                        iconAlignment: IconAlignment.end,
                      ),
                    ],
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
