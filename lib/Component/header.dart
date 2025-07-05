import 'package:fairpytasker/Bloc/header_bloc.dart';
import 'package:fairpytasker/State/header_states.dart';
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
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:r_icon_pro/r_icon_pro.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../Utilities/str.dart';
import 'bottom_nav_for_task.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HeaderBloc(),
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
            spacing: 10.w,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: Scaffold.of(context).openDrawer,
                child: SvgPicture.asset(
                  Assets.hamburgerIcon,
                  width: 24.spMin,
                  height: 24.spMin,
                  fit: BoxFit.fitHeight,
                  theme: const SvgTheme(currentColor: AppC.appColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: GestureDetector(
                  onTap: () => context.pushAndRemoveUntil(const BottomNavigationForTaskView(selectedIndex: 0)),
                  child: Image.asset(
                    Assets.favicon,
                    width: 24.spMin,
                    height: 24.spMin,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              if (getIt<CommonService>().hasReport)
                IconButton(onPressed: () => context.push(const LogUi(), fullscreenDialog: true), icon: Icon(RIcon.Document_Add, color: AppC.grey, size: 24.spMin,)),
              const Spacer(),
              if (kDebugMode)
              Badge.count(count: 0, smallSize: 8.spMin, child: Icon(RIcon.Letter,color: AppC.appColor, size: 22.spMin)),
              BlocSelector<HeaderBloc, HeaderState, HeaderState>(
                selector: (state) => state,
                builder: (context, state) => GestureDetector(
                  onTap: () => context.push(const ResourceCheckInOutUi(), fullscreenDialog: true),
                  // onTap: () => context.push(WorkHoursViewUI(), fullscreenDialog: true),
                  child: Container(
                    decoration: Utils.getBoxDecoration(),
                    padding: EdgeInsets.symmetric(horizontal: 5.spMin, vertical: 2.spMin),
                    child: Utils.getText(' ${context.watch<HeaderBloc>().checkInOutCount ?? "0/0"} ', weight: FontWeight.bold),
                  ),
                ),
              ),
              if (getIt<CommonService>().showBranchSelection)
              GestureDetector(
                onTapDown: (details) => BranchPopupMenu.show(context, offset: details.globalPosition, onChanged: (value) => Console.of.warning(value)),
                child: ValueListenableBuilder(valueListenable: getIt<CommonService>().updateBranch, builder: (context, value, child) => Utils.getText((Session.of.getString(Str.branchNamePrefText)?[0] ?? "D"),
                  style: context.textTheme.titleLarge?.copyWith(fontSize: 16.h, fontWeight: FontWeight.w900, color: AppC.appColor),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
