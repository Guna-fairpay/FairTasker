import 'package:fairpytasker/Component/compact_drop_down.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/resource/resource_main/bloc/resource_check_in_out_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResourceHistoryDatePicker extends StatelessWidget {
  const ResourceHistoryDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResourceCheckInOutBloc, ResourceCheckInOutState>(
      builder: (context, state) =>
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.spMin,
            children: [
              const SizedBox.shrink(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.spMin),
                  color: AppC.appbgColor
                ),
                child: ListTile(
                  title: const Text("Working Hours History"),
                  horizontalTitleGap: 0,
                  minVerticalPadding: 0,
                  minTileHeight: 40.spMin,
                  titleTextStyle: context.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  trailing: InkWell(
                    child: SvgPicture.asset(Assets.riSettingsFill),
                    onTap: () => context.read<ResourceCheckInOutBloc>().add(TaskComponentEvent()),
                  ),
                ),
              ),
              Row(
                spacing: 10.spMin,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DateRangePicker(
                      splitter: "to",
                      selectedDateRange: context
                          .watch<ResourceCheckInOutBloc>()
                          .selectedDateRange,
                      onDateRangeSelected: (range) =>
                          context.read<ResourceCheckInOutBloc>().add(
                              DateRangeChangedEvent(range)),
                    ),
                  ),
                  if (getIt<CommonService>().isAdmin)
                  Flexible(
                    child: CompactDropDown<Map<String, dynamic>>(
                      hintText: "Select Resource",
                      items: context.watch<ResourceCheckInOutBloc>().resources,
                      initialSelection: context.watch<ResourceCheckInOutBloc>().selectedResource,
                      itemAsString: (item) => "${item['first_name'] ?? ""} ${item['last_name'] ?? ""}",
                      onChanged: (value) => context.read<ResourceCheckInOutBloc>().add(ResourceSelectEvent(value)),
                    ),
                  )
                ],
              ),
              const SizedBox.shrink(),
            ],
          ),
    );
  }
}
