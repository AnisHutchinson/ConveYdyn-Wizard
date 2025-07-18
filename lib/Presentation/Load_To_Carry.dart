import "dart:async";
import 'dart:math';
import "dart:math" as math;
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:conveydyn_wizard/Presentation/Result.dart";
import "package:conveydyn_wizard/Service/customroute.dart";
import "package:conveydyn_wizard/Service/DataManager.dart";
import "package:conveydyn_wizard/Service/PageManager.dart";
import '../Utils/Style.dart';

class LoadToCarry extends StatefulWidget {
  const LoadToCarry({super.key});

  @override
  State<LoadToCarry> createState() => _LoadToCarryState();
}

class _LoadToCarryState extends State<LoadToCarry> {
  static const TextStyle optionStyle = TextStyle(fontFamily: "CustomFont");

  List _isPressed_add = <bool>[false, false, false];
  List _isPressed_remove = [false, false, false];
  //bool _isPressed_remove = false;

  Timer? _timer;

  List Types = ["Carton", "Plastic"]; // je laisse ca

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DataProvider = Provider.of<DataManager>(context);
    String unitValue = DataProvider.unit;
    int unitIndex = DataProvider.unitIndex;
    String typeValue = DataProvider.typeValue;
    double weight = DataProvider.weight;
    int incline = DataProvider.incline;
    double speed = DataProvider.speed;

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
                      ).updateStraightPage(0);
                    } else {
                      Provider.of<PageManager>(
                        context,
                        listen: false,
                      ).updateCurvedPage(0);
                    }
                    PageManager.back = true;
                    print("back in transmission_geometry");
                  },
                ),
                Spacer(),
                Center(
                  child: Text(
                    "Load to carry",
                    style: TextStyle(
                      fontFamily: 'CustomFont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(width: 35),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 10,
                ),
                width: max(300, 700),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text("Load weight", style: optionStyle),
                            SizedBox(width: 5),
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              " (" +
                                  DataManager
                                      .fieldWeight[Provider.of<DataManager>(
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
                            GestureDetector(
                              onLongPressStart: (_) {
                                setState(() {
                                  _isPressed_remove[0] = true;
                                  _timer = Timer.periodic(
                                    Duration(milliseconds: 100),
                                    (timer) {
                                      setState(() {
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).increaseWeight();
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
                                  Provider.of<DataManager>(
                                    context,
                                    listen: false,
                                  ).increaseWeight();
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
                                  color: const Color.fromARGB(
                                    255,
                                    238,
                                    237,
                                    237,
                                  ),
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
                                child:
                                    unitValue == "Metric"
                                        ? Text(
                                          "${Provider.of<DataManager>(context).weight.toInt()}",
                                          style: CompteurStyle,
                                        )
                                        : Text(
                                          "${Provider.of<DataManager>(context).ConvertUnit(unitValue, "kg", weight).toStringAsFixed(1)}",
                                          style: CompteurStyle,
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
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).decreaseWeight();
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
                                  Provider.of<DataManager>(
                                    context,
                                    listen: false,
                                  ).decreaseWeight();
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
                                  color: const Color.fromARGB(
                                    255,
                                    238,
                                    237,
                                    237,
                                  ),
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
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text("Load type", style: optionStyle),
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
                                      Types.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: DropDownStyle,
                                          ),
                                        );
                                      }).toList(),
                                  isExpanded: true,
                                  value:
                                      Provider.of<DataManager>(
                                        context,
                                      ).typeValue,
                                  onChanged: (newvalue) {
                                    if (newvalue is String) {
                                      setState(() {
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).updateTypeValue(newvalue);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text("Inclination", style: optionStyle),
                            SizedBox(width: 5),
                            Text(
                              "(%)",
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
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).decreaseIncline();
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
                                  Provider.of<DataManager>(
                                    context,
                                    listen: false,
                                  ).decreaseIncline();
                                });
                              },

                              onTapUp: (_) {
                                setState(() {
                                  _isPressed_remove[1] = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: 30,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    238,
                                    237,
                                    237,
                                  ),
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
                                child: Text("$incline", style: CompteurStyle),
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
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).increaseIncline();
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
                                  Provider.of<DataManager>(
                                    context,
                                    listen: false,
                                  ).increaseIncline();
                                });
                              },
                              onTapUp: (_) {
                                setState(() {
                                  _isPressed_add[1] = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: 30,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    238,
                                    237,
                                    237,
                                  ),
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
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text("Linear speed", style: optionStyle),
                            SizedBox(width: 5),
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              " (" +
                                  DataManager
                                      .fieldLSpeed[Provider.of<DataManager>(
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
                            GestureDetector(
                              onLongPressStart: (_) {
                                setState(() {
                                  _isPressed_remove[2] = true;
                                  _timer = Timer.periodic(
                                    Duration(milliseconds: 100),
                                    (timer) {
                                      setState(() {
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).decreaseSpeed();
                                      });
                                    },
                                  );
                                });
                              },
                              onLongPressEnd: (_) {
                                setState(() {
                                  _isPressed_remove[2] = false;
                                  _timer?.cancel();
                                });
                              },

                              onTapDown: (_) {
                                setState(() {
                                  _isPressed_remove[2] = true;
                                  Provider.of<DataManager>(
                                    context,
                                    listen: false,
                                  ).decreaseSpeed();
                                });
                              },

                              onTapUp: (_) {
                                setState(() {
                                  _isPressed_remove[2] = false;
                                });
                              },

                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: 30,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    238,
                                    237,
                                    237,
                                  ),
                                  border:
                                      _isPressed_remove[2]
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
                                  unitValue == "Metric"
                                      ? speed.toStringAsFixed(1)
                                      : DataProvider.ConvertUnit(
                                        unitValue,
                                        "m/s",
                                        speed,
                                      ).toStringAsFixed(1),
                                  style: CompteurStyle,
                                ),
                              ),
                            ),
                            SizedBox(width: 3),
                            GestureDetector(
                              onLongPressStart: (_) {
                                setState(() {
                                  _isPressed_add[2] = true;
                                  _timer = Timer.periodic(
                                    Duration(milliseconds: 100),
                                    (timer) {
                                      setState(() {
                                        Provider.of<DataManager>(
                                          context,
                                          listen: false,
                                        ).increaseSpeed();
                                      });
                                    },
                                  );
                                });
                              },
                              onLongPressEnd: (_) {
                                setState(() {
                                  _isPressed_add[2] = false;
                                  _timer?.cancel();
                                });
                              },

                              onTapDown: (_) {
                                setState(() {
                                  _isPressed_add[2] = true;
                                  Provider.of<DataManager>(
                                    context,
                                    listen: false,
                                  ).increaseSpeed();
                                });
                              },

                              onTapUp: (_) {
                                setState(() {
                                  _isPressed_add[2] = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: 30,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    238,
                                    237,
                                    237,
                                  ),
                                  border:
                                      _isPressed_add[2]
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 9,
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Transform.rotate(
                            angle:
                                -Provider.of<DataManager>(
                                  context,
                                  listen: false,
                                ).angle, // Angle in radians
                            child: Container(
                              width: 450,
                              child: Stack(
                                children: [
                                  Image.asset("images/LoadToCarry.png"),
                                  if (typeValue == "Plastic")
                                    Center(
                                      child: LayoutBuilder(
                                        builder: (
                                          BuildContext context,
                                          BoxConstraints constraints,
                                        ) {
                                          return Align(
                                            alignment: Alignment(
                                              0.08,
                                              -1,
                                            ), // Adjust alignment as needed
                                            child: Container(
                                              // Adjust this value to move the image slightly to the right
                                              width: constraints.maxWidth / 2.4,
                                              child: Image.asset(
                                                "images/Plastic.png",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  Center(
                                    heightFactor: 2,
                                    child: LayoutBuilder(
                                      builder: (
                                        BuildContext context,
                                        BoxConstraints constraints,
                                      ) {
                                        return Column(
                                          children: [
                                            Text(
                                              typeValue.toUpperCase(),
                                              style: TextStyle(
                                                fontFamily: "CustomFont",
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                                fontSize:
                                                    constraints.maxWidth /
                                                    13, // Adjust the divisor as needed
                                              ),
                                            ),
                                            Text(
                                              // ignore: prefer_interpolation_to_compose_strings
                                              unitValue == "Metric"
                                                  ? "${weight.toInt()}${" " + DataManager.fieldWeight[unitIndex]}"
                                                  : "${DataProvider.ConvertUnit(unitValue, "kg", weight).toStringAsFixed(1)}${" " + DataManager.fieldWeight[unitIndex]}",
                                              style: TextStyle(
                                                fontFamily: "CustomFont",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize:
                                                    constraints.maxWidth / 24,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                weight >= 100 && typeValue == "Carton"
                    ? FilledButton.icon(
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
                        "Too much load",
                        style: TextStyle(
                          fontFamily: "CustomFont",
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      icon: Icon(Icons.warning, color: Colors.red),
                    )
                    : FilledButton.icon(
                      onPressed: () async {
                        Navigator.of(
                          context,
                        ).push(CustomPageRoute.createRout(Result(), "result"));
                        if (PageManager.Fromstraight == true) {
                          Provider.of<PageManager>(
                            context,
                            listen: false,
                          ).updateStraightPage(2);
                        } else {
                          Provider.of<PageManager>(
                            context,
                            listen: false,
                          ).updateCurvedPage(2);
                        }
                        await DataProvider.algo();

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
                        "RESULT",
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
                    ),
          ),
        ],
      ),
    );
  }
}
