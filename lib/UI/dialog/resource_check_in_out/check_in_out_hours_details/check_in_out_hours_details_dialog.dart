import 'package:fairpytasker/UI/dialog/resource_check_in_out/check_in_out_hours_details/bloc/hours_details_bloc.dart';
import 'package:fairpytasker/UI/dialog/resource_check_in_out/check_in_out_hours_details/component/check_in_out_row.dart';
import 'package:fairpytasker/UI/resource/detailed_report/detailed_report_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart' show DateRange;
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/Component/compact_alert_dialog.dart';
import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class CheckInHoursDialog {
  CheckInHoursDialog._();

  static show(BuildContext context, {required Map<String, dynamic>? model, DateRange? dateRange}) async {
    await showDialog(context: context, builder: (context) => _CheckInOutHoursDetailsMain(model: model, dateRange: dateRange), barrierDismissible: false);
  }
}

class _CheckInOutHoursDetailsMain extends StatelessWidget {
  final Map<String, dynamic>? model;
  final DateRange? dateRange;
  const _CheckInOutHoursDetailsMain({required this.model, this.dateRange});

  @override
  Widget build(BuildContext context) {
    return CompactAlertDialog(
      titleText: model?['name'] ?? "",
      titleFontWeight: FontWeight.bold,
      content: BlocProvider(create: (context) => HourDetailsBloc()..add(InitialEvent(model: model, dateRange: dateRange)),
        child: BlocListener<HourDetailsBloc, HourDetailsState>(
          listener: (context, state) {
            if (state is LoadingState) {
              if (!EasyLoading.isShow) EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              switch(state) {
                case ErrorState(): Toaster.showError(state.message); break;
                case SuccessState(): Toaster.showSuccess(state.message); break;
                case ViewResourceDetailsState(): context.push(DetailedReportUi(model: state.model), fullscreenDialog: true); break;
              }
            }
          },
          child: Padding(
            padding: 10.spMin.padding,
            child: Column(
              spacing: 10.spMin,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateRange.toFormat(), style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                const _CheckInOutHoursDetailsTable()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckInOutHoursDetailsTable extends StatelessWidget {
  const _CheckInOutHoursDetailsTable();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HourDetailsBloc, HourDetailsState>(builder: (context, state) => Flexible(
      child: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(horizontalInside: BorderSide(width: Num.borderWidthThinField, color: AppC.fieldBase)),
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
            3: IntrinsicColumnWidth(),
            4: FlexColumnWidth(),
          },
          children: [
            const TableHeaderRow(labels: ["Date", "In", "Out", "Total", "#"], firstTextAlign: TextAlign.start, textAlign: TextAlign.center),
            ...context.watch<HourDetailsBloc>().tasks?.map((e) => CheckInOutRow(model: e, onTask: () => context.read<HourDetailsBloc>().add(ViewResourceDetailsEvent(model: e)))).toList() ?? []
          ],
        ),
      ),
    ));
  }
}

