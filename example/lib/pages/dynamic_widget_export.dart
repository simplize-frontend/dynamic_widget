import 'package:dynamic_widget/dynamic_widget/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_animate/flutter_animate.dart';

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
    DynamicWidgetBuilder.addParser(BackgroundImageParser());
    DynamicWidgetBuilder.addParser(AutoCloseButtonWidgetParser());

    if (mounted) {
      rootBundle.loadString('lib/assets/json/countdown.json').then((value) {
        Future.delayed(const Duration(seconds: 3), () async {
          await showDialog(
            useRootNavigator: true,
            barrierColor: Colors.black.withValues(alpha: 0.4),
            context: context,
            builder:
                (context) => Animate(
                  effects: [FadeEffect(duration: const Duration(milliseconds: 600), curve: Curves.easeInOut)],
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
        });
      });
    }

    super.initState();
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
