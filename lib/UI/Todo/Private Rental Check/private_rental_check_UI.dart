import 'dart:developer';

import 'package:fairpytasker/UI/Todo/Private%20Rental%20Check/private_rental_popup.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import '../maintenance/maintenance_bloc.dart';
import '../maintenance/maintenance_event.dart';
import '../maintenance/maintenance_state.dart';

class PrivateRentalCheckUi extends StatelessWidget {
  final dynamic todoItems, vehicle;
  const PrivateRentalCheckUi({super.key, required this.todoItems, required this.vehicle});


  // void _showTaskPopup(BuildContext context, MaintenanceBloc maintenanceBloc, var todoId) {
  //   final overlay = Overlay.of(context);
  //   OverlayEntry? overlayEntry;
  //   overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       top: 50,
  //       left: MediaQuery.of(context).size.width * 0.025,
  //       width: MediaQuery.of(context).size.width * 0.95,
  //       child: Material(
  //         color: Colors.transparent,
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10),
  //             boxShadow: const [
  //               BoxShadow(
  //                 color: Colors.black26,
  //                 blurRadius: 6,
  //                 offset: Offset(0, 3),
  //               ),
  //             ],
  //           ),
  //           constraints: BoxConstraints(
  //             minHeight: 100,
  //             maxHeight: MediaQuery.of(context).size.height * 0.5,
  //           ),
  //           child: IntrinsicHeight(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Close Button and Message in One Row
  //                 ListTile(
  //                   contentPadding: EdgeInsets.zero,
  //                   dense: true,
  //                   visualDensity: VisualDensity.compact,
  //                   trailing: IconButton(
  //                     icon: const Icon(Icons.close),
  //                     onPressed: () {
  //                       overlayEntry?.remove();
  //                       overlayEntry = null;
  //                     },
  //                   ),
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Expanded(
  //                       child: Utils.getText(
  //                         "Task already exists, please complete or delete the task",
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 // Buttons Row
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     Utils.getAddFilledButton("Complete", () {
  //                       overlayEntry?.remove();
  //                       overlayEntry = null;
  //                       maintenanceBloc.add(CompletePrivateRentalItemEvent(todoId: todoId));
  //                     }, bgColor: AppC.green),
  //                     const SizedBox(
  //                       width: 30,
  //                     ),
  //                     Utils.getAddFilledButton("Delete", () {
  //                       overlayEntry?.remove();
  //                       overlayEntry = null;
  //                       maintenanceBloc.add(DeletePrivateRentalItemEvent(todoId: todoId));
  //                     }, bgColor: AppC.red),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //   overlay.insert(overlayEntry!);
  // }

  Widget checkBoxWithSingleTextAndTexBox({
    required bool checkboxValue,
    required ValueChanged<bool?> onCheckboxChanged,
    required String label,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: Checkbox(
            activeColor: AppC.blue,
            value: checkboxValue,
            onChanged: onCheckboxChanged,
          ),
        ),
        Expanded( // Ensures the text wraps
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              label,
              style: TextStyle(fontSize: 14),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MaintenanceBloc()..add(
          PrivateRentalInitialEvent(todoItem: todoItems, vehicle: vehicle)
      ),
      child: BlocListener<MaintenanceBloc, MaintenanceState>(
        listener: (context, state) {
          if (state.isLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            if (state.pop) context.pop();
            log("${state.getPrivateRentalCheckData}" , name: "PrivateRentalCheckUi");
          }
        },
        child: BlocBuilder<MaintenanceBloc, MaintenanceState>(
          builder: (context, state) {
            return
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    shrinkWrap: true, // Add this
                    physics: const NeverScrollableScrollPhysics(), // Add this
                    itemCount: state.getPrivateRentalCheckData?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = state.getPrivateRentalCheckData?[index];
                      final itemId = item?['id'] as int?;
                      final controller = itemId != null ? state.privateRentalNoteControllers[itemId] : null;
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Important
                          children: [
                            checkBoxWithSingleTextAndTexBox(
                              checkboxValue: item?['isChecked'],
                              onCheckboxChanged: (value) async {
                                if (itemId != null) {
                                  final controller = state.privateRentalNoteControllers?[itemId];
                                  final hasExistingNotes = controller?.text.isNotEmpty ?? false;

                                  if (value == true && hasExistingNotes) {
                                    PrivateRentalDialog.show(context,onCompleted: () =>
                                    context.read<MaintenanceBloc>().add(CompletePrivateRentalItemEvent(todoId: item?['todoId'])),
                                    onDelete: () => context.read<MaintenanceBloc>().add(DeletePrivateRentalItemEvent(todoId: item?['todoId']))
                                    );
                                  } else {
                                    context.read<MaintenanceBloc>().add(
                                      UpdateCheckboxEvent(
                                        itemId: itemId,
                                        isChecked: value ?? false,
                                      ),
                                    );
                                  }
                                }
                              },
                              label: item?['title'] ?? '',
                            ),
                            Visibility(
                              visible: !item?['isChecked'],
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 40.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Utils.getBorderedMultilineTextField(
                                      'Notes',
                                      controller!,
                                      minLines: 2,
                                    ),
                                    const SizedBox(height: 5),
                                    Utils.getAddFilledButton(
                                      'Create Task',
                                      (){
                                        context.read<MaintenanceBloc>().add(createPrivateFixTaskEvent(
                                            notes: '${item?['title']} - ${controller.text}',
                                          id: item?['id'].toString(),
                                          todoItem: todoItems,
                                          vehicle: vehicle,)
                                        );
                                      },
                                      bgColor: AppC.green,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                  ),
                ),
              );
          },
        ),
      ),
    );
  }
}
