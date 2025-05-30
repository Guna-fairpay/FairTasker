import 'package:fairpytasker/Component/custom_search_bar.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/offshore_report/componet/card.dart';
import 'package:fairpytasker/UI/offshore_report/operations/bloc/operation_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OperationDetailsPage extends StatelessWidget {
  const OperationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OperationBloc, OperationState>(
        builder: (context, state) => Column(
          spacing: 10,
      children: [
        DateRangePicker(
          selectedDateRange: context.read<OperationBloc>().selectedDateRange,
            onDateRangeSelected:(value)=> context.read<OperationBloc>().add(DateRangeSelectedEvent(value))),
        CustomSearchBar(
          controller: context.read<OperationBloc>().searchController,
          onChanged: (query) => context.read<OperationBloc>().add(SearchEvent(query)),
          hintText: 'Search...',
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: context.watch<OperationBloc>().filteredResponse?.length ?? 0,
            itemBuilder: (context, index) {
              var item = context.watch<OperationBloc>().filteredResponse?[index];
              return CustomCard(
                color: AppC.appColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Utils.getText(item?['title'] ?? '',color: AppC.appColor),
                    Utils.getText(item?['todo_date'] ?? ''),
                    Utils.getText(item?['notes'] ?? ''),
                    Utils.getText("${item?['users']?['first_name'] ?? ''} ${item?['users']?['last_name'] ?? ''}",color: AppC.appColor,weight: FontWeight.w900),
                    FAProgressBar(
                      currentValue: (item?['status'] ?? '') == 'Completed' ? 100 : 0,
                      maxValue: 100,
                      animatedDuration: Durations.extralong4,
                      displayText: " % ",
                      size: 18.spMin,
                      progressGradient: const LinearGradient(
                        colors: [AppC.appColor, AppC.appbgColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      progressColor: AppC.appColor,
                      backgroundColor: AppC.lightGray,
                      displayTextStyle: (context.textTheme.labelLarge ?? TextStyle()).copyWith(color: Colors.white, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ],
    ),);
  }
}
