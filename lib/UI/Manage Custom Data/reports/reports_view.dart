import 'package:fairpytasker/Component/compact_file_picker.dart';
import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:remixicon/remixicon.dart';

part 'tolls/tolls.dart';
part 'report/reports.dart';
part 'reports_view_body.dart';
part 'task_report/task_report.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        leadingWidth: 0,
        title: const Text("Reports"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: context.pop, icon: const Icon(Icons.close_rounded))
        ],
        foregroundColor: Colors.white,
        backgroundColor: AppC.appColor,
      ),
      body: BlocProvider(
        create: (context) => ReportsBloc(),
        child: BlocListener<ReportsBloc, ReportState>(listener: (context, state) {
          if (state is ReportsLoadingState) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            switch(state) {
              case ReportsErrorState(): Toaster.showError(state.message, context: context); break;
              case ReportsSuccessState(): Toaster.showSuccess("Success", context: context); break;
            }
          }
        },
        child: const ReportsViewBody()),
      ),
    );
  }
}
