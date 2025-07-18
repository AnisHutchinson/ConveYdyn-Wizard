import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conveydyn_wizard/Service/DataManager.dart';
import 'package:conveydyn_wizard/Utils/helper.dart';
import 'Component/drawer.dart';
import 'package:provider/provider.dart';
import 'Service/PageManager.dart';
import 'Service/interaction.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Service/SharedPref.dart';
// ...
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize Firebase

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Enable verbose logging for debugging (remove in production)
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // Initialize with your OneSignal App ID
  OneSignal.initialize("8f17a8e7-d306-4ba5-824d-f51fbe71ecfb");
  // Use this method to prompt for push notifications.
  // We recommend removing this method after testing and instead use In-App Messages to prompt for notification permission.
  await OneSignal.Notifications.requestPermission(true);
  //SharedPreferenceHelper().savedSignalPush(reponse);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageManager()),
        ChangeNotifierProvider(
          create: (context){
            final manager = DataManager();
            manager.init(); // charge les données persistée
            return manager;
          },
        ),
      ],
      child: MyApp(), 
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //handleIncomingLinks();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conveydyn Wizard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: DrawerWidget(),
    );
  }
}