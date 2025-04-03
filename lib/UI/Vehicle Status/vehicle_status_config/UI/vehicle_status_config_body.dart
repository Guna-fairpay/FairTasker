
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_config/Bloc/vehicle_status_config_bloc.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_config/Bloc/vehicle_status_config_event.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_config/Bloc/vehicle_status_config_status.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleStatusConfigBody extends StatelessWidget {
  const VehicleStatusConfigBody({super.key});

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 2; // Number of columns
    return BlocBuilder<VehicleStatusConfigBloc, VehicleStatusConfigStatus>(
        builder: (context, state) {
          return ListView(
          shrinkWrap: true,
          children: [
            SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Card(
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
                    title: Utils.getText('Vehicle Config',weight: FontWeight.bold),
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(Num.borderRadiusLarge)
                    ),
                    children: [
                      Container(
                        width: double.maxFinite,
                        color: AppC.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomCheckboxListTile(title: Text('Check All'),
                                  mainAxisSize: MainAxisSize.min,
                                  useExpand: false,
                                  padding: 10.padding,
                                  spacing: 10,
                                  value: false, onChanged: (value) {
                                  },
                                  activeColor: AppC.blue,
                                  radius: 6,
                                ),
                              ],
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: context.watch<VehicleStatusConfigBloc>().vehicleConfigData.length,
                              itemBuilder: (context, index) {
                                int row = index % crossAxisCount;
                                int col = index ~/ crossAxisCount;
                                int newIndex = (row * ((List.from(context.watch<VehicleStatusConfigBloc>().vehicleConfigData).length) ~/ crossAxisCount) + col).ceil();
                                var checklist = context.watch<VehicleStatusConfigBloc>().vehicleConfigData[newIndex];
                                return CustomCheckboxListTile(
                                    title: Text(checklist['category_name']),
                                    value: (checklist['checked'] == 1),
                                    activeColor: AppC.blue,
                                    radius: 6,
                                    onChanged: (value) {
                                      context.read<VehicleStatusConfigBloc>().add(CheckListSelectedEvent(data:checklist,isChecked:(value==true)?1:0));
                                      // Console.of.debug('value: ${value ?? false}');
                                    });
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
              ),
            ),
            ListView.separated(
              padding: 10.padding,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => 5.height,
              itemCount: context.watch<VehicleStatusConfigBloc>().vehicleConfigData.length,
              itemBuilder: (context, index) {
                var data = context.watch<VehicleStatusConfigBloc>().vehicleConfigData[index];
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
                          width: double.maxFinite,
                          color: AppC.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomCheckboxListTile(title: Text('Check All'),
                                    mainAxisSize: MainAxisSize.min,
                                    useExpand: false,
                                    padding: 10.padding,
                                    spacing: 10,
                                    value: data['checklists'].every((checklist) => checklist['checked'] == 1), onChanged: (value) {
                                    },
                                    suffix: Icon(Icons.list_alt_outlined,color: AppC.redAccent),
                                    activeColor: AppC.blue,
                                    radius: 6,
                                  ),
                                ],
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data['checklists'].length,
                                itemBuilder: (context, index) {
                                  int row = index % crossAxisCount;
                                  int col = index ~/ crossAxisCount;
                                  int newIndex = (row * ((List.from(data['checklists']).length) ~/ crossAxisCount) + col).ceil();
                                  var checklist = data['checklists'][newIndex];
                                  return CustomCheckboxListTile(
                                      title: Text(checklist['label']),
                                      value: (checklist['checked'] == 1),
                                      activeColor: AppC.blue,
                                      radius: 6,
                                      onChanged: (value) {
                                        context.read<VehicleStatusConfigBloc>().add(CheckListSelectedEvent(data:checklist,isChecked:(value==true)?1:0));
                                        // Console.of.debug('value: ${value ?? false}');
                                      });
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
            )
          ],
        );
    });
  }
}
