part of 'segment_button.dart';

class ButtonSegmented<T> extends StatefulWidget {
  final T value;
  final T? selectedValue;
  final Widget? icon;
  final String? title;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final void Function(T value)? onPressed;
  const ButtonSegmented({super.key, required this.value, this.selectedValue, this.title, this.icon, this.foregroundColor, this.backgroundColor, this.onPressed});

  @override
  State<ButtonSegmented<T>> createState() => _ButtonSegmentedState();
}

class _ButtonSegmentedState<T> extends State<ButtonSegmented<T>> {

  Color? foreGroundColor = AppC.grey;

  @override
  void initState() {
    foreGroundColor = (widget.selectedValue == widget.value) ? widget.foregroundColor : AppC.grey;
    super.initState();
  }

  void get _setState {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant ButtonSegmented<T> oldWidget) {
    if (widget.selectedValue != oldWidget.selectedValue) {
      foreGroundColor = (widget.selectedValue == widget.value) ? widget.foregroundColor : AppC.grey;
      _setState;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (widget.onPressed == null) ? null : () => widget.onPressed?.call(widget.value),
      child: Material(
        elevation: (widget.selectedValue == widget.value) ? 0.5 : 0,
        borderRadius: (widget.selectedValue == widget.value) ? BorderRadius.circular(7.spMin) : BorderRadius.circular(0),
        child: AnimatedContainer(
          curve: Curves.easeInCirc,
          decoration: (widget.selectedValue == widget.value) ? BoxDecoration(
            borderRadius: BorderRadius.circular(7.spMin),
            color: widget.backgroundColor,
          ) : null,
          padding: 10.spMin.horizontalPadding.copyWith(top: 10.spMin, bottom: 10.spMin),
          duration: Durations.medium2,
          child: ForegroundColorWrapper(
            color: foreGroundColor,
              child: Row(
                spacing: 4.0,
            children: [
              if (widget.icon != null) widget.icon ?? const SizedBox.shrink(),
              CompactText(widget.title ?? "", color: foreGroundColor),
              const SizedBox.shrink()
            ],
          )),
        ),
      ),
    );
  }
}
