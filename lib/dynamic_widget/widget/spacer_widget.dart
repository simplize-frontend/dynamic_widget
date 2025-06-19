import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/widgets.dart';

class SpacerWidgetParser extends WidgetParser {
  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    return null;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    return const SpacerWidget();
  }

  @override
  String get widgetName => "SpacerWidget";

  @override
  Type get widgetType => Spacer;
}

class SpacerWidget extends StatelessWidget {
  const SpacerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Spacer();
  }
}
