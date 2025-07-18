import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:conveydyn_wizard/Component/showCompteConfirmation.dart';
import 'package:conveydyn_wizard/Service/Model.dart';
import '../Utils/constant.dart'; // Removed because the file does not exist
import 'package:conveydyn_wizard/Service/DataManager.dart';

Future<bool> sendAccount(Map<String, dynamic> data, BuildContext context) async {

  Completer<bool> completer = Completer<bool>();
  try {
    //final response = await http.post(Constant_Url().Api_Url, body: data);
    final response = await http.post(
      Uri.parse('http://192.168.193.23:5226/accounts/send-confirmation-mail'),
      //Constant_Url().Api_Url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    print("le status de reponse ${response.statusCode}");

    if (response.statusCode == 200) {
      final email = data['Email'] as String?;
      if (email != null) {
        await showConfirmationCodeDialog(context, email, completer); // ← tu passes le completer
        return await completer.future; // ← ici tu attends le résultat
      } else {
        print("Email est null, impossible d’ouvrir le popup");
        return false;
      }
    } else if(response.statusCode == 409){
       print("User already existe but updated :) ${data["FirstName"]}");
       return true;
    }else{
      final data = jsonDecode(response.body);
      print("Erreur");
      return false;
    }
  } catch (e) {
    print("Erreur réseau : $e");
     return false;
  }
}

Future<void> sendMail(BuildContext context) async {
  var DataProvider = Provider.of<DataManager>(context, listen: false);
  var unit = DataProvider.unitIndex;
  final buffer = StringBuffer();
  buffer.writeln("Hutchinson is pleased to send you the Conveyxonic® Wizard App result:\n");
  buffer.writeln("📌 CONVEYXONIC® 2 PJ 416");
  buffer.writeln("🔧 Belt width: ${DataProvider.Betlwidth} ${DataManager.fieldLong[unit]}");
  buffer.writeln("⚡ Required power: ${DataProvider.p(DataProvider.typeValue)} Watt");
  buffer.writeln("🔩 Belt tension: ${DataProvider.BeltTension.toInt()} N/span");
  buffer.writeln("📈 Tangent load: ${(DataProvider.loadForce(DataProvider.typeValue) * 10).roundToDouble() / 10} N");
  buffer.writeln("🌀 Required torque: ${DataProvider.ReqTorque()} ${DataManager.fieldTorque[unit]}\n");

  buffer.writeln("📐 TRANSMISSION GEOMETRY");
  buffer.writeln("• Roller diameter: ${DataProvider.rollerValue} ${DataManager.fieldLong[unit]} ");
  buffer.writeln("• Pulley diameter:  ${DataProvider.pullyValue} ${DataManager.fieldLong[unit]}");
  buffer.writeln("• Center distance: ${DataProvider.centerValue} ${DataManager.fieldLong[unit]}");
  buffer.writeln("• Number of rollers: ${DataProvider.numberRoller}\n");

  buffer.writeln("📦 LOAD TO CARRY");
  buffer.writeln("• Load weight: ${DataProvider.weight} ${DataManager.fieldWeight[unit]}");
  buffer.writeln("• Load type: ${DataProvider.typeValue} ");
  buffer.writeln("• Inclination: ${DataProvider.incline}  %");
  buffer.writeln("• Linear speed: ${DataProvider.speed}  ${DataManager.fieldLSpeed[unit]}\n");

  buffer.writeln("📌 Disclaimer:");
  buffer.writeln("This app should be used for a preliminary concept of the belt for your application. "
      "Please contact us to review or optimize your transmission design.");

  buffer.writeln("\n⚠️ In case of intensive use of the start and stop mode, please contact us to validate the solution.");

  buffer.writeln("\n \n \n📧  To order your belt, feel free to contact us at: belt.drives@hutchinson.com");
  buffer.writeln("If you need more specific information do not hesitate in contacting our technical team : +33 2 47 48 39 99.");
  buffer.writeln("Do not hesitate in visiting our website www.hutchinsontransmission.com.");
  
  final bodyText = buffer.toString();
  await http.post(
    Uri.parse('http://192.168.193.23:5226/send-result'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "to": DataProvider.email,//"anismekbal11@gmail.com", 
      "subject": "ConveYdyn Wizard", 
      "body": bodyText,
    }),
  );

  String label = "Email has been sent successfuly";
  DataProvider.updateMailLabel(label);

  print("message sent successfully compiled ...");
}

Future<void> confirmEmail(BuildContext context,String code, String email, Completer<bool> completer) async {

  try{
    final response = await http.post(
      Uri.parse("http://192.168.193.23:5226/accounts/confirm-email?code=$code&email=$email"),
    );

    print("Response status: ${response.statusCode}");
    var DataProvider = Provider.of<DataManager>(context, listen: false);

    if (response.statusCode == 200) {
      if (!completer.isCompleted) {
        completer.complete(true);
      }; // ← ici tu valides le Future

      DataProvider.updateValidEmail(true); // Met à jour l'état de l'email validé
      print("rentre code valide : mise a joure a true Valide EMAIL");
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Confirmation réussie !", style: TextStyle(fontFamily: "CustomFont",))),
      );
    } else {
      if (!completer.isCompleted) {
        completer.complete(false);
      } // ← sinon, tu complètes avec false

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Code invalide ou expiré.", style: TextStyle(fontFamily: "CustomFont",))),
      );
    }
  }catch(e){

  }
   
}

Future<Account> fetchUserByEmail(String email) async {
  final response = await http.get(Uri.parse("http://192.168.193.23:5226/accounts/get-by-email?email=$email"));
  if(response.statusCode == 200){
    final data = jsonDecode(response.body);
    return Account.fromJson(data); // Retourne les données de l'utilisateur
  }else{
    print("Erreur lors de la récupération de l'utilisateur : ${response.statusCode}");
    return Future.error("Erreur lors de la récupération de l'utilisateur");
  }
}

Future<void> updateAccount(Map<String, dynamic> account) async{
  final response = await http.put(
    Uri.parse("http://192.168.193.23:5226/accounts/update-account"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(account),
  );

  if (response.statusCode == 200) {
    print("Compte mis à jour avec succès");
  } else {
    print("Erreur lors de la mise à jour du compte : ${response.statusCode}");
    throw Exception("Erreur lors de la mise à jour du compte");
  }
}