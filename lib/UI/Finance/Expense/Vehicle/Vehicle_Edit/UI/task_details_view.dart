import 'package:fairpytasker/Component/choice_box_widget.dart';
import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/icon_with_text.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskDetailsViewUI extends StatelessWidget {
  final dynamic todoDetails;
  final dynamic expenseDetails;
  final List<dynamic> userNames;
  final List<String>? vehicleNames;
  final String? categoryName;
  final String? subCategoryName;
  final List<dynamic> attachments;
  const TaskDetailsViewUI(
      {super.key,
      required this.todoDetails,
      required this.expenseDetails,
      required this.userNames,
      required this.vehicleNames,
      required this.categoryName,
      required this.subCategoryName,
      required this.attachments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${todoDetails?['title'] ?? ''}"),
        foregroundColor: AppC.white,
        backgroundColor:todoDetails?['status'] == 'In Progress'? AppC.appColor: AppC.green,
        automaticallyImplyLeading: false,
        titleTextStyle: TextStyle(
          color: AppC.white,
          fontSize: 20.spMin,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Utils.getText(
              "TODO DETAILS",
              weight: FontWeight.bold,
              size: 16,
            ),
            IconAndText(
                icon: Icons.date_range,
                label:
                    "${todoDetails['todo_date'].toString().toDateTime().toFormat(format: "MM-dd-yyyy") ?? ''}  "
                    "${Utils.convertString24HTo12H("${todoDetails['todo_time'] ?? ''}")}"),
            IconAndText(
              icon: Icons.person,
              label: userNames.join(','),
            ),
            IconAndText(
              icon: Icons.directions_car_filled,
              label: vehicleNames!.join(','),
            ),
            if (todoDetails['vendor_name'] != null)
              IconAndText(
                icon: Icons.person_pin_outlined,
                label: "${todoDetails['vendor_name'] ?? ''}",
              ),
            if (todoDetails['notes'] != null)
              IconAndText(
                icon: Icons.speaker_notes,
                label: "${todoDetails['notes'] ?? ''}",
              ),
            if ((todoDetails?['parts'] as List?)?.isNotEmpty ?? false)
              ChoiceBoxWidget<Map<String, dynamic>>(
                bgColor: AppC.lightGreen,
                  items: (List<Map<String, dynamic>>.from(todoDetails?['parts']))
                      .distinct((e) => e['parts_id']),
                  itemAsString: (item) => item['parts_name'] ?? ""),
            if ((todoDetails?['supplies'] as List?)?.isNotEmpty ?? false)
              ChoiceBoxWidget<Map<String, dynamic>>(
                  bgColor: AppC.lightGreen,
                  items: (List<Map<String, dynamic>>.from(todoDetails?['supplies']))
                      .distinct((e) => e['supplies_id']),
                  itemAsString: (item) => item['supplies_name'] ?? ""),
            const IconAndText(
              icon: Icons.speed,
              label: "No Odometer",
            ),

            Utils.getText(
              "Expense",
              weight: FontWeight.bold,
              size: 16.spMin,
              color: AppC.appColor,
            ),
            IconAndText(
              icon: Icons.monetization_on_outlined,
              label: "${expenseDetails['expense_amount'] ?? ''}",
            ),
            IconAndText(
              icon: Icons.speaker_notes_outlined,
              label: "${expenseDetails['expense_description'] ?? ''}",
            ),
            IconAndText(
              icon: Icons.category,
              label: categoryName ?? '',
            ),
            IconAndText(
              icon: Icons.category_outlined,
              label: subCategoryName ?? '',
            ),
            const Icon(Icons.attachment_outlined),
            if (attachments.isNotEmpty)
              SizedBox(
                height: 100,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: attachments.length,
                  scrollDirection: Axis.horizontal,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, mainAxisSpacing: 10),
                  itemBuilder: (context, index) => CloseBadge(
                    showClose: false,
                    onTapView: () {
                      ShowAttachmentsDialog.of.show(context,
                          attachments: attachments,
                          title: "",
                          currentAttachment:
                          attachments[index]);
                    },
                    child: Stack(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            minHeight:
                            MediaQuery.sizeOf(context).height,
                            minWidth:
                            MediaQuery.sizeOf(context).width,
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(16),
                              color:
                              AppC.grey.withValues(alpha: 0.2)),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: ImageViewer(
                            fit: BoxFit.cover,
                            imageInput: attachments[index],
                            isNotImage: !((attachments[index]
                            as Object)
                                .isImage),
                          ),
                        ),
                        // Add download button only for PDF
                        if ((attachments as Object).isPDF)
                          Container(
                            decoration: BoxDecoration(
                              color: AppC.green,
                              borderRadius: BorderRadius.circular(16),

                            ),
                            child: InkWell(
                              onTap: () {
                                Utils.openURL(attachments[index]);
                              },child:Padding(
                              padding: 1.padding,
                              child: const Icon(Icons.download,color: AppC.white,),
                            ),),
                          ),

                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
