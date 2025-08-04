part of 'segment_button.dart';

class CompactSegmentedButton<T> extends StatefulWidget {
  final T selectedValue;
  final Color? selectedColor;
  final Color? backgroundColor;
  final List<ButtonSegments<T>>? items;
  final void Function(dynamic value)? onValueChanged;

  const CompactSegmentedButton(
      {super.key, this.items, required this.selectedValue, this.onValueChanged, this.selectedColor, this.backgroundColor});

  @override
  State<CompactSegmentedButton> createState() =>
      _CompactSegmentedButtonState<T>();
}

class _CompactSegmentedButtonState<T> extends State<CompactSegmentedButton> {

  late T value;

  @override
  void initState() {
    value = widget.selectedValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CompactSegmentedButton oldWidget) {
    if (oldWidget.selectedValue != widget.selectedValue) {
      value = widget.selectedValue;
      _setState;
    }
    super.didUpdateWidget(oldWidget);
  }

  void get _setState {
    if (mounted) setState(() {});
  }

  void _handleOnTap(T value) {
    this.value = value;
    _setState;
    if (widget.selectedValue != value) {
      widget.onValueChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flex(direction: Axis.horizontal,
        spacing: 5.spMin,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: (widget.items ?? []).map((e) =>
            ButtonSegmented<T>(value: e.value,
              icon: e.icon,
              title: e.title,
              selectedValue: value,
              foregroundColor: widget.selectedColor,
              backgroundColor: widget.backgroundColor,
              onPressed: _handleOnTap)).toList());
  }
}
