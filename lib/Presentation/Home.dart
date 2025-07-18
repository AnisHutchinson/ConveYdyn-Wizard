import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conveydyn_wizard/Component/CookiesConsentBanner.dart';
import 'package:conveydyn_wizard/Component/SettingPopPup.dart';
import 'package:conveydyn_wizard/Presentation/CurvedConveyor/TransmissionGeometry.dart';
import 'package:conveydyn_wizard/Presentation/StraightConveyor/TransmissionGeometry.dart';
import 'package:conveydyn_wizard/Service/customroute.dart';
import 'package:conveydyn_wizard/Service/DataManager.dart';
import 'package:conveydyn_wizard/Service/SharedPref.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Service/customroute.dart';
import '../Component/showCookiesDialog.dart';
import '../Service/interaction.dart';
import '../Utils/helper.dart';
class Home extends StatefulWidget {
  //final VoidCallback onNavigate;
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var DataProvider = Provider.of<DataManager>(context, listen: false);
    return Stack(
      children: [
        Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 238, 237, 237),
              width: MediaQuery.of(context).size.width,
              height: 35,
              child: Image.asset("images/logo+nom.png", scale: 2),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  //_updateAppBarTitle("Détails");
                  DataProvider.updateTitle("STRAIGHT CONVEYOR");
                  Navigator.of(context).push(
                    CustomPageRoute.createRout(
                      StraightGeometry(),
                      "straightconvyor",
                    ),
                  );
                  DataProvider.updateAlgo("line");
                  DataProvider.validateNumR();
                  DataProvider.updateMessageRoller();
                },
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Image.asset(
                      "images/straight_roller_conveyor.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.08,
                      left: MediaQuery.of(context).size.width * 0.03,
                      child: Text(
                        "STRAIGHT ROLLER",
                        style: TextStyle(
                          fontFamily: 'CustomFont',
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * .04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.03,
                      left: MediaQuery.of(context).size.width * 0.03,
                      child: Text(
                        "CONVEYOR",
                        style: TextStyle(
                          fontFamily: 'CustomFont',
                          fontSize: MediaQuery.of(context).size.height * .04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: Colors.white, thickness: 0.2, height: 1.5),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  DataProvider.updateTitle("CURVED CONVEYOR");
                  Navigator.of(context).push(
                    CustomPageRoute.createRout(
                      CurvedGeometry(),
                      "curvedconvyor",
                    ),
                  );
                  DataProvider.updateAlgo("curve");
                  DataProvider.validateNumR();
                  DataProvider.updateMessageRoller();
                },
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Image.asset(
                      "images/curved_roller_conveyor.jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.08,
                      left: MediaQuery.of(context).size.width * 0.03,
                      child: Text(
                        "CURVED ROLLER",
                        style: TextStyle(
                          fontFamily: 'CustomFont',
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * .04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.03,
                      left: MediaQuery.of(context).size.width * 0.03,
                      child: Text(
                        "CONVEYOR",
                        style: TextStyle(
                          fontFamily: 'CustomFont',
                          fontSize: MediaQuery.of(context).size.height * .04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
