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
    double _width = num.parse(map?['width'] ?? '0.0').toDouble();
    return Border.all(
      color: HexColor.fromHex(map?['color']),
      width: _width,
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
          radius: double.parse(map?['radius'] ?? '0.5'),
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
      blurRadius: map['blurRadius'],
      offset: Offset(map['offsetX'], map['offsetY']),
      spreadRadius: map['spreadRadius'],
    );
  }
}
