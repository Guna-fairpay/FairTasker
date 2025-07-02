import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/UI/vehicle_expense_details_list_item.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/component/category_filter/ui/expense_filter_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleExpenseListingPageUI extends StatelessWidget {
  final bool withInExpand;
  const VehicleExpenseListingPageUI({super.key, this.withInExpand = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseDetailsBloc, ExpenseDetailsState>(
      builder: (context, state) => SafeArea(
        minimum: 10.padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10.spMin,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: CompactSearchView(
                    controller: context.read<ExpenseDetailsBloc>().searchController,
                    onChanged: (value) => context
                        .read<ExpenseDetailsBloc>()
                        .add(SearchExpenseEvent(value)),
                  ),
                ),
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    ExpenseFilterDialog.show(
                       context:  context,
                       details: details,
                       model:context.read<ExpenseDetailsBloc>().expenseDetails,
                      idList: context.read<ExpenseDetailsBloc>().idList,
                      onChanged: (value)=> context.read<ExpenseDetailsBloc>().add(FilterCategoryEvent(value)),
                    );
                    },
                    child: const Icon(Icons.filter_alt_rounded),),
                Utils.getText(
                    "Total : \$${(context.watch<ExpenseDetailsBloc>().expenseAmount ?? 0.0).toString().toDoubleDigit}",
                weight: FontWeight.bold,
                size: 13.spMin,
                color: AppC.appColor)
              ],
            ),
            if (withInExpand)
            const Expanded(
              child: _VehicleExpenseListingPageContentUI(physics: BouncingScrollPhysics()),
            )
            else
              const _VehicleExpenseListingPageContentUI(),
          ],
        ),
      ),
    );
  }
}

class _VehicleExpenseListingPageContentUI extends StatelessWidget {
  final ScrollPhysics? physics;
  const _VehicleExpenseListingPageContentUI({super.key, this.physics = const NeverScrollableScrollPhysics()});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseDetailsBloc, ExpenseDetailsState>(
      builder: (context, state) => ListView.separated(
        shrinkWrap: true,
        physics: physics ?? const NeverScrollableScrollPhysics(),
        itemCount: context.watch<ExpenseDetailsBloc>().filteredExpenseDetails.length,
        separatorBuilder: (context, index) => const Divider(height: 0.5,),
        itemBuilder: (context, index) => VehicleExpenseDetailsListItem(model: context.watch<ExpenseDetailsBloc>().filteredExpenseDetails[index]),
      ),
    );
  }
}

