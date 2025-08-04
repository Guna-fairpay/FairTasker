part of '../todo_task_item_card.dart';

class AttachmentView extends StatelessWidget {
  final Map<String, dynamic> model;
  final VoidCallback? onViewAttachment;
  const AttachmentView({super.key, required this.model, this.onViewAttachment});

  @override
  Widget build(BuildContext context) {
    final display = model['display'] ?? {};
    final hasAttachments = display['hasAttachments'] ?? false;
    Widget? child;
    if (hasAttachments) {
      child = GestureDetector(
        onTap: onViewAttachment,
        child: Icon(
          Icons.remove_red_eye_sharp,
          size: 16.spMin,
          color: AppC.appColor,
        ),
      );
    }
    return child ?? const SizedBox.shrink();
  }
}
