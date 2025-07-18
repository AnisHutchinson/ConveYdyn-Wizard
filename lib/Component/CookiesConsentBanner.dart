import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CookieConsentBanner extends StatefulWidget {
  final String userEmail;

  const CookieConsentBanner({required this.userEmail, super.key});

  @override
  State<CookieConsentBanner> createState() => _CookieConsentBannerState();
}

class _CookieConsentBannerState extends State<CookieConsentBanner> {
  bool pianoAnalytics = false;
  bool oneSignal = false;
  bool showBanner = true;

  @override
  void initState() {
    super.initState();
    _checkConsent();
  }

  Future<void> _checkConsent() async {
    final prefs = await SharedPreferences.getInstance();
    final consentGiven = prefs.getBool('consent_given') ?? false;
    if (consentGiven) {
      setState(() => showBanner = false);
    }
  }

  Future<void> _saveConsent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('consent_given', true);
    await prefs.setBool('piano_analytics', pianoAnalytics);
    await prefs.setBool('one_signal', oneSignal);

    // Envoi au backend
    final response = await http.post(
      Uri.parse('https://ton-backend.com/api/consent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.userEmail,
        'consent': {'piano_analytics': pianoAnalytics, 'one_signal': oneSignal},
      }),
    );

    if (response.statusCode == 200) {
      setState(() => showBanner = false);
    } else {
      // Gérer l'erreur
      print('Erreur lors de l\'envoi du consentement');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!showBanner) return const SizedBox.shrink();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Material(
        elevation: 10,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Nous utilisons des cookies pour améliorer votre expérience.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CheckboxListTile(
                title: const Text('Piano Analytics'),
                value: pianoAnalytics,
                onChanged: (val) => setState(() => pianoAnalytics = val!),
              ),
              CheckboxListTile(
                title: const Text('Notifications (OneSignal)'),
                value: oneSignal,
                onChanged: (val) => setState(() => oneSignal = val!),
              ),
              ElevatedButton(
                onPressed: () {}, //_saveConsent,
                child: const Text('Enregistrer mes choix'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
