import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/row_tile.dart';
import 'package:fairpytasker/UI/bouncie/bloc/bouncie_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_bouncie/tasker_bouncie_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'bouncie_listing.dart';
part 'component/bouncie_vehicle_item.dart';

class BouncieMainUi extends StatelessWidget {
  const BouncieMainUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        titleText: "Bouncie",
        onClose: context.pop,
      ),
      body: BlocProvider(create: (context) => BouncieBloc()..add(InitialEvent()),
      child: BlocListener<BouncieBloc, BouncieState>(listener: (context, state) {
        if (state is LoadingState) {
          if (!EasyLoading.isShow) EasyLoading.show();
        } else {
          if (EasyLoading.isShow) EasyLoading.dismiss();
          switch(state) {
            case ErrorState(): Toaster.showError(state.message); break;
            case SuccessState(): Toaster.showSuccess(state.message); break;
            case ViewBouncie(): TaskerBouncieDialog.show(context, state.model); break;
          }
        }
      }, child: const BouncieListing())),
    );
  }
}
