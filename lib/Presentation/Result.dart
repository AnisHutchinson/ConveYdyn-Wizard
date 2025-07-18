import 'dart:async';
import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conveydyn_wizard/Component/creatAccountPopPup.dart';
import 'package:conveydyn_wizard/Presentation/Home.dart';
import 'package:conveydyn_wizard/Presentation/StraightConveyor/TransmissionGeometry.dart';
import 'package:conveydyn_wizard/Service/Customroute.dart';
import 'package:conveydyn_wizard/Service/DataManager.dart';
import 'package:conveydyn_wizard/Service/Interaction.dart';
import 'package:conveydyn_wizard/Service/PageManager.dart';
import 'package:conveydyn_wizard/Utils/Shape.dart';
import 'package:conveydyn_wizard/Utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../Utils/helper.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  bool _isPressed = false;
  bool isConnected = true;

  String label = "";
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    var DataProvider = Provider.of<DataManager>(context, listen: false);
    int unitIndex = DataProvider.unitIndex;
    String typeLoad = DataProvider.typeValue;
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
                    Navigator.of(context).pop();
                    if (PageManager.Fromstraight == true) {
                      Provider.of<PageManager>(
                        context,
                        listen: false,
                      ).updateStraightPage(1);
                    } else {
                      Provider.of<PageManager>(
                        context,
                        listen: false,
                      ).updateCurvedPage(1);
                    }
                    PageManager.back = true;
                    print("back in transmission_geometry");
                  },
                ),
                Spacer(),
                Center(
                  child: Text(
                    "Resultat",
                    style: TextStyle(
                      fontFamily: 'CustomFont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(width: 30),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 10,
                ),
                width: math.max(300, 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("images/result_courroie.png", scale: 1.5),
                    SizedBox(height: 7),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "ConveYdyn® ",
                            style: TextStyle(
                              fontFamily: "CustomFont",
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: "${DataProvider.teeth.toInt()} ${DataProvider.referenceCour}",
                            style: TextStyle(
                              fontFamily: "CustomFont",
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                              fontSize: 21,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset("images/logo+nom.png", scale: 2),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _isPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _isPressed = false;
                          HelpersFunct().launch_Url(
                            Constant_Url().url_product_info,
                          );
                          //_launchUrl(Constant_Url().url_product_info);
                        });
                      },
                      child: MouseRegion(
                        onExit: (_) {
                          setState(() {
                            _isPressed = false;
                          });
                        },
                        child: Stack(
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: 240,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "PRODUCT INFORMATION ",
                                      style: TextStyle(
                                        fontFamily: "CustomFont",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Icon(
                                      Icons.insert_drive_file,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_isPressed)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.yellow,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Belt width:",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        Spacer(),
                        Text(
                          "${DataProvider.Betlwidth} ${DataManager.fieldLong[unitIndex]}",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Required power:",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        Spacer(),
                        Text(
                          "${DataProvider.p(DataProvider.typeValue)} watt",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Belt tension:",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        Spacer(),
                        Text(
                          "${DataProvider.BeltTension.toInt()} N/span",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Tangent load:",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        Spacer(),
                        Text(
                          "${(DataProvider.loadForce(typeLoad) * 10).roundToDouble() / 10} N",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Required torque:",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        Spacer(),
                        Text(
                          "${DataProvider.ReqTorque()} ${DataManager.fieldTorque[unitIndex]}",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    DataProvider.getAlgo.name == "curve"
                        ? Row(
                          children: [
                            Text(
                              "Number of slave rollers:",
                              style: TextStyle(
                                fontFamily: "CustomFont",
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            Spacer(),
                            Text(
                              "${DataProvider.numberRoller}",
                              style: TextStyle(
                                fontFamily: "CustomFont",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        )
                        : SizedBox(),
                    SizedBox(height: 40),
                    Text(
                      "This App should be used for a preliminary concept of the belt for your application. Please contact us to review or optimize your transmission design.",
                      style: TextStyle(
                        fontFamily: "CustomFont",
                        color: Color(0xFF000080),
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "In case of intensive use of the start and stop mode, please contact us to validate the solution.",
                      style: TextStyle(
                        fontFamily: "CustomFont",
                        color: Color(0xFF000080),
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [ 
                  isClicked ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        width: 150,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF142559),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          DataProvider.mailLabel,
                          style: TextStyle(
                            fontFamily: 'CustomFont',
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      //const SizedBox(height: 4),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: const ArrowDownTriangle()
                      ), // Flèche centrée automatiquement
                    ],
                  ):Container(),
                ],
              ),
              
              //!isConnected ? const ArrowDownTriangle() : Container(),
                              
              Container(
                width: math.max(300, 700),
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).push(CustomPageRoute.RoutHome(Home(), "home"));
                          DataProvider.updateTitle("CONVEYDYN® WIZARD");
                        },
                        style: ButtonStyle(
                          shape:
                              ButtonStyleButton.allOrNull<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),
                          backgroundColor: ButtonStyleButton.allOrNull<Color>(
                            const Color.fromARGB(255, 82, 78, 78),
                          ),
                          minimumSize: ButtonStyleButton.allOrNull<Size>(
                            Size(double.infinity, 45),
                          ),
                        ),
                        // Définit des coins non arrond),
                        label: Text(
                          "NEW CALCULATION",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () async{
                          var connected = await HelpersFunct().isConnectedToInternet();
                          //pour gérer le message apres le clique sur send by mail
                          if(DataProvider.email != ""){
                            print("wwwwwwwwwwwwwwwwhh");
                            setState(() {     
                              isClicked = true;
                            });
                            Future.delayed(const Duration(seconds: 3), () {
                              if (mounted) {
                                setState(() {
                                  isClicked = false;
                                });
                              }
                            });
                          }
                          //verification de connexion internet
                          if(!connected){
                            label = "No Connection was";
                            DataProvider.updateMailLabel(label);
                            setState(() {
                              isConnected = connected;
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) {
                                setState(() {
                                  isConnected = true;
                                });
                              }
                            });
                          }else{
                            //vérification de l'enregistrement de l'email
                            if (DataProvider.email == "") {
                              //CreateAccountPopPup(context, navigtor);
                              print("wsh cv whiya  *************");
                              createAccountPopPup(context);
                            } else{
                              sendMail(context);
                            }
                          }
                        },
                        style: ButtonStyle(
                          shape:
                              ButtonStyleButton.allOrNull<RoundedRectangleBorder>(
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
                            Size(double.infinity, 45),
                          ),
                        ),
                        // Définit des coins non arrond),
                        label: Text(
                          "SEND BY EMAIL",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        icon: Icon(Icons.email, color: Colors.white),
                        iconAlignment: IconAlignment.end,
                      ),
                    ),
                  ],
                ),
              ),
            ] 
          ),
        ],
      ),
    );
  }
}
