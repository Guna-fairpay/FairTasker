import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/dialog/tasker_bouncie/bloc/tasker_bouncie_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_bouncie/bloc/tasker_bouncie_event.dart';
import 'package:fairpytasker/UI/dialog/tasker_bouncie/bloc/tasker_bouncie_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerBouncieDialog {
  TaskerBouncieDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model,
      {Key? key}) async {
    await showDialog(
        context: context,
        builder: (context) => _TaskerBouncieDialogView(key: key, model: model));
  }
}

class _TaskerBouncieDialogView extends StatefulWidget {
  final Map<String, dynamic>? model;

  const _TaskerBouncieDialogView({super.key, this.model});

  @override
  State<_TaskerBouncieDialogView> createState() => _TaskerBouncieDialogViewState();
}

class _TaskerBouncieDialogViewState extends State<_TaskerBouncieDialogView> {

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: 16.sp.padding,
      contentPadding: 16.sp.horizontalPadding.copyWith(bottom: 16.sp),
      titlePadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      title: ListTile(
        // dense: true,
        title: Text("${widget.model?['vehicle_name'] ?? widget.model?['display']?['vehicle_name']}"),
        titleTextStyle:
            context.textTheme.titleMedium?.copyWith(color: AppC.appColor),
        trailing: GestureDetector(
          onTap: context.popDialog,
          child: const Icon(Icons.close_rounded),
        ),
      ),
      alignment: Alignment.topCenter,
      content: BlocProvider(
        create: (context) =>
            TaskerBouncieBloc()..add(TaskerBouncieInitialEvent(widget.model)),
        child: BlocListener<TaskerBouncieBloc, TaskerBouncieState>(
          listener: (context, state) {
            if (state is TaskerBouncieLoadingState) {
              if (!EasyLoading.isShow) EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
            }
          },
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              spacing: 16.sp,
              mainAxisSize: MainAxisSize.min,
              children: const [
                _TaskerBouncieErrorWidget(),
                _TaskerBouncieMapWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskerBouncieErrorWidget extends StatelessWidget {
  const _TaskerBouncieErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskerBouncieBloc, TaskerBouncieState>(
        builder: (context, state) => (context
                .watch<TaskerBouncieBloc>()
                .displayErrorMsg
                .toString()
                .isNotNullOrEmpty)
            ? Column(
                spacing: 16.sp,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: 16.sp.horizontalPadding,
                    decoration: BoxDecoration(
                        color: AppC.bouncieBgColor,
                        borderRadius: BorderRadius.circular(Num.borderRadius),
                        border: Border.all(color: AppC.bouncieBgBorderColor)),
                    padding: 10.sp.padding,
                    child: Text("${context.watch<TaskerBouncieBloc>().displayErrorMsg ?? ""}",
                        style: context.textTheme.labelLarge
                            ?.copyWith(color: AppC.bouncieFontColor)),
                  ),
                  const SuccessButton(
                    text: "Login Bouncie",
                    backgroundColor: AppC.bouncieButtonColor,
                  )
                ],
              )
            : const SizedBox.shrink());
  }
}

class _TaskerBouncieMapWidget extends StatelessWidget {
  const _TaskerBouncieMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskerBouncieBloc, TaskerBouncieState>(
      builder: (context, state) => (context.watch<TaskerBouncieBloc>().hasData) ? Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              height: context.height * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Num.borderRadiusLarge)
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: context.watch<TaskerBouncieBloc>().latLng,
                  initialZoom: 18,
                ),
                mapController: MapController(),
                children: [
                  TileLayer( // Bring your own tiles
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
                    userAgentPackageName: 'com.fairpytasker.fairpytasker', // Add your app identifier
                    // And many more recommended properties!
                  ),
                  MarkerLayer(
                    rotate: true,
                    markers: [
                      Marker(
                        point: context.watch<TaskerBouncieBloc>().latLng,
                        alignment: Alignment.center,
                        child: Icon(Icons.location_on_rounded, color: AppC.redAccent, size: 26.sp,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (context.watch<TaskerBouncieBloc>().address.toString().isNotNullOrEmpty)
          Text.rich(TextSpan(
              children: [
                WidgetSpan(child: Icon(Icons.location_on_rounded, color: AppC.appColor, size: 16.sp,)),
                TextSpan(text: "${context.watch<TaskerBouncieBloc>().address ?? ""}")
              ]
          ), textAlign: TextAlign.start, softWrap: true),
          Text.rich(TextSpan(
            text: "Last Updated:\t",
            children: [
              TextSpan(text: "${context.watch<TaskerBouncieBloc>().lastUpdated ?? ""}")
            ]
          ), style: context.textTheme.labelMedium?.copyWith(color: AppC.redAccent)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                spacing: 5.sp,
                children: [
                  const Icon(Icons.local_gas_station_rounded),
                  Text("${context.watch<TaskerBouncieBloc>().fuelLevel ?? ""}", style: context.textTheme.labelLarge?.copyWith(color: AppC.green, fontWeight: FontWeight.bold))
                ],
              ),
              Column(
                spacing: 5.sp,
                children: [
                  const Icon(Icons.battery_3_bar_rounded),
                  Text("${context.watch<TaskerBouncieBloc>().batteryLevel ?? ""}", style: context.textTheme.labelLarge?.copyWith(color: AppC.redAccent, fontWeight: FontWeight.bold))
                ],
              ),
            ],
          )
        ],
      ) : const SizedBox.shrink(),
    );
  }
}

