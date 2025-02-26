
import 'package:fairpytasker/UI/Todo/edit_todo/bloc/edit_todo_bloc.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/event/edit_todo_event.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../Utilities/appC.dart';
import '../../../dialog/show_attachments_dialog.dart';
import '../state/edit_todo_state.dart';
import 'edit_todo_body.dart';

class EditTodoReworkUI extends StatelessWidget {
  final dynamic todoId;
  const EditTodoReworkUI({super.key,required this.todoId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditToDoBloc()..add(GetEditTodoInitialEvent(todoId: todoId)),
      child: BlocListener<EditToDoBloc, EditTodoState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
        },
        child: BlocBuilder<EditToDoBloc, EditTodoState>(
          builder: (context,state) {
            return state.isLoading? Container(color: AppC.white,)
                : Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor:state.apiResponse['status'] =='In Progress' ?AppC.appColor:Colors.green.shade900,
                title: Text(
                  (state.apiResponse['title']??'').toString().toTitleCase(),
                  style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 18),
                  maxLines: 2,
                ),
                foregroundColor: AppC.white,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: () => context.read<EditToDoBloc>().add(EditToDoEditAttachmentEvent()),
                    icon: const Icon(Icons.upload_rounded),
                    padding: EdgeInsets.zero,
                    constraints: state.attachments.isNotEmpty ? const BoxConstraints() : null,
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize
                          .shrinkWrap, // the '2023' part
                    ),
                  ),
                  if (state.attachments.isNotEmpty)
                    IconButton(
                      onPressed: () => ShowAttachmentsDialog.of.show(context, attachments: state.attachments, title: "Edit ToDo"),
                      icon: const Icon(Icons.remove_red_eye_outlined),
                      padding: EdgeInsets.zero,
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // the '2023' part
                      ),
                    ),
                  GestureDetector(
                    child: Transform.scale(
                      scale: 0.6,
                      child: SizedBox(width: 40,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Switch(
                              trackOutlineColor: WidgetStateColor.resolveWith(
                                    (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return AppC.green;
                                  } else {
                                    return AppC.grey;
                                  }
                                },
                              ),
                              inactiveThumbColor: AppC.white,
                              inactiveTrackColor: AppC.appColor,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              activeColor: AppC.white,
                              activeTrackColor: AppC.green,
                             // value: completeAllDay,
                              value: true,
                              onChanged: (value) {
                                // completeAllDay = value;
                                // setState(() {});
                                // todoBloc!.add(CompleteTodoItem(
                                //     todoId: todoItem['id'].toString(),
                                //     status: completeAllDay
                                //         ? 'Completed'
                                //         : 'In Progress'));
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //         const BottomNavigationForTaskView(
                                //           selectedIndex: 0,
                                //           message: '',
                                //         )
                                //     )
                                // );
                              }),
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: const Icon(Icons.delete)),
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: const Icon(Icons.save)),
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: const Icon(Icons.close)),
                ],
              ),
              body: SafeArea(
                minimum: 20.padding,
                child: const EditTodoBody(),
              ),
            );
          }
        ),
      ),
    );
  }
}
