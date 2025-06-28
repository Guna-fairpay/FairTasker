import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CustomQuillEditor extends StatelessWidget {
  final BoxConstraints? constraints;
  final QuillController? controller;
  final String? hintText;
  const CustomQuillEditor({super.key, this.controller, this.constraints, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Num.subradiusButton),
          border: Border.all(
              width: 0.02, color: Colors.grey.withValues(alpha: 0.2)),
          color: Colors.grey.withValues(alpha: 0.2)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QuillSimpleToolbar(controller: controller ?? QuillController.basic(),
            config: QuillSimpleToolbarConfig(
              showSmallButton: false,
              showSearchButton: false,
              showClipboardCopy: false,
              showClipboardCut: false,
              showClipboardPaste: false,
              showAlignmentButtons: false,
              showCenterAlignment: false,
              showCodeBlock: false,
              showColorButton: true,
              showRightAlignment: false,
              showLeftAlignment: false,
              showJustifyAlignment: false,
              showLink: false,
              showListCheck: true,
              showSubscript: false,
              showSuperscript: false,
              showInlineCode: false,
              showStrikeThrough: false,
              showClearFormat: false,
              showDividers: false,
              showLineHeightButton: false,
              showUndo: false,
              showRedo: false,
              showDirection: false,
              showIndent: false,
              showBackgroundColorButton: false,
              showQuote: false,
              showItalicButton: true,
              showListBullets: true,
              showListNumbers: false,
              color: AppC.inProgress,
              toolbarIconAlignment: WrapAlignment.start,
              showFontFamily: false,
              showFontSize: false,
              showHeaderStyle: false,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            constraints: constraints ?? const BoxConstraints(minHeight: 200),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Num.subradiusButton),
                border: Border.all(width: 0, color: Colors.transparent),
                color: context.theme.colorScheme.surface),
            child: QuillEditor(
              controller: controller ?? QuillController.basic(),
              scrollController: ScrollController(),
              focusNode: FocusNode(),
              config: QuillEditorConfig(
                enableSelectionToolbar: false,
                placeholder: hintText,
                padding: const EdgeInsets.all(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
