
import 'package:fairpytasker/Component/custom_vehicle_expense_history_Info.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_expense_history/ui/vehicle_expense_history_edit_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Component/close_badge.dart';
import '../../../../Component/image_viewer.dart';
import '../../../../Utilities/Utils.dart';
import '../../../dialog/show_attachments_dialog.dart';
import '../bloc/vehicle_expense_history_bloc.dart';
import '../event/vehicle_expense_history_event.dart';
import '../state/vehicle_expense_history_state.dart';

class VehicleExpenseHistoryEditViewUI extends StatelessWidget {
  final String? id;
  const VehicleExpenseHistoryEditViewUI({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VehicleExpenseHistoryBloc>(
      create: (context) => VehicleExpenseHistoryBloc()
        ..add(GetEditVehicleExpenseHistory(id: id)),
      child:
          BlocListener<VehicleExpenseHistoryBloc, VehicleExpenseHistoryState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
        },
        child:
            BlocBuilder<VehicleExpenseHistoryBloc, VehicleExpenseHistoryState>(
                builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("View Expense"),
              foregroundColor: Colors.white,
              backgroundColor: AppC.appColor,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            body: SafeArea(
              minimum: 20.padding,
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                          color: Colors.blueAccent.shade100, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoWidget(
                          icon: Icons.monetization_on_outlined,
                          label: 'Amount',
                          value:
                              "${state.editResponse['expense_amount'] ?? ''}",
                        ),
                        const Divider(thickness: 0.5, color: Colors.grey),
                        InfoWidget(
                          icon: Icons.description,
                          label: 'Description',
                          value:
                              "${state.editResponse['expense_description'] ?? ''}",
                        ),
                        const Divider(thickness: 0.5, color: Colors.grey),
                        InfoWidget(
                          icon: Icons.category,
                          label: 'Category',
                          value: "${state.selectedCategory['name'] ?? ''}",
                        ),
                        const Divider(thickness: 0.5, color: Colors.grey),
                        InfoWidget(
                          icon: Icons.category_outlined,
                          label: 'SubCategory',
                          value: "${state.selectedSubCategory['name'] ?? ''}",
                        ),
                        const Divider(thickness: 0.5, color: Colors.grey),
                        InfoWidget(
                          icon: Icons.payment,
                          label: 'Payment Method',
                          value: "${state.selectedPaymentMethod['name'] ?? ''}",
                        ),
                        const Divider(thickness: 0.5, color: Colors.grey),
                        const InfoWidget(
                          icon: Icons.attachment_outlined,
                          label: 'Attachments',
                          value: "",
                        ),
                        if (state.expenseAttachments.isNotEmpty)
                          SizedBox(
                            height: 100,
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: state.expenseAttachments.length,
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1, mainAxisSpacing: 10),
                              itemBuilder: (context, index) => CloseBadge(
                                  showClose: false,
                                  onTapView: () {
                                    /*var currentData = state.expenseAttachments[index];
                                    if ((currentData is String) && (currentData.isPDF)) {
                                      // OPEN URL
                                      Utils.openURL(currentData);
                                    } else {
                                      ShowAttachmentsDialog.of.show(context,
                                          attachments: state.expenseAttachments,
                                          title: "",
                                          currentAttachment:
                                          state.expenseAttachments[index]);
                                    }*/
                                    ShowAttachmentsDialog.of.show(context,
                                        attachments: state.expenseAttachments,
                                        title: "",
                                        currentAttachment:
                                        state.expenseAttachments[index]);
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
                                          imageInput: state.expenseAttachments[index],
                                          isNotImage: !((state.expenseAttachments[index]
                                                  as Object)
                                              .isImage),
                                        ),
                                      ),
                                      // Add download button only for PDF
                                      if ((state.expenseAttachments[index] as Object).isPDF)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppC.green,
                                            borderRadius: BorderRadius.circular(16),

                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Utils.openURL(state.expenseAttachments[index]);
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
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Utils.getElevatedButton(
                        () => context.pushReplacement(
                            VehicleExpenseHistoryEditPage(
                              id: "${state.editResponse['id']}",
                            ), fullscreenDialog: true
                        ),
                        text: 'Edit',
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
