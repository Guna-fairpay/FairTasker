import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/archive_task/component/archive_task_list_item.dart';
import 'package:fairpytasker/UI/archive_task/component/task_filter_dialog/ui/task_filter_dialog.dart';
import 'package:fairpytasker/UI/archive_task/unarchived_task/bloc/unarchived_bloc.dart';
import 'package:fairpytasker/UI/dialog/show_notes_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'unarchive_task_listing_ui.dart';

class UnarchiveTaskMainUI extends StatelessWidget {
  const UnarchiveTaskMainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UnarchivedBloc()..add(InitEvent()),
      child: BlocListener<UnarchivedBloc, UnarchivedState>(
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
          child: const UnarchiveTaskListingUI()
      ),
    );
  }
}
