import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/material.dart';

class FlexibleWidgetParser extends WidgetParser {
  @override
  Widget parse(
      Map<String, dynamic> map, BuildContext context, ClickListener? listener) {
    return FlexibleWidget(
      flex: map['flex'],
      fit: map['fit'] != null ? parseFlexFit(map['fit']) : FlexFit.loose,
      child:
          DynamicWidgetBuilder.buildFromMap(map['child'], context, listener) ??
              const SizedBox.shrink(),
    );
  }

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as FlexibleWidget;
    return <String, dynamic>{
      "type": "Flexible",
      "flex": realWidget.flex,
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext)
    };
  }

  @override
  String get widgetName => "FlexibleWidget";

  @override
  Type get widgetType => FlexibleWidget;
}

class FlexibleWidget extends StatelessWidget {
  const FlexibleWidget(
      {super.key,
      required this.flex,
      required this.child,
      this.fit = FlexFit.loose});

  final int flex;
  final Widget child;
  final FlexFit fit;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: child,
    );
  }
}
