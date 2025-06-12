import 'package:dynamic_widget/dynamic_widget/extension/color_extension.dart';
import 'package:flutter/widgets.dart';

extension StringX on String {
  double getSizeFromString() {
    bool isNum = num.tryParse(this) != null;
    if (isNum) {
      return double.parse(this);
    }
    if (contains('auto')) {
      return double.maxFinite;
    }
    return double.infinity;
  }

  Alignment? getAlignmentFromString() {
    if (contains('topLeft')) {
      return Alignment.topLeft;
    }
    if (contains('topRight')) {
      return Alignment.topRight;
    }
    if (contains('topCenter')) {
      return Alignment.topCenter;
    }
    if (contains('bottomCenter')) {
      return Alignment.bottomCenter;
    }
    if (contains('bottomLeft')) {
      return Alignment.bottomLeft;
    }
    if (contains('bottomRight')) {
      return Alignment.bottomRight;
    }
    if (contains('centerLeft')) {
      return Alignment.centerLeft;
    }
    if (contains('centerRight')) {
      return Alignment.centerRight;
    }
    if (contains('center')) {
      return Alignment.center;
    }
    return null;
  }

  EdgeInsets? getEdgeInsetsFromString() {
    if (contains('0,0,0,0')) {
      return EdgeInsets.zero;
    }
    return EdgeInsets.fromLTRB(
      double.parse(split(',')[0]),
      double.parse(split(',')[1]),
      double.parse(split(',')[2]),
      double.parse(split(',')[3]),
    );
  }

  Color? getColorFromString() {
    return HexColor.fromHex(this);
  }
}
