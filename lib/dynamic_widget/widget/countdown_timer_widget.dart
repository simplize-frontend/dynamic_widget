import 'package:dynamic_widget/dynamic_widget/extension/text_style_extension.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../extension/box_decoration_extension.dart';

class CountdownWidgetParser extends WidgetParser {
  @override
  String get widgetName => 'CountdownTimerWidget';

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    return null;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    return CountdownTimerWidget(
      endDate: map['endDate'],
      startDate: map['startDate'],
      digitDecoration: map['digitDecoration'] != null ? BoxDecorationX.fromJson(map['digitDecoration']) : null,
      digitStyle: (map['digitStyle'] as Map<String, dynamic>?)?.getTextStyleFromJson(),
      labelStyle: (map['labelStyle'] as Map<String, dynamic>?)?.getTextStyleFromJson(),
      colonStyle: (map['colonStyle'] as Map<String, dynamic>?)?.getTextStyleFromJson(),
      hasColon: map['hasColon'] ?? true,
      displayField: map['displayField'] ?? 'dd,HH,mm,ss',
      hideField: map['hideField'] ?? '',
    );
  }

  @override
  Type get widgetType => CountdownTimerWidget;
}

class CountdownTimerWidget extends StatefulWidget {
  final String endDate;
  final String? startDate;
  final TextStyle? digitStyle;
  final TextStyle? labelStyle;
  final TextStyle? colonStyle;
  final BoxDecoration? digitDecoration;
  final bool hasColon;
  final String displayField;
  final String hideField;

  const CountdownTimerWidget({
    required this.endDate,
    this.startDate,
    this.digitStyle,
    this.labelStyle,
    this.colonStyle,
    this.digitDecoration,
    this.hasColon = true,
    this.displayField = 'dd,HH,mm,ss',
    this.hideField = '',
    super.key,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  List<String> labels = ['Ngày', 'Giờ', 'Phút', 'Giây'];
  Timer? _timer;
  Duration _remainingTime = Duration.zero;

  final daysDigitStart = 0;
  final hoursDigitStart = 2;
  final minutesDigitStart = 4;
  final secondsDigitStart = 6;

  String get _dayLabel => labels[0];
  String get _hourLabel => labels[1];
  String get _minuteLabel => labels[2];
  String get _secondLabel => labels[3];

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildTimeComponents(),
    );
  }

  List<Widget> _buildTimeComponents() {
    final List<String> digits = _getDigitsFromDuration(_remainingTime);
    final Map<String, bool> formatConfig = _parseFormat();

    final int days = _remainingTime.inDays;
    final int hours = _remainingTime.inHours.remainder(24);
    final int minutes = _remainingTime.inMinutes.remainder(60);

    final bool hideDays = widget.hideField.contains('dd') && days == 0;
    final bool hideHours = widget.hideField.contains('HH') && days == 0 && hours == 0;
    final bool hideMinutes = widget.hideField.contains('mm') && days == 0 && hours == 0 && minutes == 0;

    final bool showDays = formatConfig['showDays']! && !hideDays;
    final bool showHours = formatConfig['showHours']! && !hideHours;
    final bool showMinutes = formatConfig['showMinutes']! && !hideMinutes;
    final bool showSeconds = formatConfig['showSeconds']!;

    final List<Widget> activeComponents = [];

    if (showDays) {
      activeComponents.add(_buildDigitGroup(digits, daysDigitStart, label: _dayLabel));
    }
    if (showHours) {
      activeComponents.add(_buildDigitGroup(digits, hoursDigitStart, label: _hourLabel));
    }
    if (showMinutes) {
      activeComponents.add(_buildDigitGroup(digits, minutesDigitStart, label: _minuteLabel));
    }
    if (showSeconds) {
      activeComponents.add(_buildDigitGroup(digits, secondsDigitStart, label: _secondLabel));
    }

    final List<Widget> timeComponents = [];
    for (int i = 0; i < activeComponents.length; i++) {
      timeComponents.add(activeComponents[i]);
      if (widget.hasColon && i < activeComponents.length - 1) {
        timeComponents.add(_buildColon());
      }
    }

    return timeComponents;
  }

  Widget _buildDigitGroup(List<String> digits, int start, {required String label}) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _DigitBox(
                  digit: digits[start],
                  digitStyle: widget.digitStyle,
                  digitDecoration: widget.digitDecoration,
                ),
                const SizedBox(width: 4),
                _DigitBox(
                  digit: digits[start + 1],
                  digitStyle: widget.digitStyle,
                  digitDecoration: widget.digitDecoration,
                ),
              ],
            ),
          ),
          _LabelBox(label: label, labelStyle: widget.labelStyle),
        ],
      ),
    );
  }

  Widget _buildColon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(
            ':',
            style: widget.colonStyle ?? const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        _LabelBox(label: '', labelStyle: widget.labelStyle),
      ],
    );
  }

  void _calculateRemainingTime() {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    final DateTime endDate = dateFormat.parse(widget.endDate);
    final DateTime startDate = DateTime.now();
    final Duration difference = endDate.difference(startDate);

    if (difference.isNegative) {
      _remainingTime = Duration.zero;
    } else {
      _remainingTime = difference;
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime = _remainingTime - const Duration(seconds: 1);
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  List<String> _getDigitsFromDuration(Duration duration) {
    final int days = duration.inDays;
    final int hours = duration.inHours.remainder(24);
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);

    return [
      (days ~/ 10).toString(),
      (days % 10).toString(),
      (hours ~/ 10).toString(),
      (hours % 10).toString(),
      (minutes ~/ 10).toString(),
      (minutes % 10).toString(),
      (seconds ~/ 10).toString(),
      (seconds % 10).toString(),
    ];
  }

  Map<String, bool> _parseFormat() {
    final String format = widget.displayField;
    return {
      'showDays': format.contains('dd'),
      'showHours': format.contains('HH'),
      'showMinutes': format.contains('mm'),
      'showSeconds': format.contains('ss'),
    };
  }
}

class _DigitBox extends StatelessWidget {
  final String digit;
  final TextStyle? digitStyle;
  final BoxDecoration? digitDecoration;

  const _DigitBox({required this.digit, this.digitStyle, this.digitDecoration});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 48,
      alignment: Alignment.center,
      decoration: digitDecoration ?? BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
      child: FittedBox(
        child: Text(
          digit,
          style: digitStyle ?? TextStyle(color: Colors.orange[700], fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _LabelBox extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;

  const _LabelBox({required this.label, this.labelStyle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: labelStyle ?? const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
