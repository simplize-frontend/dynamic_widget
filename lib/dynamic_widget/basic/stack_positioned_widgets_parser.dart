import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/extension/string_extension.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/widgets.dart';

class PositionedWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    return Positioned(
      child: DynamicWidgetBuilder.buildFromMap(map["child"], buildContext, listener)!,
      top: map.containsKey("top") ? (map["top"] as String?)?.getSizeFromString() : null,
      right: map.containsKey("right") ? (map["right"] as String?)?.getSizeFromString() : null,
      bottom: map.containsKey("bottom") ? (map["bottom"] as String?)?.getSizeFromString() : null,
      left: map.containsKey("left") ? (map["left"] as String?)?.getSizeFromString() : null,
      width: map.containsKey("width") ? (map["width"] as String?)?.getSizeFromString() : null,
      height: map.containsKey("height") ? (map["height"] as String?)?.getSizeFromString() : null,
    );
  }

  @override
  String get widgetName => "Positioned";

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as Positioned;
    return <String, dynamic>{
      "type": "Positioned",
      "top": realWidget.top ?? null,
      "right": realWidget.right ?? null,
      "bottom": realWidget.bottom ?? null,
      "left": realWidget.left ?? null,
      "width": realWidget.width ?? null,
      "height": realWidget.height ?? null,
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext)
    };
  }

  @override
  Type get widgetType => Positioned;
}

class StackWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    return Stack(
      alignment:
          map.containsKey("alignment") ? parseAlignmentGeometry(map["alignment"])! : AlignmentDirectional.topStart,
      textDirection: map.containsKey("textDirection") ? parseTextDirection(map["textDirection"]) : null,
      fit: map.containsKey("fit") ? parseStackFit(map["fit"])! : StackFit.loose,
      clipBehavior: map.containsKey("clipBehavior") ? parseClip(map["clipBehavior"])! : Clip.hardEdge,
      children: DynamicWidgetBuilder.buildWidgets(map['children'], buildContext, listener),
    );
  }

  @override
  String get widgetName => "Stack";

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as Stack;
    return <String, dynamic>{
      "type": "Stack",
      "alignment": exportAlignment(realWidget.alignment),
      "textDirection": exportTextDirection(realWidget.textDirection),
      "fit": exportStackFit(realWidget.fit),
      "clipBehavior": exportClipBehavior(realWidget.clipBehavior),
      "children": DynamicWidgetBuilder.exportWidgets(realWidget.children, buildContext)
    };
  }

  @override
  Type get widgetType => Stack;
}
