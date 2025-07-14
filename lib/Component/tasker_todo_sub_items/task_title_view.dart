part of '../todo_task_item_card.dart';

class TaskTitleView extends StatelessWidget {
  final Map<String, dynamic> model;
  final VoidCallback? onTap, onReasonAttachmentView, onMeetingView;
  const TaskTitleView({super.key, required this.model, this.onTap, this.onReasonAttachmentView, this.onMeetingView});

  @override
  Widget build(BuildContext context) {
    final display = model['display'] ?? {};
    final hasTimeSensitive = display['hasTimeSensitive'] ?? false;
    final hasReason = display['hasReason'] ?? false;
    final hasReasonAttachments = display['hasReasonAttachments'] ?? false;
    final hasRelatedTask = display['hasRelatedTask'] ?? false;
    final List<InlineSpan> spans = [];
    final hasMeeting = ((model['meeting_mode'] == "online") && (model['meeting_link'].toString().isNotNullOrEmpty));
    // Prebuild spans
    spans.add(
      TextSpan(
        text: display['task_title'] ?? '',
        style: context.textTheme.titleSmall?.copyWith(
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

    if (hasMeeting) {
      spans.addAll([WidgetSpan(child: 5.spMin.width), WidgetSpan(child: GestureDetector(
        onTap: onMeetingView,
        child: Icon(Remix.links_line, color: AppC.bouncieButtonColor, size: 14.sp),
      ))]);
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
