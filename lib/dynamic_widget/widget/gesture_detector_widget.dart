import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/widget/root_widget.dart';
import 'package:flutter/material.dart';

class GestureDetectorWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext context, ClickListener? listener) {
    return GestureDetectorWidget(
      child: DynamicWidgetBuilder.buildFromMap(map['child'], context, listener) ?? const SizedBox.shrink(),
      onTap: () {
        listener?.onClicked(map['onClick']);
      },
    );
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.deferToChild,
      child: child,
    );
  }
}

class JsClickListener extends ClickListener {
  JsClickListener(this.onClick, {required this.mode, required this.onStickyClick});
  final String mode;
  final Function() onStickyClick;
  final Function(String?) onClick;

  @override
  void onClicked(String? event) {
    print('JsClickListener: $event');
    if (event == null || event.isEmpty) {
      _handlePop();
      return;
    }

    final url = Uri.tryParse(event);
    if (url == null) {
      // navigationService.pop();
    }

    final host = url?.host;
    final scheme = url?.scheme;

    if ((host?.isEmpty ?? true) && (scheme?.isEmpty ?? true)) {
      // navigationService.goUrl(event);
    } else {
      // AppUtils().launchInBrowser(url!);
    }
    _handlePop();
  }

  void _handlePop() {
    if (mode == 'sticky') {
      onStickyClick();
    } else {
      // navigationService.pop();
    }
  }
}
