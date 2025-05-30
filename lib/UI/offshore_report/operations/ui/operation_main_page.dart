import 'package:fairpytasker/UI/offshore_report/operations/bloc/operation_bloc.dart';
import 'package:fairpytasker/UI/offshore_report/operations/ui/operation_details_page.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OperationMainPage extends StatelessWidget {
  const OperationMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OperationBloc()..add(OperationInitialEvent()),
        child: BlocListener<OperationBloc, OperationState>(
          listener: (context,state){
            if(state is LoadingState){
              EasyLoading.show();
            }else{
              EasyLoading.dismiss();
              if(state is ErrorState) Toaster.showError(state.message);
              if(state is SuccessState) Toaster.showSuccess(state.message);
            }
          },
            child: const OperationDetailsPage())
    );
  }
}
