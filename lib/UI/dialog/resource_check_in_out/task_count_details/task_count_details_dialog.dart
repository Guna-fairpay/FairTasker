import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/UI/dialog/resource_check_in_out/task_count_details/bloc/task_count_details_bloc.dart';
import 'package:fairpytasker/UI/dialog/resource_check_in_out/task_count_details/component/task_count_details_row.dart';
import 'package:fairpytasker/UI/dialog/show_notes_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart' show DateRange;
import 'package:fairpytasker/Component/compact_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskCountDetailsDialog {
  TaskCountDetailsDialog._();

  static void show(BuildContext context, {required Map<String, dynamic>? model, required DateRange? dateRange}) async {
    await showDialog(context: context, builder: (context) => _TaskCountDetailsView(model: model, dateRange: dateRange), barrierDismissible: false);
  }
}

class _TaskCountDetailsView extends StatelessWidget {
  final Map<String, dynamic>? model;
  final DateRange? dateRange;
  const _TaskCountDetailsView({super.key, this.dateRange, this.model});

  @override
  Widget build(BuildContext context) {
    return CompactAlertDialog(
      titleText: model?['name'] ?? "",
      titleFontWeight: FontWeight.bold,
      content: BlocProvider(create: (context) => TaskCountDetailsBloc()..add(InitialEvent(model: model, dateRange: dateRange)),
        child: BlocListener<TaskCountDetailsBloc, TaskCountDetailsState>(listener: (context, state) {
          if (state is LoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            switch(state) {
              case ErrorState(): Toaster.showError(state.message); break;
              case SuccessState(): Toaster.showSuccess(state.message); break;
              case ViewNotesCommentsState(): NotesDialog.show(context, message: state.model, barrierDismissible: false);  break;
            }
          }
        },
        child: Padding(
          padding: 10.sp.padding,
          child: Column(
            spacing: 10.sp,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dateRange.toFormat(), style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
              const _TaskCountDetailsContentView(),
            ],
          ),
        )),
      ),
    );
  }
}

class _TaskCountDetailsContentView extends StatelessWidget {
  const _TaskCountDetailsContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCountDetailsBloc, TaskCountDetailsState>(builder: (context, state) => Flexible(
      child: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: const TableBorder(horizontalInside: BorderSide(width: Num.borderWidthThinField, color: AppC.fieldBase)),
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
            2: FlexColumnWidth(),
            3: IntrinsicColumnWidth(),
          },
          children: [
            const TableHeaderRow(labels: ["Date", "Total", "Reason", "Comments"], firstTextAlign: TextAlign.start, textAlign: TextAlign.center),
            ...context.watch<TaskCountDetailsBloc>().list?.map((e) => TaskCountDetailsRow(model: e, onViewNotes: (value) => context.read<TaskCountDetailsBloc>().add(ViewNotesCommentsEvent(value)))).toList() ?? []
          ],
        ),
      ),
    ));
  }
}

