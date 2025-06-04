import 'package:fairpytasker/UI/Finance/Expense/other/other_add_edit/bloc/other_add_edit_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_add_edit/ui/other_add_edit_listing_page.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OtherAddEditMainPage extends StatelessWidget {
  final String? id;
  const OtherAddEditMainPage({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtherAddEditBloc()..add(InitialEvent(id: id)),
        child: BlocListener<OtherAddEditBloc, OtherAddEditState>(
          listener: (context, state) {
            if(state is LoadingState){
              EasyLoading.show();
            } else{
              if (state is! SuccessState) if (EasyLoading.isShow) EasyLoading.dismiss();
              if(state is ErrorState) Toaster.showError(state.error);
              if(state is SuccessState) {
              Toaster.showSuccess(state.message);
              context.pop();
            }
          }
          },
            child: const OtherAddEditListingPage(),
        ),
    );
  }
}