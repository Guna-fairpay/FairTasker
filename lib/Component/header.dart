import 'package:fairpytasker/Bloc/header_bloc.dart';
import 'package:fairpytasker/Event/header_events.dart';
import 'package:fairpytasker/State/header_states.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/resource_ui.dart';
import 'package:fairpytasker/UI/dialog/popup/branch_popup.dart';
import 'package:fairpytasker/UI/log/log_ui.dart';
import 'package:fairpytasker/UI/resource/resource_main/resource_check_in_out_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Utilities/str.dart';
import 'bottom_nav_for_task.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HeaderBloc()..add(HeaderInitialEvent()),
      child: BlocListener<HeaderBloc, HeaderState>(
        listener: (context, state) {
          if (state is HeaderLoadingState) {
          } else {
            if (state is HeaderErrorState) {
              Console.of.error(state.message);
            }
          }
        },
        child: AppBar(
          elevation: 0,
          leadingWidth: 0,
          backgroundColor: AppC.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: Scaffold.of(context).openDrawer,
                child: SvgPicture.asset(
                  Assets.hamburgerIcon,
                  color: AppC().base,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: GestureDetector(
                  onTap: () => context.pushAndRemoveUntil(const BottomNavigationForTaskView(selectedIndex: 0)),
                  child: Image.asset(
                    Assets.favicon,
                    width: 24.sp,
                    height: 24.sp,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              if (getIt<CommonService>().isAdmin)
                IconButton(onPressed: () => context.push(const LogUi(), fullscreenDialog: true), icon: const Icon(Icons.receipt_long_rounded, color: AppC.grey)),
              const Spacer(),
              if (kDebugMode)
              Badge.count(count: 0, child: const Icon(Icons.email_rounded,color: AppC.appColor)),
              BlocSelector<HeaderBloc, HeaderState, HeaderState>(
                selector: (state) => state,
                builder: (context, state) => GestureDetector(
                  onTap: () => context.push(const ResourceCheckInOutUi(), fullscreenDialog: true),
                  // onTap: () => context.push(WorkHoursViewUI(), fullscreenDialog: true),
                  child: Container(
                    decoration: Utils.getBoxDecoration(),
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Utils.getText(' ${context.watch<HeaderBloc>().checkInCount}/${context.watch<HeaderBloc>().checkOutCount} '),
                  ),
                ),
              ),
              if (kDebugMode)
              BlocSelector<HeaderBloc, HeaderState, HeaderState>(
                selector: (state) => state,
                builder: (context, state) => GestureDetector(
                  // onTap: () => context.push(const ResourceCheckInOutUi(), fullscreenDialog: true),
                  onTap: () => context.push(WorkHoursViewUI(), fullscreenDialog: true),
                  child: Container(
                    decoration: Utils.getBoxDecoration(bgColor: Colors.orange),
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Utils.getText(' ${context.watch<HeaderBloc>().checkInCount}/${context.watch<HeaderBloc>().checkOutCount} '),
                  ),
                ),
              ),
              if (getIt<CommonService>().showBranchSelection)
              GestureDetector(
                onTapDown: (details) => BranchPopupMenu.show(context, offset: details.globalPosition, onChanged: (value) => Console.of.warning(value)),
                child: ValueListenableBuilder(valueListenable: getIt<CommonService>().updateBranch, builder: (context, value, child) => Utils.getText((Session.of.getString(Str.branchNamePrefText)?[0] ?? "D"),
                  style: context.textTheme.titleLarge?.copyWith(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppC.appColor),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
