import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_add_edit/ui/other_add_edit_main_page.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_expense_details/ui/other_expense_details_listing_page.dart';
import 'package:fairpytasker/UI/Finance/Expense/person/person_add_and_edit/ui/person_add_edit_main_ui.dart';
import 'package:fairpytasker/UI/Finance/Expense/person/person_expense_details/bloc/person_expense_details_bloc.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'person_expense_details_listing_ui.dart';


class PersonExpenseDetailsMainUI extends StatelessWidget {
  final dynamic model;
  const PersonExpenseDetailsMainUI({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PersonExpenseDetailsBloc()..add(InitialEvent(model: model)),
        child: BlocListener<PersonExpenseDetailsBloc, PersonExpenseDetailsState>(
          listener: (context, state) {
            if(state is LoadingState){
              EasyLoading.show();
            }else{
              if(EasyLoading.isShow) EasyLoading.dismiss();
              switch(state){
                case ErrorState(): Toaster.showError(state.message); break;
                case SuccessState(): Toaster.showSuccess(state.message); break;
                case EditState(): context.push(PersonAddEditMainUI(model: state.model)); break;
                default: break;
              }
            }
          },
          child: const PersonExpenseDetailsListingUI(),
        )
    );
  }
}
