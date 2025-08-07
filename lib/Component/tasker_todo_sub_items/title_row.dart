part of '../todo_task_item_card.dart';

class TitleRow extends StatelessWidget {
  final Map<String, dynamic> model;
  final VoidCallback? onTap, onReasonAttachmentView, onCustomLink, onViewAttachment, onDateChange, onCompletedTimeChange, onTimeChange, onMeetingView, bookingInfo;
  const TitleRow({super.key, required this.model, this.onTap, this.onReasonAttachmentView, this.onCustomLink, this.onViewAttachment, this.onDateChange, this.onCompletedTimeChange, this.onTimeChange, this.onMeetingView, this.bookingInfo});

  @override
  Widget build(BuildContext context) {
    final display = model['display'] ?? {};
    final hasCompletedTime = display['hasCompletedTime'] ?? false;
    final completedTime = display['completed_time'] ?? "";
    final taskTime = display['task_time'] ?? "05:30:00";
    List<Widget> extendChildren = [
      Flexible(child: TaskTitleView(
        model: model,
        onTap: onTap,
        onMeetingView: onMeetingView,
        onReasonAttachmentView: onReasonAttachmentView,
      )),
      CustomLinkText(
        model: model,
        onCustomLink: onCustomLink,
      ),
      BookingInfoView(
        model: model,
        info: bookingInfo,
      ),
      AttachmentView(model: model,
          onViewAttachment: onViewAttachment)
    ];
    List<Widget> secondChildren = [
      GestureDetector(
        onTap: onDateChange,
        child: Icon(
          Icons.calendar_month_outlined,
          size: 13.spMin,
        ),
      ),
      if (hasCompletedTime) GestureDetector(onTap: onCompletedTimeChange, child: Utils.getText(completedTime, style: context.textTheme.titleSmall?.copyWith(),)),
      GestureDetector(onTap: onTimeChange, child: Utils.getText(Utils.convertString24HTo12H(taskTime), style: context.textTheme.titleSmall?.copyWith(),)),
      const SizedBox.shrink()
    ];
    Widget firstChild = Expanded(child: Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: extendChildren));
    Widget secondChild = Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: secondChildren);
    return Row(children: [firstChild, secondChild]);
  }
}
