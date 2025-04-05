
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_checklist/Bloc/vehicle_status_checklist_bloc.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_checklist/Bloc/vehicle_status_checklist_event.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_checklist/Bloc/vehicle_status_checklist_state.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleStatusCheckListBodyUI extends StatelessWidget {
  const VehicleStatusCheckListBodyUI({super.key});

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 2; // Number of columns
    return BlocBuilder<VehicleStatusChecklistBloc, VehicleStatusChecklistState>(
        builder: (context, state) {
          return ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              SafeArea(
                minimum: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: FAProgressBar(
                  currentValue: context.watch<VehicleStatusChecklistBloc>().percentage,
                  displayText: '%',
                  backgroundColor: AppC.grey.shade300,
                  progressColor: AppC.green,
                  animatedDuration: const Duration(seconds: 1),
                  size: 20,
                  maxValue: 100,
                  displayTextStyle: const TextStyle(fontWeight: FontWeight.bold,color: AppC.white),
                ),
              ),
              ListView.separated(
                padding: 10.padding,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => 5.height,
                itemCount: context.watch<VehicleStatusChecklistBloc>().vehicleConfigData.length,
                itemBuilder: (context, index) {
                  var data = context.watch<VehicleStatusChecklistBloc>().vehicleConfigData[index];
                  return Card(
                    elevation: 0,
                    color: AppC.blue50,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
                    child: Container(
                      padding: 16.padding,
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        backgroundColor: Colors.blue.shade100,
                        collapsedBackgroundColor: Colors.blue.shade100,
                        title: Utils.getText(data['category_name'],weight: FontWeight.bold),
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(Num.borderRadiusLarge)
                        ),
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            width: double.maxFinite,
                            color: AppC.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data['checklists'].length,
                                  itemBuilder: (context, index) {
                                    int row = index % crossAxisCount;
                                    int col = index ~/ crossAxisCount;
                                    int newIndex = (row * ((List.from(data['checklists']).length) ~/ crossAxisCount) + col).ceil();
                                    var checklist = data['checklists'][newIndex];
                                    return CustomCheckboxListTile(
                                        title: Text(checklist['checklist_name']),
                                        value: (checklist['checked'] == 1),
                                        activeColor: AppC.blue,
                                        radius: 6,
                                        onChanged: (value) => context.read<VehicleStatusChecklistBloc>().add(CheckListSelectedEvent(data:checklist,isChecked:(value==true)?1:0)));
                                    },
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: 5,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }
}

