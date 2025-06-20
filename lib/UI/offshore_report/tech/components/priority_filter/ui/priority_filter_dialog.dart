import 'package:fairpytasker/Component/custom_search_bar.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/offshore_report/tech/components/priority_filter/bloc/priority_filter_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriorityFilterDialog {
  PriorityFilterDialog._();
  static void show({
    required BuildContext context,
    List<dynamic>? model,
    void Function(List<dynamic>)? onChanged,
  }) async {
    await showDialog(
        context: context,
        builder: (context) => _PriorityFilterDialog(onChanged: onChanged, model: model,),
        barrierDismissible: false);
  }
}

class _PriorityFilterDialog extends StatelessWidget {
  final void Function(List<dynamic>)? onChanged;
  final List<dynamic>? model;

  const _PriorityFilterDialog({
    super.key,
    required this.model,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: 16.sp.padding,
      contentPadding: 16.sp.horizontalPadding.copyWith(bottom: 16.sp),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      title: ListTile(
        contentPadding: 0.padding.copyWith(left: 16.spMin),
        title: const Text('Priority List', style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: IconButton(onPressed: context.pop, icon: const Icon(Icons.close)),
      ),
      titlePadding: 0.padding,
      content: BlocProvider(
        create: (context) =>
        PriorityFilterBloc()..add(InitialEvent(model ?? [])),
        child: BlocListener<PriorityFilterBloc, PriorityFilterState>(
          listener: (context, state) {
            if (state is OnChangeState) onChanged?.call(state.value);
          },
          child: BlocBuilder<PriorityFilterBloc, PriorityFilterState>(
              builder: (context, state) => Container(
                width: 30,
                constraints:
                BoxConstraints(maxHeight: context.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        onPressed: () => context.read<PriorityFilterBloc>().add(SelectAllEvent()),
                        child: Row(
                          spacing: 4,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(context.watch<PriorityFilterBloc>().isAll ? Icons.close : Icons.check, size: 16.spMin,),
                            Text(context.watch<PriorityFilterBloc>().isAll ? 'Unselect All' : 'Select All',),
                          ],
                        )
                    ),
                    Flexible(
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: context.watch<PriorityFilterBloc>().popupFilterData.length,
                          itemBuilder: (context, index) {
                            var item = context.watch<PriorityFilterBloc>().popupFilterData[index];
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomCheckboxListTile(
                                    title: CompactText(
                                        item?['name'] ?? "",
                                        fontWeight: FontWeight.bold,
                                        styleType:
                                        TextStyleType.labelLarge),
                                    radius: 8,
                                    borderColor: AppC.appColor,
                                    value: (item?['checked'] ?? false),
                                    onChanged: (v) => context.read<PriorityFilterBloc>().add(SelectedPriorityEvent(item))),
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
