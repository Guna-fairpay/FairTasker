import 'package:dropdown_search/dropdown_search.dart';
import 'package:fairpytasker/Component/compact_drop_down.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/focus_node_wrapper.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/Finance/revenue/bloc/revenue_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'revenue_listing_ui.dart';
part 'revenue_header_ui.dart';
part '../component/revenue_list_item.dart';

class RevenueTab extends StatelessWidget {
  const RevenueTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => RevenueBloc()..add(InitialEvent()),
    child: BlocListener<RevenueBloc, RevenueState>(listener: (context, state) {
      switch(state) {
        case ErrorState(): Toaster.showError(state.message); break;
      }
    }, child: SafeArea(
      minimum: 10.spMin.padding,
      child: const Column(
        children: [
          RevenueHeader(),
          RevenueListing(),
        ],
      ),
    )),);
  }
}
