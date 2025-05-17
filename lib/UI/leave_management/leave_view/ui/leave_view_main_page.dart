

import 'package:fairpytasker/UI/leave_management/leave_add_edit/ui/leave_add_edit_main_page.dart';
import 'package:fairpytasker/UI/leave_management/leave_verification/ui/leave_verification_main_page.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/bloc/leave_view_bloc.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/bloc/leave_view_event.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/bloc/leave_view_state.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/ui/leave_list_view_for_employee.dart';
import 'package:fairpytasker/UI/leave_management/leave_view/ui/leave_view_listing_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LeaveViewMainPage extends StatelessWidget {
  const LeaveViewMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Management',),
        automaticallyImplyLeading: false,
        foregroundColor: AppC.white,
        backgroundColor: AppC.appColor,
        actions: [
          IconButton(onPressed: () =>context.pop(), icon: const Icon(Icons.close_outlined))
        ],
      ),
      body: BlocProvider<LeaveViewBloc>(
        create: (context)=>LeaveViewBloc()..add(LeaveViewInitialEvent()),
        child: BlocListener<LeaveViewBloc,LeaveViewState>(
          listener: (context, state) {
            if(state is LeaveViewLoadingState) {
              EasyLoading.show();
            } else {
              EasyLoading.dismiss();
              if(state is AddEditPageState) context.push(LeaveAddEditMainPage(leaveData: state.leaveData,));
              if(state is VerificationPageState) context.push(LeaveVerificationMainPage(data: state.leaveData));
            }
          },
          child: ((getIt<CommonService>().isAdmin) ? const LeaveViewListingPage() : const LeaveListViewForEmployee()),
        ),
      ),
    );
  }
}
