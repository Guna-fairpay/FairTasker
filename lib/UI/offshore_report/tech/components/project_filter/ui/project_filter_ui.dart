import 'package:fairpytasker/Component/compact_alert_dialog.dart';
import 'package:fairpytasker/Component/custom_search_bar.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/offshore_report/tech/components/project_filter/bloc/project_filter_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectFilterUI {
  ProjectFilterUI._();
  static void show({
    required BuildContext context,
    List<Map<String, dynamic>>? model,
    void Function(List<dynamic>)? onChanged,
  }) async {
    await showDialog(
        context: context,
        builder: (context) => _ProjectFilterUI(model: model, onChanged: onChanged,),
        barrierDismissible: false);
  }
}

class _ProjectFilterUI extends StatelessWidget {
  final List<Map<String, dynamic>>? model;
  final void Function(List<dynamic>)? onChanged;
  const _ProjectFilterUI({
    super.key,
    required this.model,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: 16.spMin.padding,
      contentPadding: 16.spMin.horizontalPadding.copyWith(bottom: 16.spMin),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      title: ListTile(
        contentPadding: 0.padding.copyWith(left: 16.spMin),
        title: const Text('Project List', style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: IconButton(onPressed: context.pop, icon: const Icon(Icons.close)),
      ),
      titlePadding: 0.padding,
      content: BlocProvider(
        create: (context) =>
        ProjectFilterBloc()..add(InitialEvent(model ?? [],)),
        child: BlocListener<ProjectFilterBloc, ProjectFilterState>(
          listener: (context, state) {
            if (state is OnChangeState) onChanged?.call(state.value);
          },
          child: BlocBuilder<ProjectFilterBloc, ProjectFilterState>(
              builder: (context, state) => Container(
                width: 30,
                constraints:
                BoxConstraints(maxHeight: context.height * 0.5, minWidth: context.width * 0.3, maxWidth: context.width * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomSearchBar(
                      controller: context.read<ProjectFilterBloc>().searchController,
                      onChanged: (query) => context.read<ProjectFilterBloc>().add(ProjectSearchEvent(query)),
                      hintText: 'Search...',
                    ),
                    TextButton(
                      onPressed: () => context.read<ProjectFilterBloc>().add(SelectAllEvent()),
                      child: Row(
                        spacing: 4,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(context.watch<ProjectFilterBloc>().isAll ? Icons.close : Icons.check, size: 16.spMin,),
                          Text(context.watch<ProjectFilterBloc>().isAll ? 'Unselect All' : 'Select All',),
                        ],
                      )
                    ),
                    Flexible(
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: context.watch<ProjectFilterBloc>().popupFilterData?.length ?? 0,
                          itemBuilder: (context, index) {
                            var item = context.watch<ProjectFilterBloc>().popupFilterData?[index];
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
                                    onChanged: (v) => context.read<ProjectFilterBloc>().add(SelectProjectEvent(item))),
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
