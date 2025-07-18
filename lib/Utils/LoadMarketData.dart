import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LoadData {
  Map<String, dynamic>? marketData;

  Future<Map<String, dynamic>> loadMarketData() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/market.json',
      );
      marketData = jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Erreur lors du chargement des données : $e');
      marketData = {};
    }
    return marketData ?? {};
  }
}
