part of 'department_view_main_ui.dart';

class DepartmentListUI extends StatelessWidget {
  const DepartmentListUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentViewBloc, DepartmentViewState>(
        builder: (context, state) => SafeArea(
          minimum: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppC.grey, width: 0.5)
            ),
            child: Padding(
              padding: 10.spMin.padding,
              child: Column(
                spacing: 10.spMin,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                        SuccessButton(
                          icon: Icons.add,
                          text: "Add",
                          onPressed: () =>context.read<DepartmentViewBloc>().add(AddEditEvent()),
                        ),
                        const Spacer(flex: 1),
                      Expanded(
                        flex: 6,
                        child: CompactSearchView(
                          controller: context.read<DepartmentViewBloc>().searchController,
                          onChanged: (value) => context.read<DepartmentViewBloc>().add(SearchEvent(value)),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                      child: (context.watch<DepartmentViewBloc>().filteredResponse.isEmpty && state is! LoadingState)
                      ? const EmptyWidget(withExpand: false)
                          : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppC.grey,
                            width: 0.5,
                          ),
                        ),
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) => const Divider(height: 0.5,),
                            itemCount: context.watch<DepartmentViewBloc>().filteredResponse.length,
                            itemBuilder: (context, index) {
                              var listItems = context.watch<DepartmentViewBloc>().filteredResponse;
                              var item = listItems[index];
                              var currentPage = context.watch<DepartmentViewBloc>().currentIndex;
                              return SafeArea(
                                minimum:10.padding,
                                child:ListTile(
                                  titleAlignment: ListTileTitleAlignment.top,
                                  minVerticalPadding: 0,
                                  contentPadding: 0.padding,
                                  minTileHeight: 0,
                                  dense: true,
                                  leading:  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Utils.getText("${((currentPage != 1) ? (((currentPage - 1) * context.read<DepartmentViewBloc>().itemsPerPage) + index) : index) + 1}",color: AppC.appColor),
                                    ],
                                  ),
                                  title:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Utils.getText(
                                        '${item['name'] ?? ''}',
                                        weight: FontWeight.bold,
                                      ),
                                      Utils.getText(
                                        '${item['users']?['first_name'] ?? ''} ${item['users']['last_name'] ?? ''}',
                                        weight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CompactIconButton(
                                        iconSize: 16.spMin,
                                        icon:Icons.edit_outlined,
                                        backgroundColor: AppC.appColor,
                                        onPressed: () =>context.read<DepartmentViewBloc>().add(AddEditEvent(model: item)),
                                      ),
                                      CompactIconButton(
                                        iconSize: 16.spMin,
                                        icon:Icons.delete_outline,
                                        backgroundColor: AppC.redAccent,
                                        onPressed: (){
                                          AskPermissionDialog.show(context,
                                              title: "Are you sure?",
                                              description: "Do you want to delete this User?",
                                              positiveText: "Yes, delete it!",
                                              negativeText: "Cancel",
                                              isReasonRequired: false,
                                              onPositivePressed: ()=>context.read<DepartmentViewBloc>().add(DeleteEvent(item)));
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                  ),
                  CompactPagination(
                    currentPage: context.watch<DepartmentViewBloc>().currentIndex,
                    totalPages: (context.watch<DepartmentViewBloc>().totalCount / context.watch<DepartmentViewBloc>().itemsPerPage).ceil(),
                    onPageChanged: (value) => context.read<DepartmentViewBloc>().add(PaginationEvent(value)),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
