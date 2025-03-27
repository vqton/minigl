import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IconService {
  static Future<Map<String, IconData>> loadIcons() async {
    final String jsonString = await rootBundle.loadString('assets/icons.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    Map<String, IconData> iconMap = {};
    
    for (var category in jsonData) {
      for (var iconName in category["icons"]) {
        iconMap[iconName] = _getIconData(iconName);
      }
    }

    return iconMap;
  }

  static IconData _getIconData(String iconName) {
    return iconDataMapping[iconName] ?? Icons.help_outline;
  }

  static const Map<String, IconData> iconDataMapping = {
    "account_balance": Icons.account_balance,
    "credit_card": Icons.credit_card,
    "local_atm": Icons.local_atm,
    "account_balance_wallet": Icons.account_balance_wallet,
    "work_outline": Icons.work_outline,
    "request_page": Icons.request_page,
    "receipt": Icons.receipt,
    "payment": Icons.payment,
    "trending_up": Icons.trending_up,
    "show_chart": Icons.show_chart,
    "pie_chart": Icons.pie_chart,
    "savings": Icons.savings,
    "shopping_cart": Icons.shopping_cart,
    "restaurant": Icons.restaurant,
    "directions_car": Icons.directions_car,
    "local_gas_station": Icons.local_gas_station,
    // Add more mappings...
  };
}
