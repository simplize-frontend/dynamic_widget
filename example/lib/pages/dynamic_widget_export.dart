import 'package:dynamic_widget/dynamic_widget/widget/spacer_widget.dart';
import 'package:dynamic_widget/dynamic_widget/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_animate/flutter_animate.dart';

abstract class TransitionFrom {
  static const top = 'top';
  static const bottom = 'bottom';
  static const left = 'left';
  static const right = 'right';
}

abstract class TransitionType {
  static const slide = 'slide';
  static const fade = 'fade';
}

abstract class PopUpMode {
  static const overlay = 'overlay';
  static const modal = 'modal';
}

class DynamicWidgetExport extends StatefulWidget {
  const DynamicWidgetExport({super.key});
  @override
  State<DynamicWidgetExport> createState() => _DynamicWidgetExportState();
}

class _DynamicWidgetExportState extends State<DynamicWidgetExport> {
  @override
  void initState() {
    DynamicWidgetBuilder.addParser(RootParser());
    DynamicWidgetBuilder.addParser(CountdownWidgetParser());
    DynamicWidgetBuilder.addParser(ButtonWidgetParser());
    DynamicWidgetBuilder.addParser(ContainerWidgetParser());
    DynamicWidgetBuilder.addParser(GestureDetectorWidgetParser());
    DynamicWidgetBuilder.addParser(NetworkImageParser());
    DynamicWidgetBuilder.addParser(AutoCloseButtonWidgetParser());
    DynamicWidgetBuilder.addParser(SpacerWidgetParser());

    if (mounted) {
      rootBundle.loadString('lib/assets/json/countdown.json').then((value) {
        Future.delayed(const Duration(seconds: 3), () async {
          await _showDialog(value);
        });
      });
    }

    super.initState();
  }

  Future<void> _showDialog(String value) async {
    // List<Effect> effects = [];
    //     if (transition == TransitionType.slide) {
    //       effects.add(
    //         SlideEffect(
    //           begin: _getBeginOffset(transitionFrom),
    //           end: Offset.zero,
    //           curve: Curves.easeOut,
    //           duration: const Duration(milliseconds: 300),
    //         ),
    //       );
    //     } else {
    //       effects.add(const FadeEffect(curve: Curves.easeOut));
    //     }
    //     return Animate(
    //       effects: effects,
    //       child: GestureDetector(
    //         onTap: () {
    //           navigationService.pop();
    //         },
    //         child: SafeArea(child: popupWidget),
    //       ),
    //     );
    await showDialog(
      useRootNavigator: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      context: context,
      builder:
          (context) => Animate(
            effects: [
              SlideEffect(
                begin: _getBeginOffset("top"),
                end: Offset.zero,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              ),
            ],
            child:
                DynamicWidgetBuilder.build(
                  value,
                  context,
                  DefaultClickListener(
                    onClick: (String? url) {
                      print(url);
                    },
                  ),
                )!,
          ),
    );
  }

  Offset _getBeginOffset(String transitionFrom) {
    switch (transitionFrom) {
      case TransitionFrom.top:
        return const Offset(0, -1);
      case TransitionFrom.bottom:
        return const Offset(0, 1);
      case TransitionFrom.left:
        return const Offset(-1, 0);
      case TransitionFrom.right:
        return const Offset(1, 0);
      default:
        return const Offset(0, -1);
    }
  }

  Future<void> _showModal() async {
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
      builder: (context) {
        return Wrap(children: [_getWidget(true)]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Placeholder(), backgroundColor: Colors.red);
  }

  Widget _getWidget(bool isJson) {
    if (isJson) {
      return FutureBuilder<Widget>(
        future: _buildWidget(context),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          return snapshot.hasData ? snapshot.data! : const CupertinoActivityIndicator();
        },
      );
    }
    return Root(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetectorWidget(
              onTap: () {
                print("Close popup");
              },
              child: Padding(padding: const EdgeInsets.all(16.0), child: Icon(Icons.close, color: Colors.white)),
            ),
          ),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CountdownTimerWidget(endDate: "09/06/2025 23:59:00", startDate: "18/06/2025 00:00:00"),
                ButtonWidget(onPressed: () {}, text: "ABC"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget>? _buildWidget(BuildContext context) async {
    final jsonString = await rootBundle.loadString('lib/assets/json/countdown.json');
    if (mounted) {
      return DynamicWidgetBuilder.build(
            jsonString,
            context,
            DefaultClickListener(
              onClick: (String? url) {
                print(url);
              },
            ),
          ) ??
          const SizedBox.shrink();
    }
    return const SizedBox.shrink();
  }
}
