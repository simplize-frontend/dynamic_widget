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
      viewWidth: (map['viewWidth'] as String?)?.getSizeFromString(),
      viewHeight: (map['viewHeight'] as String?)?.getSizeFromString(),
      alignment: (map['display']['position'] as String?)?.getAlignmentFromString(),
      child: RootConfigInheritedWidget(
        config: {"mode": map['mode'], "display": map['display']},
        child: DynamicWidgetBuilder.buildFromMap(map['child'], buildContext, listener) ?? const SizedBox.shrink(),
      ),
    );
  }

  @override
  String get widgetName => 'Root';

  @override
  Type get widgetType => Root;
}

class RootConfigInheritedWidget extends InheritedWidget {
  RootConfigInheritedWidget({
    super.key,
    required super.child,
    required this.config,
  });
  final Map<String, dynamic>? config;

  bool get isModal => config?['mode'] == 'modal';
  bool get isSticky => config?['mode'] == 'sticky';
  bool get isFull => config?['display']['full'] == true;
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class Root extends StatelessWidget {
  const Root(
      {super.key, required this.child, this.width, this.height, this.alignment, this.viewWidth, this.viewHeight});

  final Widget child;
  final double? width;
  final double? height;
  final double? viewWidth;
  final double? viewHeight;
  final Alignment? alignment;
  @override
  Widget build(BuildContext context) {
    final config = context.dependOnInheritedWidgetOfExactType<RootConfigInheritedWidget>();
    final isFull = config?.isFull ?? false;
    return Align(
      heightFactor: 1,
      alignment: alignment ?? Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          var scaleX = constraints.maxWidth / viewWidth!;
          var scaleY = constraints.maxHeight / viewHeight!;
          if (isFull) {
            scaleX = constraints.maxWidth / viewWidth!;
            scaleY = constraints.maxHeight / viewHeight!;
            return Transform.scale(
              scaleX: scaleX,
              scaleY: scaleY,
              child: SizedBox(
                height: viewHeight,
                width: viewWidth,
                child: child,
              ),
            );
          }
          return SizedBox(
            height: height,
            width: width,
            child: child,
          );
        },
      ),
    );
  }
}
