import 'package:dynamic_widget/dynamic_widget/extension/color_extension.dart';
import 'package:dynamic_widget/dynamic_widget/extension/string_extension.dart';
import 'package:flutter/material.dart';

extension BoxDecorationX on BoxDecoration {
  static BoxDecoration fromJson(Map<String, dynamic> map) {
    return BoxDecoration(
      color: HexColor.fromHex(map['color']),
      borderRadius: map['borderRadius'] != null ? (map['borderRadius'] as String).getBorderRadiusFromString() : null,
      gradient: GradientX.fromJson(map['gradient']),
      boxShadow: map['boxShadow']?.map((e) => BoxShadowX.fromJson(e)).toList(),
    );
  }
}

extension GradientX on Gradient {
  static Gradient? fromJson(List<dynamic>? colors) {
    if (colors == null) return null;
    return LinearGradient(
      colors: colors.map((e) => HexColor.fromHex(e)).toList(),
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}

extension BoxShadowX on BoxShadow {
  static BoxShadow fromJson(Map<String, dynamic> map) {
    return BoxShadow(
      color: HexColor.fromHex(map['color']),
      blurRadius: map['blurRadius'],
      offset: Offset(map['offsetX'], map['offsetY']),
      spreadRadius: map['spreadRadius'],
    );
  }
}
