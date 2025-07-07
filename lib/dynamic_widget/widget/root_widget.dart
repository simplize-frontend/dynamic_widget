import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/extension/string_extension.dart';
import 'package:flutter/material.dart';

class RootParser extends WidgetParser {
  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    return null;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    return Root(
      width: (map['width'] as String?)?.getSizeFromString(),
      height: (map['height'] as String?)?.getSizeFromString(),
      alignment: (map['display']['position'] as String?)?.getAlignmentFromString(),
      child: RootModeInheritedWidget(
        mode: map['mode'],
        child: DynamicWidgetBuilder.buildFromMap(map['child'], buildContext, listener) ?? const SizedBox.shrink(),
      ),
    );
  }

  @override
  String get widgetName => 'Root';

  @override
  Type get widgetType => Root;
}

class RootModeInheritedWidget extends InheritedWidget {
  RootModeInheritedWidget({
    super.key,
    required super.child,
    required this.mode,
  });
  final String? mode;

  bool get isModal => mode == 'modal';
  bool get isSticky => mode == 'sticky';
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class Root extends StatelessWidget {
  const Root({super.key, required this.child, this.width, this.height, this.alignment});

  final Widget child;
  final double? width;
  final double? height;
  final Alignment? alignment;
  @override
  Widget build(BuildContext context) {
    return Align(
      heightFactor: 1,
      alignment: alignment ?? Alignment.center,
      child: SizedBox(
        height: height,
        width: width,
        child: child,
      ),
    );
  }
}
