import 'package:flutter/material.dart';

class PaymentColors {
  PaymentColors._();

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Existing Shopper primary colors
  static const Color shopperBlue = Color(0xFF00376A);
  static const Color shopperOrange = Color(0xFFF47320);

  // Payment tab colors
  static const Color tabSelected = shopperBlue;
  static const Color tabUnselected = Color(0xFFE5E5E5);

  // Common screen colors
  static const Color screenBackground = Color(0xFFF4F4F4);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text
  static const Color primaryText = Color(0xFF222222);
  static const Color secondaryText = Color(0xFF666666);
  static const Color lightText = Color(0xFF999999);

  // Divider
  static const Color divider = Color(0xFFE0E0E0);
}