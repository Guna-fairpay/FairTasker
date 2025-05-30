part of 'segment_button.dart';

class ForegroundColorWrapper extends StatelessWidget {
  final Color? color;
  final Widget child;

  const ForegroundColorWrapper({super.key, this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return DefaultSvgTheme(theme: SvgTheme(
      currentColor: color ?? const Color(0xFF000000)), child: IconTheme(
        data: IconThemeData(color: color),
        child: DefaultTextStyle(
            style: context.textTheme.labelLarge ?? TextStyle(color: color),
            child: child)));
  }
}
