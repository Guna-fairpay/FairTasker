part of 'revenue_main_ui.dart';

class RevenueHeader extends StatelessWidget {
  const RevenueHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var border = const OutlineInputBorder(borderSide: BorderSide(color: AppC.borderColor, width: Num.borderWidthButton));
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
                MultiSelectDropdown(list: getIt<CommonService>().cohortsList,
                    initiallySelected: context.watch<RevenueBloc>().selectedCohorts,
                    includeSelectAll: true,
                    includeSearch: true,
                    padding: EdgeInsets.symmetric(horizontal: 10.spMin, vertical: 5.spMin),
                    inputDecoration: InputDecoration(
                      isDense: true,
                      contentPadding: 10.spMin.padding,
                      enabledBorder: border,
                      border: border,
                      hintStyle: context.textTheme.labelMedium?.copyWith(color: Colors.black87),
                      hintText: "Search..."
                    ),
                    checkColor: Colors.white,
                    fillColor: WidgetStateColor.resolveWith((states) => (states.contains(WidgetState.selected)) ? AppC.appColor : AppC.trans),
                    boxDecoration: BoxDecoration(
                      border: Border.all(color: AppC.borderColor, width: Num.borderWidthButton),
                      borderRadius: BorderRadius.circular(5.spMin)),
                    isLarge: true,
                    checkboxFillColor: AppC.appColor,
                    splashColor: AppC.trans,
                    itemAsString: (item) => item?['cohort'] ?? "",
                    onChange: (value) => context.read<RevenueBloc>().add(CohortEvent(value))),
                CompactSearchView(
                  controller: context.read<RevenueBloc>().searchController,
                  onChanged: (value) => context.read<RevenueBloc>().add(SearchEvent(value)),
                ),
                if (context.watch<RevenueBloc>().filteredApiResponse.isNotEmpty && (state is! LoadingState))
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: CompactText(" Total Revenue: \$${context.watch<RevenueBloc>().totalAmount}", fontWeight: FontWeight.bold, color: AppC.appColor),
                ),
                const Divider(
                    thickness: Num.borderWidthButton, color: AppC.borderColor)
              ],
            ));
  }
}
