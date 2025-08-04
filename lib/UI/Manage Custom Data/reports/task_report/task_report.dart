part of '../reports_view.dart';

class TaskReport extends StatelessWidget {
  const TaskReport({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsBloc, ReportState>(builder: (context, state) => Column(
      children: [
        ListTile(leading: Utils.getText("Task Report", weight: FontWeight.bold, size: 18),contentPadding: EdgeInsets.zero),
        AnimatedContainer(
          duration: Durations.long1,
          child: (state is ReportsDownloadingState)
              ? Padding(
            padding: 16.spMin.padding,
            child: Center(
                child: Column(
                  spacing: 10.spMin,
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
            spacing: 10.spMin,
            children: [
              Expanded(child: DateRangePicker(onDateRangeSelected: (value) => context.read<ReportsBloc>().add(DateRangeEvent(value)), splitter: "to", selectedDateRange: context.watch<ReportsBloc>().dateRange)),
              IconButton(onPressed: () => context.read<ReportsBloc>().add(TaskExportEvent()), icon: const Icon(Icons.download_rounded), color: AppC.appColor)
            ],
          ),
        ),
      ],
    ));
  }
}
