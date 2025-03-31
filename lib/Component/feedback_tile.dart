import 'package:fairpytasker/Response/feedback_view_response.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:html/parser.dart' show parse;

class FeedBackTile extends StatelessWidget {
  final bool isOdd;
  final Feedback? feedback;
  final VoidCallback? onViewAttachment, onDelete, onPressed;

  const FeedBackTile(
      {super.key,
      this.isOdd = false,
      required this.feedback,
      this.onViewAttachment,
      this.onDelete,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: (isOdd)
              ? AppC.grey.withValues(alpha: 0.08)
              : AppC.blue50?.withValues(alpha: 0.8)),
      child: Dismissible(
          key: UniqueKey(),
          behavior: HitTestBehavior.opaque,
          background: Container(
            alignment: AlignmentDirectional.centerStart,
            decoration: BoxDecoration(
                color: AppC.green, borderRadius: BorderRadius.circular(10)),
            child: TextButton.icon(
                onPressed: onViewAttachment,
                label: Utils.getText("View Attachments", color: AppC.white),
                icon: const Icon(
                  Icons.visibility_rounded,
                  color: AppC.white,
                )),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              onViewAttachment?.call();
            } else if (direction == DismissDirection.endToStart) {
              onDelete?.call();
            }
            return false;
          },
          secondaryBackground: Container(
            alignment: AlignmentDirectional.centerEnd,
            decoration: BoxDecoration(
                color: AppC.red, borderRadius: BorderRadius.circular(10)),
            child: TextButton.icon(
                onPressed: onDelete,
                label: Utils.getText("Delete", color: AppC.white),
                icon: const Icon(
                  Icons.delete,
                  color: AppC.white,
                )),
          ),
          child: ListTile(
            onTap: onPressed,
            contentPadding: const EdgeInsets.all(10),
            minVerticalPadding: 10,
            horizontalTitleGap: 10,
            leading: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                Container(
                  padding: 8.padding,
                  decoration: BoxDecoration(
                      color: feedback?.priority.fromPriority,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("${(feedback?.priority?[0])?.toUpperCase()}",
                      style: context.textTheme.labelLarge?.copyWith(
                          color: AppC.white, fontWeight: FontWeight.bold)),
                ),
                Flexible(child: Text(feedback?.feedbackDateTime.toDate.findAgo ?? ""))
              ],
            ),
            title: Text("${feedback?.title}"),
            subtitle: (feedback?.attachments?.isEmpty ?? false)
                ? null
                : Row(
                  children: [
                    GestureDetector(
                        onTap: onViewAttachment,
                        child: Text(
                          "View attachments",
                          style: context.textTheme.labelLarge?.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: AppC.appColor,
                            color: AppC.appColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox.shrink(),
                  ],
                ),
            trailing: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Utils.getText([feedback?.user?.firstName, feedback?.user?.lastName].toInitial,
                  color: AppC.appColor, weight: FontWeight.bold),
            ),
          )),
    );
  }
}
