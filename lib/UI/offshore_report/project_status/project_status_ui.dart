import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/custom_segmented_button/segment_button.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/Component/label_view.dart';
import 'package:fairpytasker/Component/limited_html_view.dart';
import 'package:fairpytasker/Component/row_tile.dart';
import 'package:fairpytasker/Component/simple_popup_menu.dart';
import 'package:fairpytasker/UI/offshore_report/componet/card.dart';
import 'package:fairpytasker/UI/offshore_report/project_status/bloc/project_status_bloc.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

part 'project_status_header.dart';

part 'project_status_list.dart';

part 'project_status_list_item.dart';

class OffShoreProjectStatus extends StatelessWidget {
  const OffShoreProjectStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ProjectStatusBloc()..add(InitialEvent()),
        child: BlocListener<ProjectStatusBloc, ProjectStatusStates>(
            listener: (context, state) {
              if (state is LoadingState) {
                if (!EasyLoading.isShow) EasyLoading.show();
              } else {
                if (EasyLoading.isShow) EasyLoading.dismiss();
                switch(state) {
                  case ErrorState(): Toaster.showError(state.message); break;
                  case SuccessState(): Toaster.showSuccess(state.message); break;
                }
              }
            },
            child: Column(
              spacing: 10.spMin,
              children: const [
                ProjectStatusHeader(),
                ProjectStatusList(),
              ],
            )));
  }
}
