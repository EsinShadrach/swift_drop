import 'package:swift_drop/lib.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            CupertinoButton.filled(
              onPressed: () {
                DropNotificationProvider.show(
                  context: context,
                  title: 'Info',
                  subtitle: 'This is an info message',
                  type: SwiftDropType.info,
                  onTap: () {
                    debugPrint("Default Style");
                  },
                  leading: const Icon(
                    CupertinoIcons.info_circle_fill,
                  ),
                );
              },
              child: const Text('Show Info Notification'),
            ),
            CupertinoButton.filled(
              onPressed: () {
                DropNotificationProvider.show(
                  context: context,
                  title: 'Error',
                  subtitle: 'This is an error message',
                  type: SwiftDropType.error,
                  onTap: () {
                    debugPrint("Error Notification Tapped");
                  },
                  leading: const Icon(
                    CupertinoIcons.exclamationmark_octagon_fill,
                  ),
                );
              },
              child: const Text('Show Error Notification'),
            ),
            CupertinoButton.filled(
              onPressed: () {
                DropNotificationProvider.show(
                  context: context,
                  title: 'Default Style',
                  subtitle: 'This is a default style message',
                  onTap: () {
                    debugPrint("Info Notification Tapped");
                  },
                  leading: const Icon(
                    CupertinoIcons.info_circle_fill,
                  ),
                );
              },
              child: const Text('Show Default Notification'),
            ),
            CupertinoButton.filled(
              onPressed: () {
                DropNotificationProvider.show(
                  context: context,
                  title: 'Success',
                  subtitle: 'This is a success message',
                  type: SwiftDropType.success,
                  leading: const Icon(
                    CupertinoIcons.checkmark_circle_fill,
                  ),
                  showCloseButton: true,
                  onTap: () {
                    debugPrint("Success Notification Tapped");
                  },
                  duration: const Duration(seconds: 3),
                );
              },
              child: const Text('Show Success Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
