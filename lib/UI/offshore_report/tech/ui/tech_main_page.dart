
import 'package:fairpytasker/UI/offshore_report/tech/bloc/tech_bloc.dart';
import 'package:fairpytasker/UI/offshore_report/tech/ui/tech_details_list_page.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TechMainPage extends StatelessWidget {
  const TechMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TechBloc()..add(TechInitialEvent()),
        child: BlocListener<TechBloc, TechState>(
            listener: (context, state) {
              if (state is LoadingState){
                EasyLoading.show();
              }else{
                EasyLoading.dismiss();
                if(state is ErrorState) Toaster.showError(state.message);
                if(state is SuccessState) Toaster.showSuccess(state.message);
              }
            },
            child: const TechDetailsListPage()));
  }
}
