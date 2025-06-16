part of 'permission_listing_main_ui.dart';

class PermissionDataListingUI extends StatelessWidget {
  const PermissionDataListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionListingBloc, PermissionListingState>(
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
                      onPressed: () =>context.read<PermissionListingBloc>().add(AddEditEvent()),
                    ),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 6,
                      child: CompactSearchView(
                        controller: context.read<PermissionListingBloc>().searchController,
                        onChanged: (value) => context.read<PermissionListingBloc>().add(SearchEvent(value)),
                      ),
                    )
                  ],
                ),
                Expanded(
                    child: (context.watch<PermissionListingBloc>().filteredResponse.isEmpty && state is! LoadingState)
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
                          itemCount: context.watch<PermissionListingBloc>().filteredResponse.length,
                          itemBuilder: (context, index) {
                            var listItems = context.watch<PermissionListingBloc>().filteredResponse;
                            var item = listItems[index];
                            var currentPage = context.watch<PermissionListingBloc>().currentIndex;
                            return SafeArea(
                              minimum:10.padding,
                              child:ListTile(
                                titleAlignment: ListTileTitleAlignment.center,
                                minVerticalPadding: 5,
                                contentPadding: 0.padding,
                                minTileHeight: 0,
                                dense: true,
                                leading:  Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Utils.getText("${((currentPage != 1) ? (((currentPage - 1) * context.read<PermissionListingBloc>().itemsPerPage) + index) : index) + 1}",color: AppC.appColor),
                                  ],
                                ),
                                title:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Utils.getText(
                                      '${item['name'] ?? ''}',
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
                                      onPressed: () =>context.read<PermissionListingBloc>().add(AddEditEvent(data: item)),
                                    ),
                                    CompactIconButton(
                                      iconSize: 16.spMin,
                                      icon:Icons.delete_outline,
                                      backgroundColor: AppC.redAccent,
                                      onPressed: (){
                                        AskPermissionDialog.show(context,
                                            title: "Are you sure?",
                                            description: "Do you want to delete this Permission?",
                                            positiveText: "Yes, delete it!",
                                            negativeText: "Cancel",
                                            isReasonRequired: false,
                                            onPositivePressed: ()=>context.read<PermissionListingBloc>().add(DeleteEvent(item)));
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
                  currentPage: context.watch<PermissionListingBloc>().currentIndex,
                  totalPages: (context.watch<PermissionListingBloc>().totalCount / context.watch<PermissionListingBloc>().itemsPerPage).ceil(),
                  onPageChanged: (value) => context.read<PermissionListingBloc>().add(PaginationEvent(value)),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
