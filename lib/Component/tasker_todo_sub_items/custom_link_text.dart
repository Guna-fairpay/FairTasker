part of '../todo_task_item_card.dart';

class CustomLinkText extends StatelessWidget {
  final Map<String, dynamic> model;
  final VoidCallback? onCustomLink;
  const CustomLinkText({super.key, required this.model, this.onCustomLink});

  @override
  Widget build(BuildContext context) {
    final display = model['display'] ?? {};
    var hasCustomLink = display['hasCustomLink'] ?? false;
    var customLinkText = display['customLinkText']?.toString() ?? 'T';
    var customLinkColor = display['customColor'] ?? Colors.black;
    final hasFairental = (model['custom_link_id'] == 3 && model['rental_booking_id'] != null);
    hasCustomLink = hasCustomLink || hasFairental;
    customLinkText = (hasFairental) ? "F" : customLinkText;
    customLinkColor = (hasFairental) ? AppC.fairental : customLinkColor;
    Widget? child;
    if (hasCustomLink) {
      child = GestureDetector(
        onTap: onCustomLink,
        child: Utils.getText(
          customLinkText,
         // color: customLinkColor,
          weight: FontWeight.w900,
          //size: 14.spMin,
          style: context.textTheme.titleMedium?.copyWith(
            color: customLinkColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return child ?? const SizedBox.shrink();
  }
}
