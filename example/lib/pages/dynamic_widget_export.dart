import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _getWidget(true));
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
      backgroundImageUrl: "https://cdn.simplize.vn/test/app_popup_test/campaign_background_image.png",
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
              onClick: (map) {
                print(map);
              },
            ),
          ) ??
          const SizedBox.shrink();
    }
    return const SizedBox.shrink();
  }
}
