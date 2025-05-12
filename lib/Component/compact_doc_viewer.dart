import 'dart:io';
import 'package:fairpytasker/Remote/downloader.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:html_to_flutter_kit/html_to_flutter_kit.dart';

class DocumentViewer extends StatelessWidget {
  final dynamic input;
  final bool enableDownload;

  const DocumentViewer({super.key, this.input, this.enableDownload = true});

  @override
  Widget build(BuildContext context) {
    var fileHtml = """
    <iframe src="https://docs.google.com/gview?url=$input&embedded=true"/>
    """;
    return (input is String)
        ? Stack(
            // spacing: 5,
            children: [
              Html(
                config: HtmlConfig(styleOverrides: {
                  "iframe": Style(height: context.height * 0.63, width: 411)
                }, extensions: const [
                  TableExtension(),
                  IframeExtextion()
                ], onTap: (url, [attributes, element]) {
                  element?.text = fileHtml;
                },),
                data: fileHtml,
                key: UniqueKey(),
              ),
              if (enableDownload)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () =>
                        Downloader.instance.start(input, openFile: true),
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.sp))),
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.grey.shade200),
                    ),
                    child: const Text("Download attachment!"),
                  ),
                )
            ],
          )
        : Column(
            spacing: 10.sp,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.file_present_rounded, size: 46.sp, color: AppC.text),
              Text(
                p.basename((input as File).path),
                style: context.textTheme.titleMedium,
              )
            ],
          );
  }
}
