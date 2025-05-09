
import 'package:fairpytasker/UI/leave_management/leave_verification/bloc/leave_verification_bloc.dart';
import 'package:fairpytasker/UI/leave_management/leave_verification/bloc/leave_verification_event.dart';
import 'package:fairpytasker/UI/leave_management/leave_verification/bloc/leave_verification_state.dart';
import 'package:fairpytasker/UI/leave_management/leave_verification/ui/leave_verification_listing_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LeaveVerificationMainPage extends StatelessWidget {
  final dynamic data;
  const LeaveVerificationMainPage({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve/Reject Leave'),
        automaticallyImplyLeading: false,
        foregroundColor: AppC.white,
        backgroundColor: AppC.appColor,
        actions: [
          IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close))
        ],
      ),
      body: BlocProvider<LeaveVerificationBloc>(create: (context) => LeaveVerificationBloc()..add(LeaveVerificationInitialEvent(data: data)),
        child: BlocListener<LeaveVerificationBloc, LeaveVerificationState>(
            listener: (context , state){
              if(state is LeaveVerificationLoadingState){
                EasyLoading.show();
              }else{
                EasyLoading.dismiss();
                if(state is LeaveVerificationSuccessState) context.pop();
              }
            },
            child: const LeaveVerificationListingPage(),
        ),
      ),
    );
  }
}
