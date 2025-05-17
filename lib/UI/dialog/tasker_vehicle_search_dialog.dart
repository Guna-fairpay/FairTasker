import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/UI/vehicle_expense_ui.dart';
import 'package:fairpytasker/UI/Vehicle/details/vehicle_details_ui.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/vehicle_history_view_ui.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicle_search_bloc/tasker_vehicle_search_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicle_search_bloc/tasker_vehicle_search_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicle_search_bloc/tasker_vehicle_search_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerVehicleSearchDialog {
  TaskerVehicleSearchDialog._();

  static void show(BuildContext context) async {
    // context.push(const _TaskerVehicleSearchDialogView(), fullscreenDialog: true);
    await showDialog(
        context: context,
        builder: (context) => const _TaskerVehicleSearchDialog(),
        barrierDismissible: true,
        useSafeArea: true);
  }
}

class _TaskerVehicleSearchDialog extends StatelessWidget {
  const _TaskerVehicleSearchDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: 10.padding,
        contentPadding: 6.sp.horizontalPadding.copyWith(bottom: 10.sp),
        titlePadding: EdgeInsets.zero,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
        title: ListTile(
          dense: true,
          title: const Text("Search vehicle"),
          trailing: GestureDetector(
            onTap: context.popDialog,
            child: const Icon(Icons.close_rounded),
          ),
        ),
        alignment: Alignment.topCenter,
      content: BlocProvider(
        create: (_) => TVSBloc()..add(TVSInitialEvent()),
        child: BlocListener<TVSBloc, TVSStates>(
          listener: (context, state) {
            if (state is TVSLoadingState) {
              EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
            }
          },
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [_TaskerVehicleSearchBodyView(), const SizedBox.shrink()],
          ),
        ),
      ),
    );
  }
}

class _TaskerVehicleSearchDialogView extends StatelessWidget {
  const _TaskerVehicleSearchDialogView();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TVSBloc()..add(TVSInitialEvent()),
      child: BlocListener<TVSBloc, TVSStates>(
        listener: (context, state) {
          if (state is TVSLoadingState) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Search vehicle"),
          ),
          body: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [_TaskerVehicleSearchBodyView(), const SizedBox.shrink()],
          ),
        ),
      ),
    );
  }
}

Widget _widget(BuildContext context) {
  return AlertDialog.adaptive(
    alignment: Alignment.topCenter,
    titlePadding: EdgeInsets.zero,
    contentPadding: EdgeInsets.zero,
    shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
    insetPadding: EdgeInsets.symmetric(horizontal: 16.sp)
        .copyWith(top: 70.sp, bottom: 16.sp),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5,
    title: ListTile(
      trailing: GestureDetector(
        child: Icon(Icons.close, color: context.theme.colorScheme.primary),
        onTap: () => Navigator.pop(context),
      ),
    ),
    content: Column(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: [_TaskerVehicleSearchBodyView(), const SizedBox.shrink()],
    ),
  );
}

class _TaskerVehicleSearchBodyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TVSBloc, TVSStates>(
        builder: (context, state) => Flexible(
              child: Container(
                constraints: BoxConstraints(
                    minWidth: double.maxFinite, maxHeight: context.height),
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                ),
                padding: 10.horizontalPadding,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox.shrink(),
                      SearchViewField<Map<String, dynamic>>(
                        controller: context.read<TVSBloc>().searchController,
                        suggestions: context.watch<TVSBloc>().vehicleList,
                        itemAsString: (item) => item['vehicle_name'].toString(),
                        selectedItem: context.watch<TVSBloc>().selectedModel,
                        onSelected: (value) {
                          context
                              .read<TVSBloc>()
                              .add(TVSSelectedEvent(model: value));
                          Utils.dismissKeyboard(context);
                        },
                        showEmpty: false,
                      ),
                      if (context.watch<TVSBloc>().selectedModel?.isNotEmpty ??
                          false)
                        IntrinsicWidth(
                          child: Container(
                            decoration: const BoxDecoration(
                                border: BorderDirectional(
                                    bottom: BorderSide(
                                        width: Num.borderWidthThinField, color: AppC.borderColor))),
                            child: FittedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTabButton(
                                      buttonText: "Vehicle History",
                                      value: 0,
                                      onPressed: (value) => context
                                          .read<TVSBloc>()
                                          .add(TVSSelectPageEvent(page: value)),
                                      selectedValue:
                                          context.watch<TVSBloc>().pageIndex,
                                      icon: (context.watch<TVSBloc>().pageIndex ==
                                              0)
                                          ? Icons.directions_car_filled_rounded
                                          : Icons.directions_car_filled_outlined),
                                  CustomTabButton(
                                      buttonText: "Expenses",
                                      value: 1,
                                      onPressed: (value) => context
                                          .read<TVSBloc>()
                                          .add(TVSSelectPageEvent(page: value)),
                                      selectedValue:
                                          context.watch<TVSBloc>().pageIndex,
                                      icon:
                                          (context.watch<TVSBloc>().pageIndex == 1)
                                              ? Icons.monetization_on_rounded
                                              : Icons.monetization_on_outlined),
                                  CustomTabButton(
                                      buttonText: "Details",
                                      value: 2,
                                      onPressed: (value) => context
                                          .read<TVSBloc>()
                                          .add(TVSSelectPageEvent(page: value)),
                                      selectedValue:
                                          context.watch<TVSBloc>().pageIndex,
                                      icon:
                                          (context.watch<TVSBloc>().pageIndex == 2)
                                              ? Icons.info_rounded
                                              : Icons.info_outlined),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if ((context.watch<TVSBloc>().selectedModel?.isNotEmpty ??
                              false) &&
                          (context.watch<TVSBloc>().pageIndex < 3))
                        SizedBox(
                          width: double.maxFinite,
                          height: context.height * 0.65,
                          child: (context.watch<TVSBloc>().pageIndex == 0)
                              ? VehicleHistoryViewUI(
                                  vin: context
                                      .watch<TVSBloc>()
                                      .selectedModel?['vin'],
                                  vehicleName: context
                                      .watch<TVSBloc>()
                                      .selectedModel?['vehicle_name'],
                                  showHeader: false)
                              : (context.watch<TVSBloc>().pageIndex == 1)
                                  ? EditVehicleExpenseDetailsUI(
                            withInExpand: true,
                                      vin: context
                                          .watch<TVSBloc>()
                                          .selectedModel?['vin'])
                                  : VehicleDetailsUi(
                                      model:
                                          context.watch<TVSBloc>().selectedModel),
                        ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
