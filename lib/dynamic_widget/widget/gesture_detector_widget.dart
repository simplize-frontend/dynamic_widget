import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';

class GestureDetectorWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext context, ClickListener? listener) {
    return GestureDetectorWidget(
        child: DynamicWidgetBuilder.buildFromMap(map['child'], context, listener) ?? const SizedBox.shrink(),
        onTap: () => listener?.onClicked(map['onClick']));
  }

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    return null;
  }

  @override
  String get widgetName => 'GestureDetectorWidget';

  @override
  Type get widgetType => GestureDetectorWidget;
}

class GestureDetectorWidget extends StatelessWidget {
  const GestureDetectorWidget({super.key, required this.child, this.onTap});
  final Widget child;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, behavior: HitTestBehavior.translucent, child: child);
  }
}
