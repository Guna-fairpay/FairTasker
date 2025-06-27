part of '../reports_view.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsBloc, ReportState>(builder: (context, state) => AnimatedContainer(
        duration: Durations.long1,
        child: (state is ReportsGeneratingState)
            ? Padding(
          padding: 16.spMin.padding,
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
        )));
  }

  Widget get _divider => const Divider(color: AppC.white, height: 1);
}
