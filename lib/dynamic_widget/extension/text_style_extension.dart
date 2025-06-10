import 'package:dynamic_widget/dynamic_widget/extension/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension MapX on Map<String, dynamic>? {
  TextStyle getTextStyleFromJson() {
    if (this == null) return TextStyle();
    return TextStyle(
      fontFamily: GoogleFonts.getFont(this?['fontFamily'] ?? 'Inter').fontFamily,
      fontSize: this?['fontSize']?.toDouble(),
      fontWeight: this?['fontWeight'] != null ? FontWeightX.fromJson(this?['fontWeight']) : FontWeight.normal,
      color: this?['color'] != null ? HexColor.fromHex(this?['color']) : Colors.black,
      fontStyle: this?['fontStyle'] != null ? FontStyleX.fromJson(this?['fontStyle']) : FontStyle.normal,
      decoration: this?['decoration'] != null ? TextDecorationX.fromJson(this?['decoration']) : TextDecoration.none,
    );
  }
}

extension TextStyleX on TextStyle {
  static TextStyle fromJson(Map<String, dynamic> map) {
    return TextStyle(
      fontFamily: GoogleFonts.getFont(map['fontFamily'] ?? 'Inter').fontFamily,
      fontSize: map['fontSize']?.toDouble(),
      fontWeight: map['fontWeight'] != null ? FontWeightX.fromJson(map['fontWeight']) : FontWeight.normal,
      color: map['color'] != null ? HexColor.fromHex(map['color']) : Colors.black,
      fontStyle: map['fontStyle'] != null ? FontStyleX.fromJson(map['fontStyle']) : FontStyle.normal,
      decoration: map['decoration'] != null ? TextDecorationX.fromJson(map['decoration']) : TextDecoration.none,
    );
  }
}

extension TextDecorationX on TextDecoration {
  static TextDecoration fromJson(String? decoration) {
    if (decoration == null) return TextDecoration.none;
    switch (decoration) {
      case 'none':
        return TextDecoration.none;
      case 'underline':
        return TextDecoration.underline;
      case 'overline':
        return TextDecoration.overline;
      case 'lineThrough':
        return TextDecoration.lineThrough;
      default:
        return TextDecoration.none;
    }
  }
}

extension FontStyleX on FontStyle {
  static FontStyle fromJson(dynamic fontStyle) {
    if (fontStyle == null) return FontStyle.normal;
    switch (fontStyle.toLowerCase()) {
      case 'italic':
        return FontStyle.italic;
      case 'normal':
        return FontStyle.normal;
      default:
        return FontStyle.normal;
    }
  }
}

extension FontWeightX on FontWeight {
  static FontWeight? fromJson(dynamic fontWeight) {
    if (fontWeight == null) return null;
    if (fontWeight is String) {
      switch (fontWeight.toLowerCase()) {
        case 'bold':
          return FontWeight.bold;
        case 'normal':
          return FontWeight.normal;
        case 'w100':
          return FontWeight.w100;
        case 'w200':
          return FontWeight.w200;
        case 'w300':
          return FontWeight.w300;
        case 'w400':
          return FontWeight.w400;
        case 'w500':
          return FontWeight.w500;
        case 'w600':
          return FontWeight.w600;
        case 'w700':
          return FontWeight.w700;
        case 'w800':
          return FontWeight.w800;
        case 'w900':
          return FontWeight.w900;
        default:
          return FontWeight.normal;
      }
    }
    return null;
  }
}
