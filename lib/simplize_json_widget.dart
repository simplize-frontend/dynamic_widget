import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/widget/spacer_widget.dart';
import 'package:dynamic_widget/dynamic_widget/widget/widget.dart';
import 'package:flutter/material.dart';

class SimplizeJsonWidget extends StatefulWidget {
  const SimplizeJsonWidget({super.key, required this.jsonString, required this.listener, this.onDispose});
  final String jsonString;
  final Function()? onDispose;
  final ClickListener listener;
  @override
  State<SimplizeJsonWidget> createState() => _SimplizeJsonWidgetState();
}

class _SimplizeJsonWidgetState extends State<SimplizeJsonWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: _buildWidget(context, widget.jsonString),
    );
  }

  Widget _buildWidget(BuildContext context, String jsonString) {
    if (mounted) {
      return DynamicWidgetBuilder.build(jsonString, context, widget.listener) ?? const SizedBox.shrink();
    }
    return const SizedBox.shrink();
  }
}
