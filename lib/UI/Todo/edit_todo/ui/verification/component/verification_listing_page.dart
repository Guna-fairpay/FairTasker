import 'package:card_swiper/card_swiper.dart';
import 'package:fairpytasker/Component/attachment_slider_view.dart';
import 'package:fairpytasker/Component/compact_doc_viewer.dart';
import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/image_preview.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/component/verification_enum.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class VerificationListingPage extends StatelessWidget {
  final bool showPDFButtons;
  final List<dynamic>? checkList;
  final TextEditingController controller;
  final Function(dynamic value) forceOnChanged;
  final Function(dynamic value) approveOnTap;
  final Function(dynamic value) rejectOnTap;
  final Function(dynamic value) checkListOnChange;
  final dynamic model;
  final List<dynamic> attachments;
  final bool isPdf;
  final bool forceAction;

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
    required this.checkListOnChange,
    this.forceAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        if(attachments.isNotEmpty)
          SizedBox(
            height: context.height * 0.6,
            child: Container(
              padding: 5.padding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.grey.shade200
                    ]),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Swiper(
                scrollDirection: Axis.horizontal,
                itemCount: attachments.length,
                loop: false,
                pagination: const SwiperPagination(
                  alignment: Alignment.topCenter,
                  builder: SwiperPagination.dots
                ),
                outer: true,
                indicatorLayout: PageIndicatorLayout.SLIDE,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var attachment = attachments[index];
                  var notesController = attachment['controller'] as TextEditingController;
                  var status = (attachment?['verification'])?['approved'] == false && (attachment?['verification'])?['rejected'] == false
                      ?'Pending'
                      :(attachment?['verification'])?['approved'] == true
                      ?'Approved':'Rejected';
                  return Column(
                    spacing: 10,
                    children: [
                      Expanded(child:isPdf?DocumentViewer(input: attachment['file_url'], ratio: 0.5,): ImagePreview(imageInput: attachment['file_url'])),
                      Row(
                        children: [
                          Expanded(child: Text.rich(TextSpan(
                            children: [
                              TextSpan(text: attachment['name']),
                              WidgetSpan(child: 10.spMin.width),
                              WidgetSpan(child: Container(
                                  padding: 2.padding,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppC.blue,
                                  ),
                                  child: CompactText(status, color: AppC.white, fontWeight: FontWeight.w900, styleType: TextStyleType.bodySmall,)
                              ),)
                            ],
                          ))),
                        ],
                      ),
                      Row(
                        spacing: 20,
                        children: [
                          Flexible(child: Utils.getTextFormField('Notes', notesController, minLines: 2, maxLines: 2,)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomCheckboxListTile(
                                title: const Text('Force Action'),
                                value: forceAction,
                                onChanged: (value) => forceOnChanged(value),
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
                                  SuccessButton(text: 'Approve', onPressed: ()=> approveOnTap(attachment),),
                                  SuccessButton(text: 'Reject', backgroundColor: AppC.redAccent, onPressed: ()=> rejectOnTap(attachment),),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },

              ),
            ),
          ),  /*Row(
            children: [
              ...attachments.map((e) => Container(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.sizeOf(context).width,
                    maxHeight: MediaQuery.sizeOf(context).height * 0.6),
                padding: 15.padding,
                child: Image.network(e['file_url']),
              ),),
            ],
          )*/
          // Column(
          //   children: [
          //     ...attachments.map((e) => Container(
          //       constraints: BoxConstraints(
          //           minWidth: MediaQuery.sizeOf(context).width,
          //           maxHeight: MediaQuery.sizeOf(context).height * 0.6),
          //       padding: 15.padding,
          //       child: SfPdfViewer.network(e),
          //     ),),
          //   ],
          // ),
        if(showPDFButtons)...[
          Row(
            spacing: 10,
            children: [
              const SuccessButton(text: 'View', backgroundColor: AppC.appColor,),
              SuccessButton(text: 'Regenerate', backgroundColor: AppC.appColor, onPressed:(){},),
             // const SuccessButton(text: 'Generate', backgroundColor: AppC.appColor,),
            ],
          ),
        ],
        /*Row(
          spacing: 20,
          children: [
            Flexible(child: Utils.getTextFormField('Notes', controller, minLines: 2, maxLines: 2,)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCheckboxListTile(
                  title: const Text('Force Action'),
                  value: forceAction,
                  onChanged: (value) => forceOnChanged(value),
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
        ),*/
        const Divider(color: AppC.grey, height: 5, thickness: 1,),
        const CompactText('Checklist', fontWeight: FontWeight.bold, color: AppC.lightDark,),
        ...?checkList?.map((e) =>
            CustomCheckboxListTile(
              title: Text(e?['description'] ?? ''),
              value: e['is_checked'],
              onChanged: (value) => checkListOnChange(e),
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
