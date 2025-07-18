import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:conveydyn_wizard/Component/SettingPopPup.dart';
import 'package:conveydyn_wizard/Presentation/StraightConveyor/TransmissionGeometry.dart';
import 'package:conveydyn_wizard/Presentation/contact.dart';
import 'package:conveydyn_wizard/Presentation/user_account.dart';
import 'package:conveydyn_wizard/Service/customroute.dart';
import 'package:conveydyn_wizard/Presentation/home.dart';
import 'package:conveydyn_wizard/Presentation/settings.dart';
import '../Service/PageManager.dart';
import '../Service/DataManager.dart';
import 'package:provider/provider.dart';
import '../Utils/helper.dart';
import '../Utils/constant.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  int _selectedIndex = 0;

  static const TextStyle petitEcran = TextStyle(
    fontFamily: "CustomFont",
    fontSize: 13,
    color: Colors.white,
  );

  static const TextStyle grandEcran = TextStyle(
    fontFamily: "CustomFont",
    fontSize: 17,
    color: Colors.white,
  );

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _isCurrentRoute(String routeName) {
    bool isCurrent = false;
    _navigatorKey.currentState?.popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }

  GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HelpersFunct().checkAndShowConsent(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    var DataProvider = Provider.of<DataManager>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SliderDrawer(
              key: _sliderDrawerKey,
              appBar: AppBar(
                backgroundColor: const Color(0xFF142559),
                toolbarHeight: kToolbarHeight,
                title: Consumer<DataManager>(
                  builder: (context, dataProvider, child) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        final inAnimation = Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation);

                        final outAnimation = Tween<Offset>(
                          begin: const Offset(-1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation);

                        return SlideTransition(
                          position:
                              child.key == ValueKey(DataProvider.title)
                                  ? inAnimation
                                  : outAnimation,
                          child: child,
                        );
                      },
                      child: Text(
                        DataProvider.title,
                        key: ValueKey(DataProvider.title),
                        style: const TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                actions: const [Icon(Icons.menu, color: Colors.white)],
              ),

              sliderOpenSize:
                  MediaQuery.of(context).size.width > 400 ? 300 : 230,
              sliderCloseSize: 0,
              
              slider: Container(
                //color: Color(0xFF142559),
                decoration: const BoxDecoration(
                  color: Color(0xFF142559),
                  border: Border(
                    left: BorderSide(
                      color: Colors.white,
                      width: 2, // Épaisseur du trait
                    ),
                  ),
                ),
                
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  children: [
                    ListTile(
                      dense: true,
                      //contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      title: Container(
                        //height: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _sliderDrawerKey.currentState?.closeSlider();
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: Colors.white, height: 10),
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -4),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.home,
                              color: Colors.white,
                              size:
                                  MediaQuery.of(context).size.width > 400
                                      ? 30
                                      : 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Home",
                              style:
                                  MediaQuery.of(context).size.width > 400
                                      ? grandEcran
                                      : petitEcran,
                            ),
                          ],
                        ),
                      ),
                      selected:
                          Provider.of<PageManager>(context).currentPage == 0,
                      //_selectedIndex == 0,
                      onTap: () {
                        onItemTapped(0);
                        _sliderDrawerKey.currentState?.closeSlider();
                        if (!_isCurrentRoute('home')) {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            _navigatorKey.currentState?.push(
                              CustomPageRoute.RoutHome(Home(), "home"),
                            );
                          });
                        }
                        DataProvider.updateTitle("CONVEYDYN® WIZARD");
                      },
                    ),
                    Divider(color: const Color.fromRGBO(255, 255, 255, 1), height: 10),
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -4),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      //contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                              size:
                                  MediaQuery.of(context).size.width > 400
                                      ? 30
                                      : 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "User account",
                              style:
                                  MediaQuery.of(context).size.width > 400
                                      ? grandEcran
                                      : petitEcran,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        onItemTapped(1);
                        _sliderDrawerKey.currentState?.closeSlider();
                        if (!_isCurrentRoute('user')) {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            _navigatorKey.currentState?.push(
                              CustomPageRoute.createRout(
                                UserAccount(navigatorKey: _navigatorKey),
                                "user",
                              ),
                            );
                          });
                        }
                        DataProvider.updateTitle("CONVEYDYN® WIZARD");
                      },
                    ),
                    Divider(color: Colors.white, height: 10),
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -4),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      //contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.settings,
                              color: Colors.white,
                              size:
                                  MediaQuery.of(context).size.width > 400
                                      ? 30
                                      : 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Settings",
                              style:
                                  MediaQuery.of(context).size.width > 400
                                      ? grandEcran
                                      : petitEcran,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        onItemTapped(1);
                        _sliderDrawerKey.currentState?.closeSlider();
                        if (!_isCurrentRoute('settings')) {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            _navigatorKey.currentState?.push(
                              CustomPageRoute.createRout(
                                Settings(navigatorKey: _navigatorKey),
                                "settings",
                              ),
                            );
                          });
                        }
                        DataProvider.updateTitle("CONVEYDYN® WIZARD");
                      },
                    ),
                    Divider(color: Colors.white, height: 10),
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -4),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.insert_drive_file,
                              color: Colors.white,
                              size:
                                  MediaQuery.of(context).size.width > 400
                                      ? 30
                                      : 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Product Information",
                              style:
                                  MediaQuery.of(context).size.width > 400
                                      ? grandEcran
                                      : petitEcran,
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        HelpersFunct().launch_Url(
                          Constant_Url().url_product_info,
                        );
                      },
                    ),
                    Divider(color: Colors.white, height: 10),
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -4),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      //contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.white,
                              size:
                                  MediaQuery.of(context).size.width > 400
                                      ? 30
                                      : 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Contact",
                              style:
                                  MediaQuery.of(context).size.width > 400
                                      ? grandEcran
                                      : petitEcran,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        onItemTapped(1);
                        _sliderDrawerKey.currentState?.closeSlider();
                        if (!_isCurrentRoute('contact')) {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            _navigatorKey.currentState?.push(
                              CustomPageRoute.createRout(
                                Contact(navigatorKey: _navigatorKey),
                                "contact",
                              ),
                            );
                          });
                        }
                        DataProvider.updateTitle("CONVEYDYN® WIZARD");
                      },
                    ),
                    Divider(color: Colors.white, height: 10),
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -4),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      //contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: Colors.white,
                              size:
                                  MediaQuery.of(context).size.width > 400
                                      ? 30
                                      : 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Terms of Use",
                              style:
                                  MediaQuery.of(context).size.width > 400
                                      ? grandEcran
                                      : petitEcran,
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        HelpersFunct().launch_Url(
                          Constant_Url().url_terms_of_use,
                        );
                      },
                    ),
                    Divider(color: Colors.white, height: 10),
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -4),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      //contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Container(
                        child: Row(
                          children: [
                            Image.asset(
                              "images/privacy.png",
                              width:
                                  MediaQuery.of(context).size.width > 400
                                      ? 27
                                      : 18,
                              height:
                                  MediaQuery.of(context).size.width > 400
                                      ? 27
                                      : 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Privacy Policy and cookies",
                              style:
                                  MediaQuery.of(context).size.width > 400
                                      ? grandEcran
                                      : petitEcran,
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        HelpersFunct().launch_Url(
                          Constant_Url().url_terms_of_use,
                        );
                      },
                    ),
                    Divider(color: Colors.white, height: 10),
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -4),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      //contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Container(
                        child: Row(
                          children: [
                            Image.asset(
                              "images/logo_blanc.png",
                              width:
                                  MediaQuery.of(context).size.width > 400
                                      ? 32
                                      : 22,
                              height:
                                  MediaQuery.of(context).size.width > 400
                                      ? 32
                                      : 22,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Website",
                              style:
                                  MediaQuery.of(context).size.width > 400
                                      ? grandEcran
                                      : petitEcran,
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        HelpersFunct().launch_Url(
                          Constant_Url().url_terms_of_use,
                        );
                      },
                    ),
                    Divider(color: Colors.white, height: 10),
                  ],
                ),
              ),
              slideDirection: SlideDirection.rightToLeft,
              child: Column(
                children: [
                  AppBar(
                    toolbarHeight: 42,
                    backgroundColor: const Color(0xFF142559),
                    title: Row(
                      children: [
                        SizedBox(width: 25),
                        Spacer(),
                        Center(
                          child: Consumer<DataManager>(
                            builder: (context, dataProvider, child) {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (
                                  Widget child,
                                  Animation<double> animation,
                                ) {
                                  final inAnimation = Tween<Offset>(
                                    begin: const Offset(
                                      1.0,
                                      0.0,
                                    ), // entre par la droite
                                    end: Offset.zero,
                                  ).animate(animation);

                                  final outAnimation = Tween<Offset>(
                                    begin: const Offset(-1.0, 0.0),
                                    end: Offset.zero, // sort vers la gauche
                                  ).animate(animation);

                                  return SlideTransition(
                                    position:
                                        child.key ==
                                                ValueKey(DataProvider.title)
                                            ? inAnimation
                                            : outAnimation,
                                    child: child,
                                  );
                                },

                                child: Text(
                                  DataProvider.title,
                                  key: ValueKey(DataProvider.title),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'CustomFont',
                                    fontSize: 18.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            _sliderDrawerKey.currentState?.openSlider();
                          },
                          child: Icon(Icons.menu, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: 
                  Navigator(
                    key: _navigatorKey, //pour gérer l'animation de contenu
                    onGenerateRoute: (RouteSettings settings) {
                      return MaterialPageRoute(
                        builder: (context) => Home(), // page par défaut
                      );
                    },
                  ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onHorizontalDragUpdate: (_) {}, // intercepte les swipes
                behavior: HitTestBehavior.translucent,
              ),
            ),
            Image.asset("images/triangle_vert.png", scale: 2.2),
          ],
        ),
      ),
    );
  }
}
