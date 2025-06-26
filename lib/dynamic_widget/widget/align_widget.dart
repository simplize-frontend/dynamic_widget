import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';

class AlignWidgetParser extends WidgetParser {
  @override
  Widget parse(
      Map<String, dynamic> map, BuildContext context, ClickListener? listener) {
    return AlignWidget(
      child:
          DynamicWidgetBuilder.buildFromMap(map['child'], context, listener) ??
              const SizedBox.shrink(),
      start: map['start']?.toDouble(),
      y: map['y']?.toDouble(),
    );
  }

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as AlignWidget;
    return <String, dynamic>{
      "type": "Align",
      "start": realWidget.start,
      "y": realWidget.y,
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext)
    };
  }

  @override
  String get widgetName => "AlignWidget";

  @override
  Type get widgetType => AlignWidget;
}

class AlignWidget extends StatelessWidget {
  const AlignWidget(
      {super.key, required this.child, required this.start, required this.y});

  final double start;
  final double y;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(start, y),
      child: child,
    );
  }
}
