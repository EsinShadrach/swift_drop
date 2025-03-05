import 'package:swift_drop/lib.dart';
import 'package:swift_drop/utils/usefuls/drop_widget.dart';

class NotificationData {
  final String title;
  final String? subtitle;
  final SwiftDropType type;
  final Duration duration;
  final Widget? leading;
  final Widget? trailing;
  final bool showCloseButton;
  final VoidCallback? onTap;

  NotificationData({
    required this.title,
    this.subtitle,
    this.type = SwiftDropType.defaultStyle,
    this.duration = const Duration(seconds: 3),
    this.leading,
    this.trailing,
    this.showCloseButton = false,
    this.onTap,
  });
}

class DropNotificationProvider {
  static final ValueNotifier<NotificationData?>
  _notificationNotifier = ValueNotifier(null);
  static OverlayEntry? _overlayEntry;

  static void show({
    required BuildContext context,
    required String title,
    String? subtitle,
    SwiftDropType type = SwiftDropType.defaultStyle,
    Duration duration = const Duration(seconds: 3),
    Widget? leading,
    Widget? trailing,
    bool showCloseButton = false,
    VoidCallback? onTap,
  }) {
    final notificationData = NotificationData(
      title: title,
      subtitle: subtitle,
      type: type,
      duration: duration,
      leading: leading,
      trailing: trailing,
      showCloseButton: showCloseButton,
      onTap: onTap,
    );

    _notificationNotifier.value = notificationData;

    _overlayEntry?.remove();
    _overlayEntry = _createOverlayEntry(context);

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _notificationNotifier.value = null;
    _overlayEntry?.remove();
    _overlayEntry = null;

    debugPrint("Notification Provider: Notification hidden");
  }

  static OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          right: 0,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: ValueListenableBuilder<NotificationData?>(
                valueListenable: _notificationNotifier,
                builder: (context, notificationData, _) {
                  if (notificationData == null) {
                    return const SizedBox.shrink();
                  }

                  return _AnimatedSwiftDrop(
                    type: notificationData.type,
                    title: notificationData.title,
                    subtitle: notificationData.subtitle,
                    leading: notificationData.leading,
                    trailing: notificationData.trailing,
                    showCloseButton:
                        notificationData.showCloseButton,
                    duration: notificationData.duration,
                    onTap: () {
                      notificationData.onTap?.call();
                    },
                    onDismissed: () {
                      hide();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedSwiftDrop extends StatefulWidget {
  const _AnimatedSwiftDrop({
    required this.type,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showCloseButton = false,
    this.onTap,
    this.onDismissed,
    required this.duration,
  });

  final SwiftDropType type;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool showCloseButton;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;
  final Duration duration;

  @override
  State<_AnimatedSwiftDrop> createState() =>
      _AnimatedSwiftDropState();
}

class _AnimatedSwiftDropState extends State<_AnimatedSwiftDrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _dismissTimer();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  // timer based dismissal
  void _dismissTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }

    _timer = Timer(widget.duration, () {
      _animationController.reverse().then((_) {
        _timer = null;
        widget.onDismissed?.call();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: SwiftDropFlutter(
              type: widget.type,
              title: widget.title,
              subtitle: widget.subtitle,
              leading: widget.leading,
              trailing: widget.trailing,
              showCloseButton: widget.showCloseButton,
              onTap: () {
                widget.onTap?.call();
              },
              onDismissed: widget.onDismissed,
              animatedDismiss: () {
                _animationController.reverse().then((_) {
                  widget.onDismissed?.call();
                });
              },
            ),
          ),
        );
      },
    );
  }
}
