
import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_event.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_List_Page/Bloc/employees_view_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_List_Page/Bloc/employees_view_event.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_List_Page/Bloc/employees_view_state.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Utilities/utils.dart';

class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesViewBloc, EmployeesViewState>(
        builder: (context, state) => Column(
          children: [
            Row(
              spacing: 10,
              children: [
                SuccessButton(
                  icon: Icons.add,
                    text: "Add",
                    onPressed: () {},
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 6,
                  child: CompactSearchView(
                    controller: context.read<EmployeesViewBloc>().searchController,
                    onChanged: (value) => context.read<EmployeesViewBloc>().add(SearchEmployeesEvent(value)),
                  ),
                )
              ],
            ),
            10.height,
            context.watch<EmployeesViewBloc>().filteredResponse.isEmpty
                ?const EmptyWidget(withExpand: false) : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppC.grey,
                  width: 0.5,
                ),
              ),
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const Divider(
                    height: 0.5,
                  ),
                  itemCount: context.watch<EmployeesViewBloc>().filteredResponse.length,
                  itemBuilder: (context, index) {
                    var item = context.watch<EmployeesViewBloc>().filteredResponse[index];
                    return SafeArea(
                      minimum:10.padding,
                      child:ListTile(
                        titleAlignment: ListTileTitleAlignment.top,
                        minVerticalPadding: 0,
                        contentPadding: 0.padding,
                        // horizontalTitleGap: 0,
                        minTileHeight: 0,
                        dense: true,
                        leading:  Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Utils.getText("${item['index']??''}",color: AppC.appColor),],
                        ),
                        title:Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Utils.getText(
                              '${item['first_name'] ?? ''}'
                                  ' ${item['last_name'] ?? ''}',
                              weight: FontWeight.bold,
                            ),
                            Utils.getText(
                                '${item['email'] ?? ''}',
                                weight: FontWeight.bold,
                                color: AppC.blue),
                            Utils.getText(
                              '${item['phone'] ?? ''}',
                              weight: FontWeight.bold,
                            ),
                            Utils.getText(
                              '${item['departments']?['name'] ?? ''}',
                              weight: FontWeight.bold,
                              color: AppC.subText,
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CompactIconButton(
                              icon:Icons.edit_outlined,
                              backgroundColor: AppC.appColor,
                              onPressed: (){},),
                            CompactIconButton(
                              icon:Icons.delete_outline,
                              backgroundColor: AppC.redAccent,
                              onPressed: (){
                                AskPermissionDialog.show(context,
                                  title: "Are you sure?",
                                  description:
                                  "Do you want to delete this User?",
                                  positiveText: "Yes, delete it!",
                                  negativeText: "Cancel",
                                  isReasonRequired: false,
                                  onPositivePressed: ()=>context.read<EmployeesViewBloc>().add(DeleteEmployeesEvent(data: item)));
                              },),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
            CompactPagination(
              currentPage: context.watch<EmployeesViewBloc>().currentIndex,
              totalPages: (context.watch<EmployeesViewBloc>().totalCount /
                  context.watch<EmployeesViewBloc>().itemsPerPage)
                  .ceil(),
              onPageChanged: (value) => context
                  .read<EmployeesViewBloc>()
                  .add(EmployeesPaginationEvent(page: value)),
            ),
          ],
        ));
  }
}
