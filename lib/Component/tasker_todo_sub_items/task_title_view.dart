part of '../todo_task_item_card.dart';

class TaskTitleView extends StatelessWidget {
  final Map<String, dynamic> model;
  final VoidCallback? onTap, onReasonAttachmentView;
  const TaskTitleView({super.key, required this.model, this.onTap, this.onReasonAttachmentView});

  @override
  Widget build(BuildContext context) {
    final display = model['display'] ?? {};
    final hasTimeSensitive = display['hasTimeSensitive'] ?? false;
    final hasReason = display['hasReason'] ?? false;
    final hasReasonAttachments = display['hasReasonAttachments'] ?? false;
    final hasRelatedTask = display['hasRelatedTask'] ?? false;
    final List<InlineSpan> spans = [];
    // Prebuild spans
    spans.add(
      TextSpan(
        text: display['task_title'] ?? '',
        style: context.textTheme.titleMedium?.copyWith(
          color: hasTimeSensitive ? AppC.red : AppC.appColor,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()..onTap = onTap,
      ),
    );

    if (hasReason || hasReasonAttachments) {
      spans.addAll([
        TextSpan(text: "\t(\t", style: context.textTheme.labelMedium?.copyWith(color: Colors.red, fontSize: 12.sp)),
        if (hasReason) TextSpan(text: display['reason'] ?? '', style: context.textTheme.labelMedium?.copyWith(color: Colors.red, fontSize: 12.sp)),
        if (hasReasonAttachments)
          WidgetSpan(child: GestureDetector(
            onTap: onReasonAttachmentView,
            child: Icon(Icons.remove_red_eye_rounded, color: Colors.red, size: 14.sp),
          )),
        TextSpan(text: "\t)\t", style: context.textTheme.labelMedium?.copyWith(color: Colors.red, fontSize: 12.sp)),
      ]);
    }

    if (hasRelatedTask) {
      spans.addAll([
        TextSpan(text: "\t>>\t", style: context.textTheme.labelMedium?.copyWith(color: Colors.red)),
        TextSpan(text: display['relatedTaskName'] ?? ''),
      ]);
    }
    return Text.rich(
      TextSpan(children: spans),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: context.textTheme.labelMedium?.copyWith(color: AppC.appColor, fontSize: 12.sp),
    );
  }
}
