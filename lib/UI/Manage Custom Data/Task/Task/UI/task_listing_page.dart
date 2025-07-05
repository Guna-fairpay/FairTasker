import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Components/popup_with_icons.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_state.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskListingPage extends StatelessWidget {
  const TaskListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) => Column(
        children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: IntrinsicColumnWidth(),
            },
            border: const TableBorder(horizontalInside: BorderSide(width: 0.5, color: AppC.borderColor)),
            children: [
              TableHeaderRow(
                  tableDecoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.spMin),
                        topRight: Radius.circular(4.spMin)),
                    color: AppC.appbgColor,),
                  backgroundColor: AppC.appbgColor,
                  labels: const ["Name", "Category", "subcategory", '']),
              ...context.watch<TaskBloc>().filteredResponse.map((e) => TableRow(children: [
                TableRowInkWell(
                  child: Padding(
                    padding: 10.spMin.padding,
                    child: Utils.getText(e['task'] ?? ''),
                  ),
                  onTap: () => context.read<TaskBloc>().add(EditTaskEvent(data: e)),
                ),
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: 5.spMin.padding,
                      child: Utils.dropdownBox(
                          'select category',
                          context.watch<TaskBloc>().category,
                              (value) {
                            context.read<TaskBloc>().add(ListCategoryDropDownSelectionEvent(dropDownData: value, listModel: e));
                            Utils.dismissKeyboard(context);
                          },
                          labelKey: "name",
                          initialSelection: (e['category_id'].toString().isNullOrEmpty) ? null : context
                              .watch<TaskBloc>()
                              .category.firstWhereOrNull((element) => element['id'].toString() == e['category_id'].toString()),
                          selectedKey: (e['category_id'].toString().isNullOrEmpty) ? null : context
                              .watch<TaskBloc>()
                              .category.firstWhereOrNull((element) => element['id'].toString() == e['category_id'].toString()),
                          height: 30.spMin),
                    )),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: 5.spMin.padding,
                        child: Utils.dropdownBox(
                            'Select Sub Category',
                            ((e['category_id'] == null) || ((e['category_id'] ?? 0) == 0) )
                                ? [] :
                            List<Map<String, dynamic>>.from(context
                                .watch<TaskBloc>()
                                .category.firstWhereOrNull((element) => element['id'].toString() == e['category_id'].toString())?['sub_categories'] ?? []),
                                (value) {
                              context.read<TaskBloc>().add(ListSubCategoryDropDownSelectionEvent(dropDownData: value, listModel: e));
                              Utils.dismissKeyboard(context);
                            },
                            labelKey: 'name',
                            initialSelection: List<Map<String, dynamic>>.from(context
                                .watch<TaskBloc>()
                                .category.firstWhereOrNull((element) => element['id'].toString() == e['category_id'].toString())?['sub_categories'] ?? []).firstWhereOrNull((element) => element['id'].toString() == e['subcategory_id'].toString()) ?? {},
                            selectedKey: List<Map<String, dynamic>>.from(context
                                .watch<TaskBloc>()
                                .category.firstWhereOrNull((element) => element['id'].toString() == e['category_id'].toString())?['sub_categories'] ?? []).firstWhereOrNull((element) => element['id'].toString() == e['subcategory_id'].toString()) ?? {},
                            height: 30.spMin),
                      )
                  ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child:   InkWell(
                    onTapDown: (TapDownDetails details) {
                      PopupWithIcons.show(context, details,
                          onIcon1Tap: () => context
                              .read<TaskBloc>()
                              .add(EditTaskEvent(data: e)),
                          onIcon2Tap: () {
                            AskPermissionDialog.show(context,
                              title: "Are you sure?",
                              description:
                              "Do you want to delete this identifier?",
                              positiveText: "Yes, delete it!",
                              negativeText: "Cancel",
                              isReasonRequired: false,
                              onPositivePressed: ()=>context.read<TaskBloc>().add(DeleteTaskEvent(data: e)),);
                          });
                    },
                    child: Padding(
                      padding: 5.spMin.padding,
                      child: Icon(
                         Icons.more_horiz,
                        size: 14.spMin,
                        color: AppC.appColor,

                      ),
                    ),
                  ),
                ),
              ])).toList(),
            ],
          ),
          CompactPagination(
            currentPage: context.watch<TaskBloc>().currentIndex,
            totalPages: (context.watch<TaskBloc>().totalCount /
                context.watch<TaskBloc>().itemsPerPage)
                .ceil(),
            onPageChanged: (value) => context
                .read<TaskBloc>()
                .add(TaskPaginationEvent(page: value)),
          ),
        ],
      ),
    );
  }
}
