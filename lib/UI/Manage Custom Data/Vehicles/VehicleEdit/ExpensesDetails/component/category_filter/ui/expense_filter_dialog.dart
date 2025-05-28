import 'package:fairpytasker/Component/compact_alert_dialog.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/component/category_filter/bloc/category_filter_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseFilterDialog {
  ExpenseFilterDialog._();

  static void show({
    required BuildContext context,
    TapDownDetails? details,
    List<Map<String, dynamic>>? model,
    void Function(List<dynamic>)? onChanged,
    dynamic idList,
  }) async {
    await showDialog(
        context: context,
        builder: (context) => _ExpenseFilterDialogUI(
              model: model,
              details: details,
              onChanged: onChanged,
              idList: idList,
            ),
        barrierDismissible: false);
  }
}

class _ExpenseFilterDialogUI extends StatelessWidget {
  final List<Map<String, dynamic>>? model;
  final TapDownDetails? details;
  final void Function(List<dynamic>)? onChanged;
  final dynamic idList;
  const _ExpenseFilterDialogUI({
    super.key,
    required this.model,
    this.details,
    this.onChanged,
    this.idList,
  });

  @override
  Widget build(BuildContext context) {
    return CompactAlertDialog(
      alignment: Alignment.center,
      withMaxWidth: false,
      content: BlocProvider(
        create: (context) =>
            CategoryFilterBloc()..add(CategoryFilterInitialEvent(model ?? [], idList: idList)),
        child: BlocListener<CategoryFilterBloc, CategoryFilterState>(
          listener: (context, state) {
            if (state is OnchangeState) {
              onChanged?.call(state.value);
            }
          },
          child: BlocBuilder<CategoryFilterBloc, CategoryFilterState>(
              builder: (context, state) => Container(
                    width: 30,
                    constraints:
                        BoxConstraints(maxHeight: context.height * 0.4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomCheckboxListTile(
                          useExpand: false,
                          title: const CompactText('All',
                              styleType: TextStyleType.labelLarge,
                              fontWeight: FontWeight.bold),
                          isCheckboxOnRight: true,
                          radius: 8,
                          borderColor: AppC.appColor,
                          value: context.read<CategoryFilterBloc>().isAll,
                          onChanged: (v) => context
                              .read<CategoryFilterBloc>()
                              .add(CategoryFilterSelectAllEvent()),
                        ),
                        Flexible(
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: context
                                  .watch<CategoryFilterBloc>()
                                  .popupFilterData
                                  .length,
                              itemBuilder: (context, index) {
                                var category = context
                                    .watch<CategoryFilterBloc>()
                                    .popupFilterData[index];
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomCheckboxListTile(
                                        title: CompactText(
                                            category['category_name'] ?? "",
                                            fontWeight: FontWeight.bold,
                                            styleType:
                                                TextStyleType.labelLarge),
                                        radius: 8,
                                        borderColor: AppC.appColor,
                                        value: (List.from(category['sub_category'] ?? []).length == (List.from(category['sub_category'] ?? []).where(
                                                (element) => element['checked'] == true).length)),
                                        onChanged: (v) => context.read<CategoryFilterBloc>().add(CategoryFilterSelectCategoryEvent(category, value: v ?? false))),
                                    Padding(
                                      padding: 40.spMin.leftPadding,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.from(
                                                category['sub_category'] ?? [])
                                            .map((e) => CustomCheckboxListTile(
                                                title: CompactText(
                                                  e['name'],
                                                  styleType:
                                                      TextStyleType.labelMedium,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                radius: 8,
                                                borderColor: AppC.appColor,
                                                value: e['checked'],
                                                onChanged: (v) => context.read<CategoryFilterBloc>().add(CategoryFilterSelectSubCategoryEvent(e))))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
        ),
      ),
    );
  }
}
