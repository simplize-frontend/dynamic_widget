import 'package:flutter/material.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/extension/string_extension.dart';

class ContainerWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext context, ClickListener? listener) {
    return ContainerWidget(
      width: map['width'] != null ? (map['width'] as String).getSizeFromString() : null,
      height: map['height'] != null ? (map['height'] as String).getSizeFromString() : null,
      alignment: map['alignment'] != null ? (map['alignment'] as String).getAlignmentFromString() : null,
      margin: map['margin'] != null ? (map['margin'] as String).getEdgeInsetsFromString() : null,
      padding: map['padding'] != null ? (map['padding'] as String).getEdgeInsetsFromString() : null,
      color: map['color'] != null ? (map['color'] as String).getColorFromString() : null,
      child: DynamicWidgetBuilder.buildFromMap(map['child'], context, listener) ?? const SizedBox.shrink(),
    );
  }

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    return null;
  }

  @override
  String get widgetName => 'ContainerWidget';

  @override
  Type get widgetType => ContainerWidget;
}

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.alignment,
    this.margin,
    this.padding,
    this.color,
  });

  final Widget child;
  final double? width;
  final double? height;
  final Alignment? alignment;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      margin: margin,
      padding: padding,
      color: color,
      child: child,
    );
  }
}
