import 'package:fairpytasker/Component/compact_file_picker.dart';
import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportsViewBody extends StatelessWidget {
  const ReportsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsBloc, ReportState>(builder: (context, state) {
      return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            AnimatedContainer(
                duration: Durations.long1,
                child: (state is ReportsGeneratingState)
                    ? Padding(
                        padding: 16.sp.padding,
                        child: Center(
                            child: Column(
                          spacing: 10.sp,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CustomLoading(),
                            Text("Report Generating...")
                          ],
                        )),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFeaf0fa),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            if (!getIt<CommonService>().hideReportItems)
                              ...[
                                ListTile(
                                  title: const Text("Maintenance Check List"),
                                  trailing: GestureDetector(
                                    onTap: () => context
                                        .read<ReportsBloc>()
                                        .add(ReportMaintenanceEvent()),
                                    child: Icon(
                                        (context
                                            .watch<ReportsBloc>()
                                            .maintenanceFile
                                            .isNullOrEmpty)
                                            ? Icons.download_rounded
                                            : Icons.file_open_rounded,
                                        color: AppC.appColor),
                                  ),
                                ),
                                _divider,
                                ListTile(
                                  title: const Text("Vehicle Odometer Summary"),
                                  trailing: GestureDetector(
                                    onTap: () => context
                                        .read<ReportsBloc>()
                                        .add(ReportVehicleEvent()),
                                    child: Icon(
                                        (context
                                            .watch<ReportsBloc>()
                                            .vehicleFile
                                            .isNullOrEmpty)
                                            ? Icons.download_rounded
                                            : Icons.file_open_rounded,
                                        color: AppC.appColor),
                                  ),
                                ),
                                _divider,
                                ListTile(
                                  title: const Text("Earnings Summary"),
                                  trailing: GestureDetector(
                                    onTap: () => context
                                        .read<ReportsBloc>()
                                        .add(ReportEarningEvent()),
                                    child: Icon(
                                        (context
                                            .watch<ReportsBloc>()
                                            .earningFile
                                            .isNullOrEmpty)
                                            ? Icons.download_rounded
                                            : Icons.file_open_rounded,
                                        color: AppC.appColor),
                                  ),
                                ),
                                _divider,
                              ],
                            ListTile(
                              title: const Text("Vehicle Inventory Data"),
                              trailing: GestureDetector(
                                onTap: () => context
                                    .read<ReportsBloc>()
                                    .add(ReportVehicleInventoryEvent()),
                                child: Icon(
                                    (context
                                            .watch<ReportsBloc>()
                                            .vehicleInventoryFile
                                            .isNullOrEmpty)
                                        ? Icons.download_rounded
                                        : Icons.file_open_rounded,
                                    color: AppC.appColor),
                              ),
                            )
                          ],
                        ),
                      )),
            AnimatedContainer(
                duration: Durations.long1,
                child: Column(
                  children: [
                    ListTile(
                      leading: Utils.getText("Tolls",
                          weight: FontWeight.bold, size: 18),
                      contentPadding: EdgeInsets.zero,
                    ),
                    AnimatedContainer(
                      duration: Durations.long1,
                      child: (state is ReportsUploadingState)
                          ? Padding(
                              padding: 16.sp.padding,
                              child: Center(
                                  child: Column(
                                spacing: 10.sp,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  CustomLoading(),
                                  Text("Downloading...")
                                ],
                              )),
                            )
                          : Row(
                              children: [
                                Expanded(
                                    child: CompactFilePicker(
                                  controller: context
                                      .read<ReportsBloc>()
                                      .tollFileController,
                                  onPressed: () => context
                                      .read<ReportsBloc>()
                                      .add(ReportTollsEvent()),
                                )),
                                IconButton(
                                  icon: const Icon(Icons.download_rounded,
                                      color: AppC.appColor),
                                  onPressed: () => context
                                      .read<ReportsBloc>()
                                      .add(UploadFileEvent()),
                                ),
                              ],
                            ),
                    ),
                  ],
                )),
          ]);
    });
  }

  Widget get _divider => const Divider(color: AppC.white, height: 1);
}
