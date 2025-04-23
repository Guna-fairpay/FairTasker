import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Components/popup_with_icons.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_state.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskListingPage extends StatelessWidget {
  const TaskListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.r),
                      topRight: Radius.circular(5.r),
                    )),
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Utils.getText('Name', weight: FontWeight.bold)),
                    Expanded(
                      child: Utils.getText('Category', weight: FontWeight.bold),
                    ),
                    Expanded(
                      child:
                          Utils.getText('subcategory', weight: FontWeight.bold),
                    ),
                    Utils.getText('!!!!',
                        weight: FontWeight.bold, color: AppC.trans),
                  ],
                ),
              ),
            ),
            context.watch<TaskBloc>().filteredResponse.isEmpty
                ? Utils.getText('No data found ', weight: FontWeight.bold)
                : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(
                      height: 0.5,
                    ),
                itemCount: context.watch<TaskBloc>().filteredResponse.length,
                itemBuilder: (context, index) {
                  var item = context.watch<TaskBloc>().filteredResponse[index];
                  return SafeArea(
                    minimum:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 1.w),
                    child: Row(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: InkWell(
                                onTap: () => context
                                    .read<TaskBloc>()
                                    .add(EditTaskEvent(data: item)),
                                child: Utils.getText("${item['task']}",
                                    size: 12.sp, overFlow: TextOverflow.visible),
                              )),
                          Expanded(
                              flex: 1,
                              child: Utils.dropdownBox(
                                  'select category',
                                  context.watch<TaskBloc>().category,
                                  (value) => context.read<TaskBloc>().add(
                                      ListCategoryDropDownSelectionEvent(dropDownData: value, listModel: item)),
                                  labelKey: "name",
                                  initialSelection: (item['category_id'].toString().isNullOrEmpty) ? null : context
                                      .watch<TaskBloc>()
                                      .category.firstWhereOrNull((element) => element['id'].toString() == item['category_id'].toString()),
                                  selectedKey: (item['category_id'].toString().isNullOrEmpty) ? null : context
                                      .watch<TaskBloc>()
                                      .category.firstWhereOrNull((element) => element['id'].toString() == item['category_id'].toString()),
                                  height: 30.sp)),
                          Expanded(
                              flex: 1,
                              child: Utils.dropdownBox(
                                  'Select Sub Category',
                                  ((item['category_id'] == null) || ((item['category_id'] ?? 0) == 0) )
                                  ? [] :
                                  List<Map<String, dynamic>>.from(context
                                      .watch<TaskBloc>()
                                      .category.firstWhereOrNull((element) => element['id'].toString() == item['category_id'].toString())?['sub_categories'] ?? []),
                                  (value) => context.read<TaskBloc>().add(
                                      ListSubCategoryDropDownSelectionEvent(
                                          dropDownData: value, listModel: item)),
                                  labelKey: 'name',
                                  initialSelection: List<Map<String, dynamic>>.from(context
                                      .watch<TaskBloc>()
                                      .category.firstWhereOrNull((element) => element['id'].toString() == item['category_id'].toString())?['sub_categories'] ?? [])?.firstWhereOrNull((element) => element['id'].toString() == item['subcategory_id'].toString()) ?? {},
                                  selectedKey: List<Map<String, dynamic>>.from(context
                                      .watch<TaskBloc>()
                                      .category.firstWhereOrNull((element) => element['id'].toString() == item['category_id'].toString())?['sub_categories'] ?? [])?.firstWhereOrNull((element) => element['id'].toString() == item['subcategory_id'].toString()) ?? {},
                                  height: 30.sp)),
                          GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              PopupWithIcons.show(context, details,
                                  onEditTap: () => context
                                      .read<TaskBloc>()
                                      .add(EditTaskEvent(data: item)),
                                  onDeleteTap: () {
                                    AskPermissionDialog.show(context,
                                        title: "Are you sure?",
                                        description:
                                            "Do you want to delete this identifier?",
                                        positiveText: "Yes, delete it!",
                                        negativeText: "Cancel",
                                        isReasonRequired: false,
                                        onPositivePressed: ()=>context.read<TaskBloc>().add(DeleteTaskEvent(data: item)),);
                                  });
                            },
                            child: Icon(
                              Icons.more_horiz,
                              color: AppC.appColor,
                              size: 14.sp,
                            ),
                          ),
                        ]),
                  );
                }),
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
        );
      },
    );
  }
}
