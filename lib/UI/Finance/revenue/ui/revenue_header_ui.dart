part of 'revenue_main_ui.dart';

class RevenueHeader extends StatelessWidget {
  const RevenueHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RevenueBloc, RevenueState>(
        builder: (context, state) => Column(
              spacing: 10.spMin,
              children: [
                DateRangePicker(
                    onDateRangeSelected: (value) => context
                        .read<RevenueBloc>()
                        .add(DateRangeEvent(selectedDateRange: value)),
                    selectedDateRange:
                        context.watch<RevenueBloc>().selectedDateRange,
                    splitter: "to"),
                DropdownSearch<Map<String, dynamic>>.multiSelection(
                  items: getIt<CommonService>().cohortsList,
                  itemAsString: (item) => item['cohort'] ?? "",
                  onChanged: (value) => context.read<RevenueBloc>().add(CohortEvent(value)),
                  selectedItems: context.watch<RevenueBloc>().selectedCohorts,
                  dropdownBuilder: (context, selectedItems) => CompactText(
                    selectedItems.length == 1 ? (selectedItems.firstOrNull?['cohort'] ?? "") : "${selectedItems.length} Selected",
                  ),
                  popupProps: const PopupPropsMultiSelection.menu(
                    showSearchBox: true,
                    listViewProps: ListViewProps(
                      shrinkWrap: true,
                    ),
                    menuProps: MenuProps(

                    ),
                    searchFieldProps: TextFieldProps(
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder()
                      )
                    )
                  ),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      isDense: true,
                      constraints: BoxConstraints(),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppC.borderColor, width: Num.borderWidthButton))
                    )
                  ),
                ),
                CompactSearchView(
                  controller: context.read<RevenueBloc>().searchController,
                  onChanged: (value) => context.read<RevenueBloc>().add(SearchEvent(value)),
                ),
                const Divider(
                    thickness: Num.borderWidthButton, color: AppC.borderColor)
              ],
            ));
  }
}
