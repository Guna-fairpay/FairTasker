import 'package:fairpytasker/UI/Finance/Expense/other/component/category_dialog/ui/category_dialog_ui.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_add_edit/ui/other_add_edit_main_page.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_expense_details/ui/other_expense_details_main_page.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_view/bloc/other_view_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_view/ui/other_view_page.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OtherMainPage extends StatelessWidget {
  const OtherMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OtherViewBloc()..add(InitialEvent()),
        child: BlocListener<OtherViewBloc, OtherViewState>(
            listener: (context, state) {
              if (state is LoadingState) {
                EasyLoading.show();
              } else {
                if(EasyLoading.isShow) EasyLoading.dismiss();
                switch(state){
                  case SuccessState(): Toaster.showSuccess(state.message); break;
                  case ErrorState(): Toaster.showError(state.message); break;
                  case AddEditState(): context.push(OtherAddEditMainPage(id: state.id)); break;
                  case CategoryDialogState(): CategoryDialogUI.show(model: state.model, context: context,); break;
                  case OtherDetailsState(): context.push(OtherExpenseDetailsMainPage(model: state.model)); break;
                  default: break;
                }
              }
            },
            child: const OtherViewPage(),
        ),
    );
  }
}
