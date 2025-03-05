import 'package:swift_drop/lib.dart';

class SwiftDropFlutter extends StatefulWidget {
  const SwiftDropFlutter({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showCloseButton = false,
    this.type = SwiftDropType.defaultStyle,
    this.onTap,
    this.onDismissed,
    this.animatedDismiss,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool showCloseButton;
  final SwiftDropType type;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;
  final VoidCallback? animatedDismiss;

  @override
  State<SwiftDropFlutter> createState() =>
      _SwiftDropFlutterState();
}

class _SwiftDropFlutterState extends State<SwiftDropFlutter> {
  final ScrollController _scrollController = ScrollController();
  double _borderRadius = 50.0;
  static const double _minBorderRadius = 10.0;
  static const double _maxBorderRadius = 50.0;
  static const double _dragDownThreshold = 50.0;
  static const double _dismissThreshold = 30.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset < 0) {
      double newRadius =
          _maxBorderRadius -
          ((-_scrollController.offset) / _dragDownThreshold) *
              (_maxBorderRadius - _minBorderRadius);

      newRadius = newRadius.clamp(
        _minBorderRadius,
        _maxBorderRadius,
      );

      if (newRadius != _borderRadius) {
        setState(() {
          _borderRadius = newRadius;
        });
      }
    } else if (_scrollController.offset >
        _dismissThreshold.abs()) {
      widget.animatedDismiss?.call();
    } else {
      if (_borderRadius != _maxBorderRadius) {
        setState(() {
          _borderRadius = _maxBorderRadius;
        });
      }
    }
  }

  String get title => widget.title;
  String? get subtitle => widget.subtitle;
  Widget? get leading => widget.leading;
  Widget? get trailing => widget.trailing;
  bool get showCloseButton => widget.showCloseButton;
  SwiftDropType get type => widget.type;
  VoidCallback? get onTap => widget.onTap;

  Color get alertColor {
    return switch (type) {
      SwiftDropType.warning => Colors.amber.shade600,
      SwiftDropType.error => Colors.red.shade600,
      SwiftDropType.info => Colors.blue.shade600,
      SwiftDropType.defaultStyle => context.colorScheme.outline,
      SwiftDropType.success => Colors.green.shade600,
    };
  }

  Color get backgroundColor {
    return switch (type) {
      SwiftDropType.warning => Colors.amber.shade100,
      SwiftDropType.error => Colors.red.shade100,
      SwiftDropType.info => Colors.blue.shade100,
      SwiftDropType.defaultStyle =>
        context.colorScheme.surfaceContainer,
      SwiftDropType.success => Colors.green.shade100,
    };
  }

  Color get textColor {
    return switch (type) {
      SwiftDropType.warning => Colors.amber.shade900,
      SwiftDropType.error => Colors.red.shade900,
      SwiftDropType.info => Colors.blue.shade900,
      SwiftDropType.defaultStyle =>
        context.colorScheme.onSurface,
      SwiftDropType.success => Colors.green.shade900,
    };
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: alertColor),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          physics: const BouncingScrollPhysics(),
          overscroll: true,
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          clipBehavior: Clip.none,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: GestureDetector(
            onTap: onTap,
            child: IntrinsicHeight(
              child: IntrinsicWidth(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  constraints: BoxConstraints(
                    minHeight: kToolbarHeight,
                    minWidth: 200,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      _borderRadius,
                    ),
                    color: backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.1,
                        ),
                        blurRadius: 40,
                        spreadRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Row(
                    spacing: subtitle != null ? 15 : 5,
                    children: <Widget>[
                      if (leading != null) ...[leading!],
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              title,
                              style: context.textTheme.labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            if (subtitle != null) ...[
                              Text(
                                subtitle!,
                                style: context
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontWeight:
                                          FontWeight.w400,
                                      color: Color.alphaBlend(
                                        textColor.withValues(
                                          alpha: 0.8,
                                        ),
                                        Colors.white,
                                      ),
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (leading != null &&
                          trailing == null) ...[
                        XBox(0),
                      ],
                      if (showCloseButton) ...[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Icon(
                            CupertinoIcons.xmark_circle_fill,
                          ),
                          onTap: () => _closeAlert(context),
                        ),
                      ] else if (trailing != null) ...[
                        trailing!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _closeAlert(BuildContext context) {
    debugPrint("Close Alert!!");
    widget.onDismissed?.call();
  }
}
