import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Service/interaction.dart';

Future<void> showConfirmationCodeDialog(BuildContext context, String userEmail, Completer<bool> completer) async{
  final TextEditingController codeController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: true,
    
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFF142559),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Center(
                child: Text(
                  "Confirmation du compte",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "CustomFont",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Entrez le code de confirmation reçu par email pour valider votre compte.",
                    style: TextStyle(color: Colors.grey, fontFamily: "CustomFont",),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Code de confirmation",
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () async {
                      final code = codeController.text.trim();
                      if (code.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Veuillez entrer le code", style: TextStyle(fontFamily: "CustomFont",),)),
                        );
                        return;
                      }
                      // Appel API pour valider le code
                      await confirmEmail(context, code, userEmail, completer);
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
                              Size(MediaQuery.of(context).size.width/3, 45),
                            ),
                          ),
                    icon: Icon(Icons.check, color: Colors.white),
                    label: Text(
                      "Valider",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "CustomFont",),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
