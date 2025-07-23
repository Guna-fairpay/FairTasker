import 'package:fairpytasker/Component/attachment_slider_view.dart';
import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class VerificationListingPage extends StatelessWidget {
  final bool showPDFButtons;
  final List<dynamic>? checkList;
  final TextEditingController controller;
  final Function() forceOnChanged;
  final Function() approveOnTap;
  final Function() rejectOnTap;
  final dynamic model;
  final List<dynamic> attachments;
  final bool isPdf;

  const VerificationListingPage({super.key,
    this.showPDFButtons = false,
    this.checkList,
    required this.controller,
    required this.forceOnChanged,
    required this.approveOnTap,
    required this.rejectOnTap,
    this.model,
    required this.attachments,
    this.isPdf = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        if(attachments.isNotEmpty)
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: !isPdf ?  Row(
              children: [
                ...attachments.map((e) => Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.sizeOf(context).width,
                      maxHeight: MediaQuery.sizeOf(context).height * 0.6),
                  padding: 15.padding,
                  child: Image.network(e),
                ),),
              ],
            ):
            Column(
              children: [
                ...attachments.map((e) => Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.sizeOf(context).width,
                      maxHeight: MediaQuery.sizeOf(context).height * 0.6),
                  padding: 15.padding,
                  child: SfPdfViewer.network(e),
                ),),
              ],
            ),
          ),
        /*Container(
          constraints: BoxConstraints(
              minWidth: MediaQuery.sizeOf(context).width,
              maxHeight: MediaQuery.sizeOf(context).height * 0.6),
          padding: 15.padding,
          child: AttachmentSliderView(
            attachments: attachments,
          ),
        ),*/
        if(showPDFButtons)...[
          const Row(
            spacing: 10,
            children: [
              SuccessButton(text: 'View', backgroundColor: AppC.appColor,),
              SuccessButton(text: 'Regenerate', backgroundColor: AppC.appColor,),
              SuccessButton(text: 'Generate', backgroundColor: AppC.appColor,),
            ],
          ),
        ],
        Row(
          spacing: 20,
          children: [
            Flexible(child: Utils.getTextFormField('Notes', controller, minLines: 2, maxLines: 2,)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCheckboxListTile(
                  title: const Text('Force Action'),
                  value: false,
                  onChanged: (value) => forceOnChanged(),
                  padding: 0.padding,
                  useExpand: false,
                  mainAxisSize: MainAxisSize.min,
                  radius: 8,
                  borderColor: AppC.appColor,
                ),
                 Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SuccessButton(text: 'Approve', onPressed: ()=> approveOnTap,),
                    SuccessButton(text: 'Reject', backgroundColor: AppC.redAccent, onPressed: ()=> rejectOnTap,),
                  ],
                ),
              ],
            ),
          ],
        ),
        const Divider(color: AppC.grey, height: 5, thickness: 1,),
        const CompactText('Checklist', fontWeight: FontWeight.bold, color: AppC.lightDark,),
        ...?checkList?.map((e) =>
            CustomCheckboxListTile(
              title: Text(e?['description'] ?? ''),
              value: false,
              onChanged: (value) {},
              padding: 5.verticalPadding,
              useExpand: false,
              mainAxisSize: MainAxisSize.min,
              radius: 8,
              borderColor: AppC.appColor,
            ),
        ),
      ],
    );
  }
}
