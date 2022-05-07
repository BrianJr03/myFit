import 'package:flutter/material.dart';

class FlutterFlowTheme {
  static const Color primaryColor = Color(0xFF000000);
  static const Color secondaryColor = Color(0xFF1434A4);
  static const Color tertiaryColor = Color(0xFFFFFFFF);

  static TextStyle get title1 => TextStyle().copyWith(
        fontFamily: 'Open Sans',
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 30,
      );
  static TextStyle get title2 => TextStyle().copyWith(
        fontFamily: 'Open Sans',
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      );
  static TextStyle get title3 => TextStyle().copyWith(
        fontFamily: 'Open Sans',
        color: primaryColor,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      );
  static TextStyle get title3Red => TextStyle().copyWith(
        fontFamily: 'Open Sans',
        color: Colors.pink[500],
        fontWeight: FontWeight.w600,
        fontSize: 18,
      );
  static TextStyle get subtitle1 => TextStyle().copyWith(
        fontFamily: 'Open Sans',
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );
  static TextStyle get subtitle2 => TextStyle().copyWith(
        fontFamily: 'Open Sans',
        color: primaryColor,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      );
  static TextStyle get subtitle3 => TextStyle().copyWith(
        fontFamily: 'Open Sans',
        color: FlutterFlowTheme.primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get bodyText1 => TextStyle().copyWith(
        fontFamily: 'Open Sans',
        color: primaryColor,
        fontWeight: FontWeight.normal,
        fontSize: 18,
      );
  static TextStyle get bodyText2 => TextStyle().copyWith(
        fontFamily: 'Open Sans',
        color: primaryColor,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );

  static Color dayToColor(String dayNum) {
    var color = primaryColor;
    switch (int.parse(dayNum)) {
      case 1:
        color = Colors.orange[600]!;
        break;
      case 2:
        color = secondaryColor;
        break;
      case 3:
        color = Colors.green[600]!;
        break;
      case 4:
        color = Colors.orange[600]!;
        break;
      case 5:
        color = secondaryColor;
        break;
      case 6:
        color = Colors.green[900]!;
        break;
      case 7:
        color = Colors.orange[600]!;
        break;
      case 8:
        color = secondaryColor;
        break;
      case 9:
        color = Colors.green[600]!;
        break;
      case 10:
        color = Colors.orange[600]!;
        break;
      case 11:
        color = secondaryColor;
        break;
      case 12:
        color = Colors.green[600]!;
        break;
      case 13:
        color = Colors.orange[600]!;
        break;
      case 14:
        color = secondaryColor;
        break;
      case 15:
        color = Colors.green[600]!;
        break;
      case 16:
        color = Colors.orange[600]!;
        break;
      case 17:
        color = secondaryColor;
        break;
      case 18:
        color = Colors.green[600]!;
        break;
      case 19:
        color = Colors.orange[600]!;
        break;
      case 20:
        color = secondaryColor;
        break;
      case 21:
        color = Colors.green[600]!;
        break;
      case 22:
        color = Colors.orange[600]!;
        break;
      case 23:
        color = secondaryColor;
        break;
      case 24:
        color = Colors.green[600]!;
        break;
      case 25:
        color = Colors.orange[600]!;
        break;
      case 26:
        color = secondaryColor;
        break;
      case 27:
        color = Colors.green[600]!;
        break;
      case 28:
        color = Colors.orange[600]!;
        break;
      case 29:
        color = secondaryColor;
        break;
      case 30:
        color = Colors.green[600]!;
        break;
      case 31:
        color = secondaryColor;
        break;
    }
    return color;
  }
}
