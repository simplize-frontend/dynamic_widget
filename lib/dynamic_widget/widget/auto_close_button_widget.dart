import 'dart:async';

import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/extension/string_extension.dart';
import 'package:dynamic_widget/dynamic_widget/extension/text_style_extension.dart';
import 'package:flutter/material.dart';

class AutoCloseButtonWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext context, ClickListener? listener) {
    return AutoCloseButtonWidget(
      closeAfter: map['closeAfter'],
      textStyle: map['textStyle'] != null ? TextStyleX.fromJson(map['textStyle']) : null,
      gap: (map['gap'] as String?)?.getSizeFromString() ?? 0.0,
      closeIcon:
          map['closeIcon'] != null ? DynamicWidgetBuilder.buildFromMap(map['closeIcon'], context, listener) : null,
    );
  }

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    return null;
  }

  @override
  String get widgetName => 'AutoCloseButtonWidget';

  @override
  Type get widgetType => AutoCloseButtonWidget;
}

class AutoCloseButtonWidget extends StatefulWidget {
  const AutoCloseButtonWidget({super.key, required this.closeAfter, this.textStyle, this.gap = 0.0, this.closeIcon});
  final int closeAfter;
  final TextStyle? textStyle;
  final double gap;
  final Widget? closeIcon;

  @override
  State<AutoCloseButtonWidget> createState() => _AutoCloseButtonWidgetState();
}

class _AutoCloseButtonWidgetState extends State<AutoCloseButtonWidget> {
  Timer? _timer;
  int _countDown = 0;
  @override
  void initState() {
    super.initState();
    _countDown = widget.closeAfter;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countDown <= 0) {
        _timer?.cancel();
        return;
      }
      setState(() {
        _countDown--;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: widget.gap,
      children: [
        if (_countDown > 0) ...[Text("Đóng sau $_countDown giây", style: widget.textStyle)],
        Icon(Icons.close, size: 12, color: Colors.white),
      ],
    );
  }
}
