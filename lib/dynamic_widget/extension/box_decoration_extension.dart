import 'package:dynamic_widget/dynamic_widget/extension/color_extension.dart';
import 'package:dynamic_widget/dynamic_widget/extension/string_extension.dart';
import 'package:flutter/material.dart';

extension BoxDecorationX on BoxDecoration {
  static BoxDecoration fromJson(Map<String, dynamic>? map, {String? color}) {
    return BoxDecoration(
      color: color != null
          ? HexColor.fromHex(color)
          : map?['color'] != null
              ? HexColor.fromHex(map?['color'])
              : null,
      borderRadius:
          map?['borderRadius'] != null ? (map?['borderRadius'] as String?)?.getBorderRadiusFromString() : null,
      gradient: GradientX.fromJson(map?['gradient']),
      boxShadow: map?['boxShadow']?.map((e) => BoxShadowX.fromJson(e)).toList(),
      border: map?['border'] != null ? BorderX.fromJson(map?['border']) : null,
    );
  }
}

extension BorderX on Border {
  static Border fromJson(Map<String, dynamic>? map) {
    double width = _parseDouble(map?['width']) ?? 0.0;
    return Border.all(
      color: HexColor.fromHex(map?['color']),
      width: width,
      style: BorderStyle.solid,
    );
  }
}

extension GradientX on Gradient {
  static Gradient? fromJson(Map<String, dynamic>? map) {
    if (map?['colors'] == null) return null;
    List<Color> colors = (map?['colors'] as List<dynamic>).map((e) => HexColor.fromHex(e as String)).toList();
    switch (map?['type']) {
      case 'linear':
        return LinearGradient(
          colors: colors,
          begin: (map?['begin'] as String?)?.getAlignmentFromString() ?? Alignment.centerLeft,
          end: (map?['end'] as String?)?.getAlignmentFromString() ?? Alignment.centerRight,
        );

      case 'radial':
        return RadialGradient(
          colors: colors,
          radius: _parseDouble(map?['radius']) ?? 0.5,
          focal: (map?['focal'] as String?)?.getAlignmentFromString() ?? Alignment.center,
        );

      default:
        return LinearGradient(
          colors: colors,
          begin: (map?['begin'] as String?)?.getAlignmentFromString() ?? Alignment.centerLeft,
          end: (map?['end'] as String?)?.getAlignmentFromString() ?? Alignment.centerRight,
        );
    }
  }
}

extension BoxShadowX on BoxShadow {
  static BoxShadow fromJson(Map<String, dynamic> map) {
    return BoxShadow(
      color: HexColor.fromHex(map['color']),
      blurRadius: _parseDouble(map['blurRadius']) ?? 0.0,
      offset: Offset(
        _parseDouble(map['offsetX']) ?? 0.0,
        _parseDouble(map['offsetY']) ?? 0.0,
      ),
      spreadRadius: _parseDouble(map['spreadRadius']) ?? 0.0,
    );
  }
}

// Helper function to safely parse dynamic values to double
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }
  return null;
}
