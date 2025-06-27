part of '../reports_view.dart';

class Tolls extends StatelessWidget {
  const Tolls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsBloc, ReportState>(builder: (context, state) => AnimatedContainer(
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
        )));
  }
}
