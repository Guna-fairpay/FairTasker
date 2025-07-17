import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/archive_task/archived_task/bloc/archived_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'archived_task_listing_ui.dart';

class ArchivedTaskMainUI extends StatelessWidget {
  const ArchivedTaskMainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArchivedBloc()..add(InitEvent()),
      child: BlocListener<ArchivedBloc, ArchivedState>(
        listener: (context, state) {
          if(state is LoadingState){
            EasyLoading.show();
          }else{
            if(EasyLoading.isShow) EasyLoading.dismiss();
            switch(state){
              case ErrorState():
                Toaster.showError(state.message);
                break;
              case SuccessState():
                Toaster.showSuccess(state.data);
                break;
            }
          }
        },
        child: const ArchivedTaskListingUI()
      ),
    );
  }
}
