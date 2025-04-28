import 'dart:developer';

import 'package:fairpytasker/UI/Todo/Private%20Rental%20Check/private_rental_check_UI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/prefs.dart';
import '../../dialog/ask_permission_dialog.dart';
import '../Private Rental Check/private_rental_popup.dart';
import 'check_list_bloc.dart';
import 'check_list_event.dart';
import 'check_list_state.dart';
import 'package:html/parser.dart';

class CheckListUI extends StatelessWidget {
  final dynamic todoItems, vehicle;

  const CheckListUI({super.key, required this.todoItems, this.vehicle});

  // void _showTaskPopup(BuildContext context, CheckListBloc checkListBloc) {
  //   final overlay = Overlay.of(context);
  //   OverlayEntry? overlayEntry;
  //   overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       top: 50,
  //       left: MediaQuery.of(context).size.width * 0.025, // Adjust position
  //       width: MediaQuery.of(context).size.width * 0.95, // Increased width
  //       child: Material(
  //         color: Colors.transparent,
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 8),
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
  //                 const SizedBox(height: 10,),
  //                 // Buttons Row
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     Utils.getAddFilledButton("Complete", () {
  //                       overlayEntry?.remove();
  //                       overlayEntry = null;
  //                       checkListBloc.add(const CompleteEvent(todoId: null));
  //                     }, bgColor: AppC.green),
  //                     const SizedBox(width: 30,),
  //                     Utils.getAddFilledButton("Delete", () {
  //                       overlayEntry?.remove();
  //                       overlayEntry = null;
  //                       AskPermissionDialog.show(context,
  //                           title: "Are you sure?",
  //                           description: "${Session.of.getString("name")},  are you sure you want to delete this task? Kindly enter a valid reason to confirm the deletion",
  //                           boldWords: [(Session.of.getString("name") ?? ''),","],
  //                           positiveText: "Yes, delete it!",
  //                           negativeText: "Cancel",
  //                           isReasonRequired: true,
  //                           onReasonSubmitted: (reason) => checkListBloc.add(DeleteEvent(reason: reason)),
  //                         //DeleteEvent
  //                       );
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

  @override
  Widget build(BuildContext context) {
    return
      BlocProvider(
      create: (context) => CheckListBloc()
        ..add(CheckListInitialEvent(
          todoItems: todoItems,
          vehicle: vehicle ?? {},
        )),
      child: BlocListener<CheckListBloc, CheckListState>(
        listener: (context, state) {
          if (state.isLoading) {
            EasyLoading.show();
          } else {
            EasyLoading.dismiss();
            if (state.pop) {
              context.pop();
            }
          }
        },
        child: BlocBuilder<CheckListBloc, CheckListState>(
          builder: (context, state) {
            if (state.checkListData == null || state.checkListData!.isEmpty) {
              return const SizedBox();
            }
            return
              SingleChildScrollView(
                child: Column(
                children: [
                  const SizedBox(height: 10),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.checkListData!.length,
                    itemBuilder: (context, index) {
                      return checkList(
                        context,
                        state.checkListData![index],
                        index,
                        state.checkBoxStates ?? {},
                        state.notesValues,
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                  ),
                  if (todoItems['title'] == 'Getaround Prechecks')
                    Utils.getText('Immobilizer Check'),
                ],
                ),
              );
          },
        ),
      ),
    );
  }

  Widget checkList(
      BuildContext context,
      Map<String, dynamic> checkListData,
      int index,
      Map<int, bool> checkBoxStates, List<String> notesValues,
      ) {
    final int itemId = checkListData['id'];
    final notesController = context.read<CheckListBloc>().state.notesControllers?[itemId] ?? TextEditingController();

    String extractedText = notesController.text.split('-').length > 1 ? notesController.text.split('-')[1].trim() : notesController.text;
    notesController.text = parse(extractedText).body?.text ?? extractedText;
    bool hasNotes = notesController.text.isNotEmpty;
    bool isChecked = checkBoxStates[itemId] ?? !hasNotes;
    //bool isChecked = !hasNotes;

    return
      Column(
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              activeColor: AppC.blue,
              value: isChecked,
              onChanged: (bool? value) {
                if (value != null) {
                  final bloc = context.read<CheckListBloc>();
                  final matchingTodo = bloc.matchingTodos.firstWhere(
                        (todo) => todo['checklist_id'] == itemId,
                    orElse: () => {},
                  );
                  log("${matchingTodo.toString()}", name: "matchingTodo");
                  if (value && matchingTodo.isNotEmpty) {
                    PrivateRentalDialog.show(context,
                      onCompleted: ()
                      {
                        //checkListBloc.add(const CompleteEvent());
                        bloc.add(CompleteEvent(matchingTodo['id']));
                      },
                      onDelete: ()
                      {
                        AskPermissionDialog.show(context,
                          title: "Are you sure?",
                          description: "${Session.of.getString("name")},  are you sure you want to delete this task? Kindly enter a valid reason to confirm the deletion",
                          boldWords: [(Session.of.getString("name") ?? ''),","],
                          positiveText: "Yes, delete it!",
                          negativeText: "Cancel",
                          isReasonRequired: true,
                          onReasonSubmitted: (reason) => bloc.add(DeleteEvent(todoId: matchingTodo['id'], reason: reason)),
                        );
                      }
                      ,);
                  } else {
                    bool newState = !(checkBoxStates[itemId] ?? !hasNotes);
                    context.read<CheckListBloc>().add(
                      IndividualCheckEvent(
                        checkListData['id'].toString(),
                        newState,
                        checkListData,
                      ),
                    );
                  }
                }
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Utils.getText(checkListData['title']?.toString() ?? ''),
                  Utils.getText("(${checkListData['description']?.toString() ?? ''})"),
                ],
              ),
            ),
          ],
        ),
        if (!isChecked)
          Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getBorderedMultilineTextField(
                  'Notes',
                  notesController,
                  minLines: 2,
                ),
                Utils.getAddFilledButton(
                  'Create Task',
                      () async {
                    var title = switch (checkListData['id']) {
                      1 => 'Clean Car',
                      7 => 'Oil Change Check',
                      8 => 'Refuel Car',
                      _ => 'Fix',
                    };
                    context.read<CheckListBloc>().add(
                      AddFixTaskEvent(
                        title: title,
                        notes: '${checkListData['title']}-${notesController.text}',
                        checklistId: checkListData['id'],
                      ),
                    );
                    FocusScope.of(context).unfocus();
                  },
                  bgColor: AppC.green,
                ),
              ],
            ),
          ),
      ],
    );
  }
}