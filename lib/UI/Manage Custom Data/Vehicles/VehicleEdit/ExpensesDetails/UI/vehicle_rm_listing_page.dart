
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/UI/vehicle_rm_listing_item.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class VehicleRMListingPage extends StatelessWidget {
  const VehicleRMListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseDetailsBloc, ExpenseDetailsState>(
      builder: (context, state) => SafeArea(
        minimum: 10.padding,
        child: Column(
          spacing: 10.spMin,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: CompactSearchView(
                    controller: context.read<ExpenseDetailsBloc>().rmSearchController,
                    onChanged: (value) => context
                        .read<ExpenseDetailsBloc>()
                        .add(SearchRmExpenseEvent(value)),
                  ),
                  // Utils.getSearchBarUI(
                  //   searchController: context.read<ExpenseDetailsBloc>().rmSearchController,
                  //   onChange: (value) => context
                  //       .read<ExpenseDetailsBloc>()
                  //       .add(SearchRmExpenseEvent(value)),
                  // ),
                ),
                Utils.getText(
                    "Total : \$${(context.watch<ExpenseDetailsBloc>().rmExpenseAmount ?? 0.0).toStringAsFixed(2)}")
              ],
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: context.watch<ExpenseDetailsBloc>().filteredRmExpenseDetails.length,
              separatorBuilder: (context, index) => const Divider(height: 0.5),
              itemBuilder: (context, index) => VehicleRmListingItem(model: context.watch<ExpenseDetailsBloc>().filteredRmExpenseDetails[index]),
            ),
          ],
        ),
      ),
    );
  }
}
