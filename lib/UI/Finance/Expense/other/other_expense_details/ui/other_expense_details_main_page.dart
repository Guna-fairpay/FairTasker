import 'package:fairpytasker/UI/Finance/Expense/other/other_add_edit/ui/other_add_edit_main_page.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_expense_details/bloc/other_expense_details_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_expense_details/ui/other_expense_details_listing_page.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OtherExpenseDetailsMainPage extends StatelessWidget {
  final dynamic id;
  const OtherExpenseDetailsMainPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtherExpenseDetailsBloc()..add(InitialEvent(id: id)),
        child: BlocListener<OtherExpenseDetailsBloc, OtherExpenseDetailsState>(
          listener: (context, state) {
            if(state is LoadingState){
              EasyLoading.show();
            }else{
              if(EasyLoading.isShow) EasyLoading.dismiss();
              switch(state){
                case ErrorState(): Toaster.showError(state.message); break;
                case SuccessState(): Toaster.showSuccess(state.message); break;
                case EditState(): context.push(OtherAddEditMainPage(id: state.id)); break;
                default: break;
              }
            }
          },
            child: const OtherExpenseDetailsListingPage(),
        )
    );
  }
}
