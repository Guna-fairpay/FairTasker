
import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/coumn_tile.dart';
import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/Component/row_tile.dart';
import 'package:fairpytasker/UI/dialog/task_cohort_filter/ui/task_cohort_filter_main_page.dart';
import 'package:fairpytasker/UI/resource/detailed_report/bloc/detailed_report_bloc.dart';
import 'package:fairpytasker/UI/resource/task_details/component/task_expansion_tile.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/int_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'detailed_report_header.dart';
part 'detailed_report_body.dart';
part 'detailed_report_by_task.dart';
part 'detailed_report_by_day.dart';
part 'component/detailed_report_by_day_item.dart';

class DetailedReportUi extends StatelessWidget {
  final Map<String, dynamic>? model;
  const DetailedReportUi({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        titleText: "${model?['name'] ?? ""}",
        automaticallyImplyleading: false,
        onClose: context.pop,
      ),
      body: BlocProvider(create: (context) => DetailedBloc()..add(InitialEvent(model: model)),
        child: BlocListener<DetailedBloc, DetailedState>(listener: (context, state) {
          if (state is LoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            switch(state) {
              case ViewURLState(): Utils.openURL(state.url ?? ""); break;
              case ErrorState(): Toaster.showError(state.message); break;
              case SuccessState(): Toaster.showSuccess(state.message); break;
              case ViewFilterState(): TaskCohortFilterMainPage.show(context, cohortIdList: state.model, onChanged: (value) => context.read<DetailedBloc>().add(FilterCohortEvent(model: value))); break;
            }
          }
        }, child: Column(
          spacing: 10.spMin,
          children: const [
            DetailedReportHeader(),
            DetailedReportBody(),
          ],
        )),
      ),
    );
  }
}
