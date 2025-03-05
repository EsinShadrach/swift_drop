import 'package:swift_drop/lib.dart';

class XBox extends StatelessWidget {
  const XBox(this.x, {super.key});

  final double x;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: x);
  }
}
