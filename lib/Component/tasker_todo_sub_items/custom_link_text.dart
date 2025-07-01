part of '../todo_task_item_card.dart';

class CustomLinkText extends StatelessWidget {
  final Map<String, dynamic> model;
  final VoidCallback? onCustomLink;
  const CustomLinkText({super.key, required this.model, this.onCustomLink});

  @override
  Widget build(BuildContext context) {
    final display = model['display'] ?? {};
    final hasCustomLink = display['hasCustomLink'] ?? false;
    final customLinkText = display['customLinkText']?.toString() ?? 'T';
    final customLinkColor = display['customColor'] ?? Colors.black;
    Widget? child;
    if (hasCustomLink) {
      child = GestureDetector(
        onTap: onCustomLink,
        child: Utils.getText(
          customLinkText,
          color: customLinkColor,
          weight: FontWeight.w900,
          size: 14.sp,
        ),
      );
    }
    return child ?? const SizedBox.shrink();
  }
}
