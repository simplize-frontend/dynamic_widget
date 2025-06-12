import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackgroundImageParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    return BackgroundImageWidget(imageUrl: map['imageUrl']);
  }

  @override
  String get widgetName => 'BackgroundImageWidget';

  @override
  Type get widgetType => BackgroundImageWidget;

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    return null;
  }
}

class BackgroundImageWidget extends StatefulWidget {
  const BackgroundImageWidget({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<BackgroundImageWidget> createState() => _BackgroundImageWidgetState();
}

class _BackgroundImageWidgetState extends State<BackgroundImageWidget> {
  Key _key = UniqueKey();
  String _url = "";
  @override
  void initState() {
    super.initState();
    _url = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return CachedNetworkImage(
      key: _key,
      imageUrl: _url,
      fit: BoxFit.cover,
      width: size.width,
      height: size.height,
      alignment: Alignment.center,
      placeholder: (context, url) => const CupertinoActivityIndicator(),
      errorWidget: (context, url, error) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error),
          SizedBox(height: 8),
          Text("Đã có lỗi xảy ra"),
          SizedBox(height: 16),
          GestureDetector(
            onTap: _retry,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Thử lại", style: TextStyle(fontSize: 12)), Icon(Icons.refresh, size: 14)],
            ),
          ),
        ],
      ),
    );
  }

  void _retry() {
    _key = UniqueKey();
    _url = widget.imageUrl;
    setState(() {});
  }
}
