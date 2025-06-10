import 'package:dynamic_widget/dynamic_widget/extension/box_decoration_extension.dart';
import 'package:dynamic_widget/dynamic_widget/extension/string_extension.dart';
import 'package:dynamic_widget/dynamic_widget/extension/text_style_extension.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_widget/dynamic_widget.dart';

class ButtonWidgetParser extends WidgetParser {
  @override
  String get widgetName => 'ButtonWidget';

  @override
  Type get widgetType => ButtonWidget;

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    return null;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    return ButtonWidget(
      onPressed: () => listener?.onClicked(map['onClick']),
      text: map['text'],
      width: (map['width'] as String).getSizeFromString(),
      height: (map['height'] as String).getSizeFromString(),
      decoration: map['decoration'] != null ? BoxDecorationX.fromJson(map['decoration']) : null,
      textStyle: map['textStyle'] != null ? TextStyleX.fromJson(map['textStyle']) : null,
    );
  }
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.decoration,
    this.textStyle,
  });
  final Function() onPressed;
  final String text;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final BoxDecoration? decoration;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? double.infinity, height ?? 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        backgroundBuilder: (context, states, child) {
          return Container(decoration: decoration, child: child);
        },
        backgroundColor: Colors.transparent,
      ),
      child: Text(text, style: textStyle),
    );
  }
}
