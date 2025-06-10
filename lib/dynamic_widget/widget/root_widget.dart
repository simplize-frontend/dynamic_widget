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
      backgroundImageUrl: map['backgroundImageUrl'],
      width: (map['width'] as String?)?.getSizeFromString(),
      height: (map['height'] as String?)?.getSizeFromString(),
      alignment: (map['display']['position'] as String?)?.getAlignmentFromString(),
      child: DynamicWidgetBuilder.buildFromMap(map['child'], buildContext, listener) ?? const SizedBox.shrink(),
    );
  }

  @override
  String get widgetName => 'Root';

  @override
  Type get widgetType => Root;
}

class Root extends StatelessWidget {
  const Root({super.key, this.backgroundImageUrl, required this.child, this.width, this.height, this.alignment});

  final String? backgroundImageUrl;
  final Widget child;
  final double? width;
  final double? height;
  final Alignment? alignment;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: alignment ?? Alignment.center,
          child: Container(
            height: height ?? size.height,
            width: width ?? size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                onError: (_, __) => const SizedBox.shrink(),
                image: NetworkImage(
                  backgroundImageUrl ?? "https://cdn.simplize.vn/test/app_popup_test/campaign_background_image.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
