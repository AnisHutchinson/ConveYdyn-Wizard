import "dart:async";
import "dart:math" as math;
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:syncfusion_flutter_sliders/sliders.dart';
import "package:conveydyn_wizard/Presentation/load_to_carry.dart";
import "package:conveydyn_wizard/Service/customroute.dart";
import "package:conveydyn_wizard/Service/DataManager.dart";
import "package:conveydyn_wizard/Service/PageManager.dart";
import "../../Utils/Shape.dart";

class CurvedGeometry extends StatefulWidget {
  const CurvedGeometry({super.key});

  @override
  State<CurvedGeometry> createState() => _TransmissionGeometryState();
}

class _TransmissionGeometryState extends State<CurvedGeometry> {
  static const TextStyle optionStyle = TextStyle(fontFamily: "CustomFont");

  List _isPressed_remove = [false, false];
  List _isPressed_add = [false, false];
  Timer? _timer;

  //late int angleCurve;
  //late double angleRoller;

  @override
  void initState() {
    // TODO: implement initState
    //angleCurve = 90;
    //angleRoller = 3;
    super.initState();
  }

  bool showInfo = false;

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context, listen: false);
    double pulleyValue = dataManager.pullyValue;
    double centerDistValue = dataManager.centerValue;
    double angleRoller = dataManager.rollerAngle;
    int angleCurve = dataManager.curveAngle;
    int numberRoller = dataManager.numberRoller;
    bool valideRoller = dataManager.validateNumR();
    String messageRoller = dataManager.rollerMesssage;

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
                    dataManager.updateTitle("CONVEYDYN® WIZARD");
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
                SizedBox(width: 40),
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
                              DataManager.fieldLong[Provider.of<DataManager>(
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
                          width: 127,
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
                                        style: TextStyle(
                                          fontFamily: "CustomFont",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                            221,
                                            71,
                                            70,
                                            70,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              isExpanded: true,
                              value:
                                  Provider.of<DataManager>(context).rollerValue,
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
                              DataManager.fieldLong[Provider.of<DataManager>(
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
                          width: 127,
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
                                    style: TextStyle(
                                      fontFamily: "CustomFont",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromARGB(
                                        221,
                                        71,
                                        70,
                                        70,
                                      ),
                                    ),
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
                              DataManager.fieldLong[Provider.of<DataManager>(
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
                          width: 127,
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
                                        style: TextStyle(
                                          fontFamily: "CustomFont",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                            221,
                                            71,
                                            70,
                                            70,
                                          ),
                                        ),
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
                                    //centerDistValue = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Text("Curve angle", style: optionStyle),
                        SizedBox(width: 5),
                        Text(
                          "(°)",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onLongPressStart: (_) {
                            setState(() {
                              _isPressed_remove[0] = true;
                              _timer = Timer.periodic(
                                Duration(milliseconds: 100),
                                (timer) {
                                  setState(() {
                                    dataManager.decreaseCurveAngl();
                                    dataManager.updateNumberRoller();
                                    dataManager.validateNumR();
                                    dataManager.updateMessageRoller();
                                  });
                                },
                              );
                            });
                          },
                          onLongPressEnd: (_) {
                            setState(() {
                              _isPressed_remove[0] = false;
                              _timer?.cancel();
                            });
                          },

                          onTapDown: (_) {
                            setState(() {
                              _isPressed_remove[0] = true;
                              dataManager.decreaseCurveAngl();
                              dataManager.updateNumberRoller();
                              dataManager.validateNumR();
                              dataManager.updateMessageRoller();
                            });
                          },

                          onTapUp: (_) {
                            setState(() {
                              _isPressed_remove[0] = false;
                            });
                          },

                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            width: 30,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 238, 237, 237),
                              border:
                                  _isPressed_remove[0]
                                      ? Border.all(
                                        color: Colors.yellow,
                                        width: 2,
                                      )
                                      : null,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.grey[400],
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3),
                        Container(
                          height: 40,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color.fromARGB(255, 238, 237, 237),
                          ),
                          child: Center(
                            child: Text(
                              "$angleCurve",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "CustomFont",
                                fontSize: 16,
                                color: const Color.fromARGB(221, 71, 70, 70),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3),
                        GestureDetector(
                          onLongPressStart: (_) {
                            setState(() {
                              _isPressed_add[0] = true;
                              _timer = Timer.periodic(
                                Duration(milliseconds: 100),
                                (timer) {
                                  setState(() {
                                    dataManager.increaseCurveAngl();
                                    dataManager.updateNumberRoller();
                                    dataManager.validateNumR();
                                    dataManager.updateMessageRoller();
                                  });
                                },
                              );
                            });
                          },
                          onLongPressEnd: (_) {
                            setState(() {
                              _isPressed_add[0] = false;
                              _timer?.cancel();
                            });
                          },
                          onTapDown: (_) {
                            setState(() {
                              _isPressed_add[0] = true;
                              dataManager.increaseCurveAngl();
                              dataManager.updateNumberRoller();
                              dataManager.validateNumR();
                              dataManager.updateMessageRoller();
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _isPressed_add[0] = false;
                            });
                          },

                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            width: 30,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 238, 237, 237),
                              border:
                                  _isPressed_add[0]
                                      ? Border.all(
                                        color: Colors.yellow,
                                        width: 2,
                                      )
                                      : null,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add_circle,
                                color: Colors.grey[400],
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text("Roller angle", style: optionStyle),
                        SizedBox(width: 5),
                        Text(
                          "(°)",
                          style: TextStyle(
                            fontFamily: "CustomFont",
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onLongPressStart: (_) {
                            setState(() {
                              _isPressed_remove[1] = true;
                              _timer = Timer.periodic(
                                Duration(milliseconds: 100),
                                (timer) {
                                  setState(() {
                                    dataManager.decreaseRollerAngl();
                                    dataManager.updateNumberRoller();
                                    dataManager.validateNumR();
                                    dataManager.updateMessageRoller();
                                  });
                                },
                              );
                            });
                          },
                          onLongPressEnd: (_) {
                            setState(() {
                              _isPressed_remove[1] = false;
                              _timer?.cancel();
                            });
                          },
                          onTapDown: (_) {
                            setState(() {
                              _isPressed_remove[1] = true;
                              dataManager.decreaseRollerAngl();
                              dataManager.updateNumberRoller();
                              dataManager.validateNumR();
                              dataManager.updateMessageRoller();
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _isPressed_remove[1] = false;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            width: 30,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 238, 237, 237),
                              border:
                                  _isPressed_remove[1]
                                      ? Border.all(
                                        color: Colors.yellow,
                                        width: 2,
                                      )
                                      : null,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.grey[400],
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3),
                        Container(
                          height: 40,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color.fromARGB(255, 238, 237, 237),
                          ),
                          child: Center(
                            child: Text(
                              "${angleRoller.toStringAsFixed(1)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: "CustomFont",
                                color: const Color.fromARGB(221, 71, 70, 70),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3),
                        GestureDetector(
                          onLongPressStart: (_) {
                            setState(() {
                              _isPressed_add[1] = true;
                              _timer = Timer.periodic(
                                Duration(milliseconds: 100),
                                (timer) {
                                  setState(() {
                                    dataManager.increaseRollerAngl();
                                    dataManager.updateNumberRoller();
                                    dataManager.validateNumR();
                                    dataManager.updateMessageRoller();
                                  });
                                },
                              );
                            });
                          },
                          onLongPressEnd: (_) {
                            setState(() {
                              _isPressed_add[1] = false;
                              _timer?.cancel();
                            });
                          },
                          onTapDown: (_) {
                            setState(() {
                              _isPressed_add[1] = true;
                              dataManager.increaseRollerAngl();
                              dataManager.updateNumberRoller();
                              dataManager.validateNumR();
                              dataManager.updateMessageRoller();
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _isPressed_add[1] = false;
                            });
                          },

                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            width: 30,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 238, 237, 237),
                              border:
                                  _isPressed_add[1]
                                      ? Border.all(
                                        color: Colors.yellow,
                                        width: 2,
                                      )
                                      : null,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add_circle,
                                color: Colors.grey[400],
                                size: 17,
                                weight: 300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 10),
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              //mainAxisSize: MainAxisSize.min,
                              children: [
                                if (showInfo)
                                  const ArrowDownTriangle(), // flèche vers le bas

                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showInfo = !showInfo;
                                    });
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[400]!,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.question_mark_rounded,
                                        color: Colors.grey[600],
                                        size: 17,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                            Container(
                              height:
                                  200, //tu peut enlever ca pour regler le probléme
                              width: 220,
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      "images/curved_roller_.jpg",
                                      scale: 1.3,
                                      //width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                  //Align(child: Text("$angleRoller °")),
                                  LayoutBuilder(
                                    builder: (
                                      BuildContext context,
                                      BoxConstraints constraints,
                                    ) {
                                      return Align(
                                        alignment: Alignment(-0.5, -0.97),
                                        // Adjust alignment as needed
                                        child: Container(
                                          child: Text(
                                            "${angleRoller.toStringAsFixed(1)} °",
                                            style: TextStyle(
                                              fontFamily: "CustomFont",
                                              //fontSize: constraints.maxWidth / 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    left: 115,
                                    top: 18,
                                    child: Text(
                                      "$angleCurve °",
                                      style: TextStyle(
                                        fontFamily: "CustomFont",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  LayoutBuilder(
                                    builder: (
                                      BuildContext context,
                                      BoxConstraints constraints,
                                    ) {
                                      return Align(
                                        alignment: Alignment(1, -0.5),
                                        child: Container(
                                          child: Text(
                                            "+${numberRoller} rollers",
                                            style: TextStyle(
                                              fontFamily: "CustomFont",
                                              //fontSize: constraints.maxWidth / 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Positioned(
                          top: 25,
                          //left: MediaQuery.of(context).size.width / 20,
                          child: Visibility(
                            visible: showInfo,
                            child: Container(
                              width: 250,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),

                              decoration: BoxDecoration(
                                color: const Color(0xFF142559),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: const Text(
                                "The inner radius of curve should be more than 800mm",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: math.max(300, 700),
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child:
                valideRoller
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
                        ).updateCurvedPage(1);
                        PageManager.Fromstraight = false;
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
