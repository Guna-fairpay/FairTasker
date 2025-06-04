import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_view/bloc/other_view_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_view/ui/other_listing_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtherViewPage extends StatelessWidget {
  const OtherViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherViewBloc, OtherViewState>(
      builder: (context, state) {
        return SafeArea(
          minimum: 10.verticalPadding,
          child: Column(
            spacing: 10,
            children: [
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    flex: 3,
                    child: DateRangePicker(
                      selectedDateRange: context.read<OtherViewBloc>().selectedDateRange,
                      onDateRangeSelected:(range) => context.read<OtherViewBloc>().add(DateRangeEvent(range)),
                    ),
                  ),
                  CompactIconButton(
                    elevation: 2,
                    icon:Icons.add,
                    iconSize: 18.spMin,
                    backgroundColor: AppC.appColor,
                    onPressed: ()=> context.read<OtherViewBloc>().add(AddEditEvent()),
                    shape: WidgetStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  ),
                  30.spMin.width,
                  Utils.getText(
                   'Total: \$${context.read<OtherViewBloc>().totalAmount.toStringAsFixed(2) ?? 0.00}',
                   style: const TextStyle(fontWeight: FontWeight.bold, color: AppC.appColor,)
                  ),
                ],
              ),
              (context.read<OtherViewBloc>().apiResponse.isEmpty && state is! LoadingState)
                  ? const EmptyWidget() :
             Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(height: 0.5),
                    itemCount: context.watch<OtherViewBloc>().apiResponse.length,
                  itemBuilder: (context, index) {
                    var data = context.watch<OtherViewBloc>().apiResponse[index];
                    return OtherListingPage(
                      model: data,
                      categoryDialog: (v) => context.read<OtherViewBloc>().add(CategoryDialogEvent(v)),
                      onChanged: (v) => context.read<OtherViewBloc>().add(ApproveEvent(model: data, approved: v)),
                      onDelete: (v) => context.read<OtherViewBloc>().add(DeleteEvent(id: data['id'].toString())),
                      onEdit: (v) => context.read<OtherViewBloc>().add(AddEditEvent(id: data['id'].toString())),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
