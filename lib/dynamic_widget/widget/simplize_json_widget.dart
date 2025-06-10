import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/widget/root_widget.dart';
import 'package:dynamic_widget/dynamic_widget/widget/widget.dart';
import 'package:flutter/material.dart';

class SimplizeJsonWidget extends StatefulWidget {
  const SimplizeJsonWidget({super.key, required this.jsonString, required this.listener});
  final String jsonString;
  final ClickListener listener;
  @override
  State<SimplizeJsonWidget> createState() => _SimplizeJsonWidgetState();
}

class _SimplizeJsonWidgetState extends State<SimplizeJsonWidget> {
  @override
  void initState() {
    DynamicWidgetBuilder.addParser(RootParser());
    DynamicWidgetBuilder.addParser(CountdownWidgetParser());
    DynamicWidgetBuilder.addParser(ButtonWidgetParser());
    DynamicWidgetBuilder.addParser(ContainerWidgetParser());
    DynamicWidgetBuilder.addParser(GestureDetectorWidgetParser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildWidget(context, widget.jsonString));
  }

  Widget _buildWidget(BuildContext context, String jsonString) {
    if (mounted) {
      return DynamicWidgetBuilder.build(jsonString, context, widget.listener) ?? const SizedBox.shrink();
    }
    return const SizedBox.shrink();
  }
}
