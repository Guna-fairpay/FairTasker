
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_config/Bloc/vehicle_status_config_bloc.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_config/Bloc/vehicle_status_config_state.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SwapIndexPopUp{
  SwapIndexPopUp._();
  static void show(BuildContext context,{
    required Function(List<dynamic>) onReorderUpdate,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<VehicleStatusConfigBloc>(context),
        child: _SwapIndexPopUp(
          onReorderUpdate: onReorderUpdate,
        ),
      ),
    );
  }
}

class _SwapIndexPopUp extends StatelessWidget {
  final Function(List<dynamic>) onReorderUpdate;

  const _SwapIndexPopUp({
    required this.onReorderUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleStatusConfigBloc,VehicleStatusConfigState>(
        builder: (context,state) {
          return Dialog(
            alignment: Alignment.topCenter,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
            backgroundColor: AppC.white,
            insetPadding: 10.padding,
            child:  Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Utils.getText(
                          context.read<VehicleStatusConfigBloc>().matchedData['category_name']??'',
                          weight: FontWeight.w600,
                        color: AppC.appColor,
                        size: 17.spMin
                      ),
                      const Spacer(),
                      IconButton(onPressed: context.popDialog, icon: const Icon(Icons.close,color: AppC.redAccent))
                    ],
                  ),
                ),
                Flexible(
                  child: ReorderableListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shrinkWrap: true,
                    onReorder: (int oldIndex, int newIndex) {
                      List<dynamic> updatedList = List.from(
                        context.read<VehicleStatusConfigBloc>().matchedData?['checklists'] ?? [],
                      );

                      if (newIndex > oldIndex) newIndex -= 1;
                      final item = updatedList.removeAt(oldIndex);
                      updatedList.insert(newIndex, item);
                      onReorderUpdate(updatedList);
                    },
                    itemCount: (context.read<VehicleStatusConfigBloc>().matchedData?['checklists'] ?? []).length,
                    itemBuilder: (context, index) {
                      var checklist = context.read<VehicleStatusConfigBloc>().matchedData?['checklists'][index];
                      return Card(
                        key: ValueKey(checklist['checklist_order']),
                        color: AppC.grey.shade300,
                        margin: const EdgeInsets.all(3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        child: ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          title: Utils.getText(
                            "${checklist['label']} - ${checklist['checklist_order']}",
                            weight: FontWeight.bold,
                            size: 12.spMin,
                          ),
                        ),
                      );
                    },
                    proxyDecorator: (child, index, animation) {
                      return Material(
                        elevation: 6,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: child,
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
