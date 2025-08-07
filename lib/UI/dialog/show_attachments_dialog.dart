import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/Component/attachment_slider_view.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';

class ShowAttachmentsDialog {
  ShowAttachmentsDialog._();

  static final ShowAttachmentsDialog of = ShowAttachmentsDialog._();

  void show(BuildContext context,{
    required List<dynamic> attachments,
    required String? title,
    dynamic currentAttachment,
    void Function(dynamic value)? onDeleted,
    void Function(dynamic value)? onDownload,
    bool showDownload = false,
    bool showDeleteDialog = false,
  }) async {
    var allAttachments = attachments;
    allAttachments.removeWhere((element) => element == null);
    Console.of.log(attachments);
    await showDialog(
      context: context,
      builder: (context) => _ShowAttachmentsDialogView(
        attachments: attachments,
        title: title,
        currentAttachment: currentAttachment,
        onDeleted: onDeleted,
        onDownload: onDownload,
        showDownload: showDownload,
        showDeleteDialog: showDeleteDialog,
      ),
    );
  }
}

class _ShowAttachmentsDialogView extends StatelessWidget {
  final List<dynamic> attachments;
  final String? title;
  final dynamic currentAttachment;
  final void Function(dynamic value)? onDeleted;
  final void Function(dynamic value)? onDownload;
  final bool showDownload;
  final bool showDeleteDialog;

  const _ShowAttachmentsDialogView({
    required this.attachments,
    required this.title,
    this.currentAttachment,
    this.onDeleted,
    this.onDownload,
    this.showDownload = false,
    this.showDeleteDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(16),
      titlePadding: const EdgeInsets.only(top: 10),
      title: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        dense: true,
        title: Utils.getText(title ?? "",
            weight: FontWeight.bold,
            size: context.textTheme.titleMedium?.fontSize ?? 0),
        trailing: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close_rounded),
        ),
      ),
      content: Container(
        constraints: BoxConstraints(
            minWidth: MediaQuery.sizeOf(context).width,
            maxHeight: MediaQuery.sizeOf(context).height * 0.6),
        padding: 15.padding,
        child: AttachmentSliderView(
          attachments: attachments,
          currentAttachment: currentAttachment,
          onDeleted: (onDeleted == null) ? null : (value) {
            onDeleted?.call(value);
          },
          showDownload: showDownload,
          showDeleteAlertDialog: showDeleteDialog,
          onDownload: (onDownload == null) ? null : (value) {
            onDownload?.call(value);
          },
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
