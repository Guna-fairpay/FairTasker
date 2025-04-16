
import 'dart:developer';
import 'package:fairpytasker/UI/Todo/Private%20Rental%20Check/private_rental_popup.dart';
import 'package:fairpytasker/UI/Todo/Private%20Rental%20Check/privaterental_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import 'package:fairpytasker/UI/Todo/Private%20Rental%20Check/privaterental_event.dart';
import 'package:fairpytasker/UI/Todo/Private%20Rental%20Check/privaterental_state.dart';
import 'package:html/parser.dart';

extension ContextExtension on BuildContext {
  void pop() => Navigator.of(this).pop();
}

class PrivateRentalCheckUi extends StatelessWidget {
  final dynamic todoItems, vehicle;

  const PrivateRentalCheckUi({super.key, required this.todoItems, required this.vehicle});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrivateRentalsBloc()
        ..add(PrivateRentalInitialEvent(
          todoItem: todoItems,
          vehicle: vehicle,
        )),
      child: BlocListener<PrivateRentalsBloc, PrivateRentalsState>(
        listener: (context, state) {
          if (state.isLoading) {
            EasyLoading.show(status: 'Loading...');
          } else {
            EasyLoading.dismiss();
            if (state.pop) {
              context.pop();
            }
            log("PrivateRentalCheckData: ${state.getPrivateRentalCheckData}", name: "PrivateRentalCheckUi");
          }
        },
        child: BlocBuilder<PrivateRentalsBloc, PrivateRentalsState>(
          builder: (context, state) {
            if (state.getPrivateRentalCheckData == null || state.getPrivateRentalCheckData!.isEmpty) {
              return const Center(child: Text(''));
            }
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.getPrivateRentalCheckData!.length,
                        itemBuilder: (context, index) {
                          return checkListItem(
                            context,
                            state.getPrivateRentalCheckData![index],
                            state.checkBoxStates,
                            state.privateRentalNoteControllers,
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget checkListItem(
      BuildContext context,
      Map<String, dynamic> checkListData,
      Map<int, bool> checkBoxStates,
      Map<int, TextEditingController> noteControllers,
      ) {
    final int itemId = checkListData['id'];
    final notesController = noteControllers[itemId] ?? TextEditingController();

    // Parse notes to remove HTML and extract custom content
    String extractedText = notesController.text.split('-').length > 1
        ? notesController.text.split('-')[1].trim()
        : notesController.text;
    extractedText = parse(extractedText).body?.text ?? extractedText;
    bool hasNotes = extractedText.isNotEmpty;
    bool isChecked = checkBoxStates[itemId] ?? !hasNotes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              activeColor: AppC.blue,
              value: isChecked,
              onChanged: (bool? value) {
                if (value != null) {
                  final bloc = context.read<PrivateRentalsBloc>();
                  // Check if there's an existing task (based on notes or matchingTodos logic)
                  final matchingTodo = bloc.matchingTodos.firstWhere(
                        (todo) => todo['checklist_id'] == itemId,
                    orElse: () => {},
                  );
                  if (value && matchingTodo.isNotEmpty) {
                    PrivateRentalDialog.show(context,
                      onCompleted: ()
                      {
                        context.read<PrivateRentalsBloc>().add(CompletePrivateRentalItemEvent(todoId: matchingTodo['todoId']));
                      },
                      onDelete: ()
                      {
                        context.read<PrivateRentalsBloc>().add(DeletePrivateRentalItemEvent(todoId: matchingTodo['todoId']));
                      },);
                  } else {
                    context.read<PrivateRentalsBloc>().add(
                      UpdateCheckboxEvent(
                        itemId: itemId,
                        isChecked: value,
                      ),
                    );
                  }
                }
              },
            ),
            Expanded(
              child: Text(
                checkListData['title']?.toString() ?? '',
                style: const TextStyle(fontSize: 14),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
        if (!isChecked)
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getBorderedMultilineTextField(
                  'Notes',
                  notesController,
                  minLines: 2,
                ),
                const SizedBox(height: 5),
                Utils.getAddFilledButton(
                  'Create Task',
                      () {
                    context.read<PrivateRentalsBloc>().add(
                      CreatePrivateFixTaskEvent(
                        notes: '${checkListData['title']} - ${notesController.text}',
                        id: itemId.toString(),
                        todoItem: todoItems,
                        vehicle: vehicle,
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
