part of 'task_component_main_page.dart';

class TaskBasedTable extends StatelessWidget {
  const TaskBasedTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskComponentBloc, TaskComponentState>(
      builder: (context, state) => Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(),
          2: IntrinsicColumnWidth(),
        },
        border: const TableBorder(horizontalInside: BorderSide(width: 0.5, color: AppC.borderColor)),
        children: [
          TableHeaderRow(
              tableDecoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.sp),
                    topRight: Radius.circular(4.sp)),
                color: AppC.appbgColor,),
              backgroundColor: AppC.appbgColor,
              labels: ["Name", "Amount",if (getIt<CommonService>().isAdmin) "Action"]),
          ...?context.watch<TaskComponentBloc>().taskBaseList?.map((e) => TableRow(children: [
            TableRowInkWell(
              child: Padding(
                padding: 10.sp.padding,
                child: Utils.getText(e['task_name'] ?? ''),
              ),
              onTap: () => context.read<TaskComponentBloc>().add(TaskComponentEditEvent(value: e)),
            ),
            TableCell(
                child: Padding(
                  padding: 10.sp.padding,
                  child: Text("\$${e['amount']}"),
                )),
            if (getIt<CommonService>().isAdmin)
              TableCell(
                  child: Padding(
                    padding: 10.sp.padding,
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () => context.read<TaskComponentBloc>().add(TaskComponentEditEvent(value: e)),
                            child: const Icon(
                              Icons.edit_outlined,
                              color: AppC.blue,)
                        ),
                        5.sp.width,
                        GestureDetector(
                            onTap: () => AskPermissionDialog.show(context,
                                title: "Are you sure?",
                                description: "Do you want to delete?",
                                positiveText: "Yes, delete it!",
                                negativeText: "Cancel",
                                isReasonRequired: false,
                                onPositivePressed: () => context.read<TaskComponentBloc>().add(TaskComponentDeleteEvent(value: e))),
                            child: const Icon(Icons.delete_outline_rounded, color: AppC.redAccent)),
                      ],
                    ),
                  )
              ),
          ])).toList(),
        ],
      ),
    );
  }
}
