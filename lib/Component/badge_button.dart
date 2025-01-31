import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class BadgeButton extends StatelessWidget {
  final String label;
  final bool showBadge;
  final dynamic Function(dynamic value)? onPressed;
  final dynamic value;
  final dynamic selectedValue;
  final int? count;
  const BadgeButton({super.key, required this.value, required this.label, this.showBadge = true, this.onPressed, this.count, this.selectedValue});

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text("${count ?? 0}"),
      alignment: Alignment.topRight,
      isLabelVisible: showBadge,
      offset: const Offset(-2, 2.5),
      textStyle: Theme.of(context).textTheme.labelLarge,
      child: OutlinedButton(
        onPressed: () => onPressed?.call(value),
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll((value == selectedValue) ? AppC.appColor : Colors.transparent),
            side: WidgetStatePropertyAll((value == selectedValue) ? BorderSide.none : const BorderSide(color: AppC.text)),
            foregroundColor: WidgetStatePropertyAll((value == selectedValue) ? Colors.white : AppC.appColor),
            textStyle: WidgetStatePropertyAll(Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold))),
        child: Text(label),
      ),
    );
  }
}
