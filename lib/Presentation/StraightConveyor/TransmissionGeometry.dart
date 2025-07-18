import "dart:math" as math;
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:conveydyn_wizard/Presentation/load_to_carry.dart';
import 'package:conveydyn_wizard/Service/customroute.dart';
import 'package:conveydyn_wizard/Service/PageManager.dart';
import '../../Utils/Shape.dart';
import '../../Service/DataManager.dart';
import '../../Utils/Style.dart';

class StraightGeometry extends StatefulWidget {
  const StraightGeometry({super.key});

  @override
  State<StraightGeometry> createState() => _TransmissionGeometryState();
}

class _TransmissionGeometryState extends State<StraightGeometry> {
  //late double rollerValue;
  //late double pulleyValue;
  //late double centerDistValue;
  late int nbrRollerGValue;
  late int nbrRollerDValue;
  late List<double> centerDistance;

  @override
  void initState() {
    //centerDistValue = 133.0;
    nbrRollerGValue = 15;
    nbrRollerDValue = 15;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var DataProvider = Provider.of<DataManager>(context);
    double pulleyValue = DataProvider.pullyValue;

    double centerDistValue = DataProvider.centerValue;
    int numberRollerG = DataProvider.numberRollerG;
    int numberRollerD = DataProvider.numberRollerD;
    int numberRoller = DataProvider.numberRoller;
    String messageRoller = DataProvider.rollerMesssage;
    bool valide = DataProvider.validateNumR();

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
                    Navigator.pop(context);
                    DataProvider.updateTitle("CONVEYDYN® WIZARD");
                  },
                ),

                Spacer(),
                Center(
                  child: Text(
                    "Transmission geometry",
                    style: TextStyle(
                      fontFamily: 'CustomFont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(width: 47),
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
                //height: MediaQuery.of(context).size.height,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Roler diameter",
                              style: TextStyle(fontFamily: "CustomFont"),
                            ),
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              " (" +
                                  DataManager
                                      .fieldLong[Provider.of<DataManager>(
                                    context,
                                  ).unitIndex] +
                                  ")",
                              style: TextStyle(
                                fontFamily: "CustomFont",
                                color: Colors.grey[500],
                                fontSize: 10,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: 127, //constraints.maxWidth * 0.4,
                              //150,
                              height: 35,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 238, 237, 237),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items:
                                      Provider.of<DataManager>(
                                        context,
                                      ).RollerDiametre.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                            "$value",
                                            style: DropDownStyle,
                                          ),
                                        );
                                      }).toList(),
                                  isExpanded: true,
                                  value:
                                      Provider.of<DataManager>(
                                        context,
                                      ).rollerValue,
                                  onChanged: (double? newvalue) {
                                    if (newvalue is double) {
                                      setState(() {
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).updateRollerValue(newvalue);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Pully diameter",
                              style: TextStyle(fontFamily: "CustomFont"),
                            ),
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              " (" +
                                  DataManager
                                      .fieldLong[Provider.of<DataManager>(
                                    context,
                                  ).unitIndex] +
                                  ")",
                              style: TextStyle(
                                fontFamily: "CustomFont",
                                color: Colors.grey[500],
                                fontSize: 10,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: 127, //constraints.maxWidth * 0.4,
                              height: 35,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 238, 237, 237),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items: [
                                    DropdownMenuItem(
                                      value: pulleyValue,
                                      child: Text(
                                        "$pulleyValue",
                                        style: DropDownStyle,
                                      ),
                                    ),
                                  ],
                                  isExpanded: true,
                                  value: pulleyValue,
                                  onChanged: (double? value) {
                                    if (value is double) {
                                      setState(() {
                                        pulleyValue = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Center distance",
                              style: TextStyle(fontFamily: "CustomFont"),
                            ),
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              " (" +
                                  DataManager
                                      .fieldLong[Provider.of<DataManager>(
                                    context,
                                  ).unitIndex] +
                                  ")",
                              style: TextStyle(
                                fontFamily: "CustomFont",
                                color: Colors.grey[500],
                                fontSize: 10,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: 127, //constraints.maxWidth * 0.4,
                              height: 35,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 238, 237, 237),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items:
                                      Provider.of<DataManager>(
                                        context,
                                      ).centerDistance.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                            "$value",
                                            style: DropDownStyle,
                                          ),
                                        );
                                      }).toList(),
                                  isExpanded: true,
                                  value: centerDistValue,
                                  //Provider.of<DataManager>(context).centerValue,
                                  onChanged: (double? value) {
                                    if (value is double) {
                                      setState(() {
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).updateCenterValue(value);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 9,
                        ),
                        Container(
                          width: 500,
                          child: Stack(
                            children: [
                              Image.asset(
                                (numberRollerG == 0 && numberRollerD == 0) ||
                                        (numberRollerG != 0 &&
                                            numberRollerD != 0)
                                    ? "images/roller_millieu.png"
                                    : numberRollerD == 0
                                    ? "images/roller_gauche.png"
                                    : "images/roller_droit.png",
                                width: MediaQuery.of(context).size.width,
                              ),
                              LayoutBuilder(
                                builder: (
                                  BuildContext context,
                                  BoxConstraints constraints,
                                ) {
                                  return Align(
                                    //top: MediaQuery.of(context).size.height / 10,
                                    alignment: Alignment(-0.45, 0),
                                    // Adjust alignment as needed
                                    child: Container(
                                      // Adjust this value to move the image slightly to the right
                                      //width: constraints.maxWidth / 30,
                                      child: Text(
                                        "$centerDistValue mm",
                                        style: TextStyle(
                                          fontFamily: "CustomFont",
                                          //fontWeight: FontWeight.bold,
                                          fontSize: (constraints.maxWidth / 25)
                                              .clamp(12, 17),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Number of rollers",
                              style: TextStyle(fontFamily: "CustomFont"),
                            ),
                          ],
                        ),
                        SizedBox(height: 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              Provider.of<DataManager>(
                                context,
                              ).numberRollerG.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontFamily: "CustomFont",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    thumbShape: RectangularSliderThumbShape(),
                                    thumbColor: Colors.blue,
                                    trackHeight: 8.0,
                                    activeTrackColor: Colors.orange,
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                    trackShape: CustomTrackShape(),
                                  ),
                                  child: Slider(
                                    min: 0,
                                    max: 25,
                                    thumbColor: Colors.grey[800],
                                    activeColor: Colors.grey[300],
                                    inactiveColor: Colors.grey[300],
                                    value:
                                        Provider.of<DataManager>(
                                          context,
                                        ).numberRollerG.toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).updateNumberRollerG(value.toInt());
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).validateNumR();
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).updateMessageRoller();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Image.asset("images/roller.png", scale: 2.2),
                            SizedBox(width: 5),
                            Expanded(
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationX(math.pi),
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    thumbShape: RectangularSliderThumbShape(),
                                    trackHeight: 8.0,
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                    thumbColor: Colors.grey,
                                    trackShape: CustomTrackShape(),
                                    //activeTrackColor: Colors.orange,
                                  ),
                                  child: Slider(
                                    min: 0,
                                    max: 25,
                                    value:
                                        Provider.of<DataManager>(
                                          context,
                                        ).numberRollerD.toDouble(),
                                    thumbColor: Colors.grey[800],
                                    activeColor: Colors.grey[300],
                                    inactiveColor:
                                        Colors
                                            .grey[300], // Couleur de la partie active inactiveColor: Colors.grey[300], // Couleur de la partie inactive
                                    onChanged: (value) {
                                      setState(() {
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).updateNumberRollerD(value.toInt());
                                        //print("eeee $numberRollerD");
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).validateNumR();
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).updateMessageRoller();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              Provider.of<DataManager>(
                                context,
                              ).numberRollerD.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontFamily: "CustomFont",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            width: math.max(300, 700),
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child:
                valide
                    ? FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          CustomPageRoute.createRout(
                            LoadToCarry(),
                            "loadtocarry",
                          ),
                        );
                        Provider.of<PageManager>(
                          context,
                          listen: false,
                        ).updateStraightPage(1);
                        PageManager.Fromstraight = true;
                        PageManager.back = false;
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
                          Size(MediaQuery.of(context).size.width, 45),
                        ),
                      ),
                      // Définit des coins non arrond),
                      label: Text(
                        "LOAD TO CARRY",
                        style: TextStyle(
                          fontFamily: "CustomFont",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                      ),
                      iconAlignment: IconAlignment.end,
                    )
                    : FilledButton.icon(
                      onPressed: () {},
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
                          Colors.grey[300],
                        ),
                        minimumSize: ButtonStyleButton.allOrNull<Size>(
                          Size(MediaQuery.of(context).size.width, 45),
                        ),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color.fromARGB(
                                255,
                                171,
                                26,
                                26,
                              ); // Color when button is pressed
                            }
                            return null; // Default color
                          },
                        ),
                      ),
                      label: Text(
                        messageRoller,
                        //"Excessive number of rolls",
                        style: TextStyle(
                          fontFamily: "CustomFont",
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      icon: Icon(Icons.warning, color: Colors.red),
                    ),
          ),
        ],
      ),
    );
  }
}
