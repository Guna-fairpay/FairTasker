import 'dart:io';
import 'package:fairpytasker/Remote/downloader.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:html_to_flutter_kit/html_to_flutter_kit.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentViewer extends StatelessWidget {
  final dynamic input;
  final bool enableDownload;
  final double ratio;
  const DocumentViewer({super.key, this.input, this.enableDownload = true, this.ratio = 0.63});

  @override
  Widget build(BuildContext context) {
    var fileHtml = """
    <iframe src="https://docs.google.com/gview?url=$input&embedded=true"/>
    """;

    Widget child = const SizedBox.shrink();
    if (input is String && !input.toString().contains("amazonaws.com")) {
      child = Html(
        config: HtmlConfig(styleOverrides: {
          "iframe": Style(height: context.height * ratio, width: 411)
        }, extensions: const [
          TableExtension(),
          IframeExtextion()
        ], onTap: (url, [attributes, element]) {
          element?.text = fileHtml;
        },),
        data: fileHtml,
        key: UniqueKey(),
      );
    } else if (input is String && (input.toString().contains("amazonaws.com"))) {
      child = SfPdfViewer.network(input.toString(), enableDoubleTapZooming: true,
          interactionMode: PdfInteractionMode.pan,
          scrollDirection: PdfScrollDirection.horizontal);
    } else if (input is File) {
      // child = SfPdfViewer.network(input.toString(), enableDoubleTapZooming: true,
      //     interactionMode: PdfInteractionMode.pan,
      //     scrollDirection: PdfScrollDirection.horizontal);
      child = Column(
        spacing: 10.spMin,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.file_present_rounded, size: 46.spMin, color: AppC.text),
          Text(
            p.basename((input as File).path),
            style: context.textTheme.titleMedium,
          )
        ],
      );
    }
    return child;
  }
}
