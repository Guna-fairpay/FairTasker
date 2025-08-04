
import 'package:fairpytasker/UI/leave_management/leave_add_edit/bloc/leave_add_edit_bloc.dart';
import 'package:fairpytasker/UI/leave_management/leave_add_edit/bloc/leave_add_edit_event.dart';
import 'package:fairpytasker/UI/leave_management/leave_add_edit/bloc/leave_add_edit_state.dart';
import 'package:fairpytasker/UI/leave_management/leave_add_edit/ui/leave_add_edit_textformfield_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LeaveAddEditMainPage extends StatelessWidget {
  final dynamic leaveData;
  const LeaveAddEditMainPage({super.key, this.leaveData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LeaveAddEditBloc>(
      create: (context) => LeaveAddEditBloc()..add(LeaveAddEditInitialEvent(data: leaveData)),
        child: BlocListener<LeaveAddEditBloc,LeaveAddEditState>(
          listener: (context,state){
            if(state is LeaveAddEditLoadingState) {EasyLoading.show();
            }else {
              EasyLoading.dismiss();
              if(state is LeaveAddEditSuccessState) context.pop();
            }
          },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(leaveData == null ? 'Apply Leave' : 'Edit Leave'),
                foregroundColor: AppC.white,
                backgroundColor: AppC.appColor,
                actions: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close_outlined),
                  ),
                ],
              ),
              body: const LeaveAddEditTextFormFieldPage(),
            ),
        ),
    );
  }
}
