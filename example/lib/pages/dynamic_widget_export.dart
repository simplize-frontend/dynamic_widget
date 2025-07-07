import 'package:dynamic_widget/dynamic_widget/widget/spacer_widget.dart';
import 'package:dynamic_widget/dynamic_widget/widget/widget.dart';
import 'package:dynamic_widget/simplize_json_widget.dart';
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

class _DynamicWidgetExportState extends State<DynamicWidgetExport> with TickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  final GlobalKey _stickyKey = GlobalKey();
  Offset _initialOffset = const Offset(1, 1);
  Offset? _currentOffset;
  Offset? _panStartGlobalPosition;
  Offset? _panStartWidgetPosition;

  // Animation variables
  late AnimationController _animationController;
  Animation<Offset>? _offsetAnimation;
  bool _isAnimating = false;

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

    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    if (mounted) {
      rootBundle.loadString('lib/assets/json/countdown.json').then((value) {
        Future.delayed(const Duration(seconds: 3), () async {
          _showStickyPopup(
            SimplizeJsonWidget(
              jsonString: value,
              listener: DefaultClickListener(
                onClick: (String? url) {
                  print(url);
                },
              ),
            ),
          );
        });
      });
    }

    super.initState();
  }

  Future<void> _showDialog(String value) async {
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

  Future<void> _showModal(String json) async {
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
      builder: (context) {
        return SimplizeJsonWidget(jsonString: json, listener: DefaultClickListener(onClick: (String? url) {}));
      },
    );
  }

  void _showStickyPopup(SimplizeJsonWidget popupWidget) {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          right: _currentOffset?.dx ?? _initialOffset.dx,
          bottom: _currentOffset?.dy ?? _initialOffset.dy + 16,
          child: GestureDetector(
            onPanStart: (details) {
              final RenderBox? renderBox = _stickyKey.currentContext?.findRenderObject() as RenderBox?;
              if (renderBox == null) return;
              // Store the initial global touch position and current widget position
              _panStartGlobalPosition = details.globalPosition;
              _panStartWidgetPosition = _currentOffset ?? _initialOffset;
            },
            onPanUpdate: (details) {
              final RenderBox? renderBox = _stickyKey.currentContext?.findRenderObject() as RenderBox?;
              if (renderBox == null || _panStartGlobalPosition == null || _panStartWidgetPosition == null) return;

              // Stop any ongoing animation when user starts dragging
              if (_isAnimating) {
                _animationController.stop();
                _isAnimating = false;
                _offsetAnimation = null;
              }

              final screenSize = MediaQuery.sizeOf(context);
              final widgetSize = renderBox.size;
              // Calculate the movement delta from the start position
              final deltaX = details.globalPosition.dx - _panStartGlobalPosition!.dx;
              final deltaY = details.globalPosition.dy - _panStartGlobalPosition!.dy;
              // Apply the delta to the initial widget position
              final newRight = _panStartWidgetPosition!.dx - deltaX;
              final newBottom = _panStartWidgetPosition!.dy - deltaY;
              // Apply bounds checking to keep popup within screen
              final clampedRight = newRight.clamp(0.0, screenSize.width - widgetSize.width);
              final clampedBottom = newBottom.clamp(0.0, screenSize.height - widgetSize.height);
              _currentOffset = Offset(clampedRight, clampedBottom);
              _overlayEntry?.markNeedsBuild();
            },
            onPanEnd: (details) {
              if (_stickyKey.currentContext == null || _currentOffset == null) return;
              final screenSize = MediaQuery.sizeOf(context);
              final widgetSize = _stickyKey.currentContext!.size!;
              // Calculate actual widget position for snap logic
              final actualWidgetX = screenSize.width - _currentOffset!.dx - widgetSize.width;
              final widgetCenterX = actualWidgetX + widgetSize.width / 2;

              // Determine target position based on which half of screen the center is in
              final Offset targetOffset;
              if (widgetCenterX < screenSize.width / 2) {
                // Snap to left edge (right distance = screenWidth - 16 - widgetWidth)
                targetOffset = Offset(screenSize.width - 16 - widgetSize.width, _currentOffset!.dy);
              } else {
                // Snap to right edge (right distance = 16)
                targetOffset = Offset(_initialOffset.dx, _currentOffset!.dy);
              }

              // Animate to target position
              _animateToPosition(targetOffset);

              _panStartGlobalPosition = null; // Clear the pan start positions
              _panStartWidgetPosition = null;
            },
            child: SizedBox(key: _stickyKey, child: popupWidget),
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _animateToPosition(Offset targetOffset) {
    if (_isAnimating) return;

    final startOffset = _currentOffset ?? _initialOffset;
    _isAnimating = true;

    _offsetAnimation = Tween<Offset>(
      begin: startOffset,
      end: targetOffset,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _offsetAnimation!.addListener(() {
      _currentOffset = _offsetAnimation!.value;
      _overlayEntry?.markNeedsBuild();
    });

    _offsetAnimation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimating = false;
        _offsetAnimation?.removeListener(() {});
        _offsetAnimation?.removeStatusListener((status) {});
        _offsetAnimation = null;
      }
    });

    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CountdownTimerWidget(
        startDate: "26/06/2025 14:00:00",
        endDate: "26/06/2025 14:02:00",
        displayField: "dd,HH,mm,ss",
      ),
      backgroundColor: Colors.red,
    );
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
    return Placeholder();
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
