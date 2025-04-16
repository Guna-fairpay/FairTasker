import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'odometer_bloc.dart';
import 'odometer_event.dart';
import 'odometer_state.dart';

class OdometerView extends StatelessWidget {
  final Map<String, dynamic> vehicle;
  final Map<String, dynamic> todoItems;
  final dynamic selectedVehicle;
  OdometerView({super.key,
    required this.vehicle,
    required this.todoItems,
    required this.selectedVehicle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OdometerBloc()..add(OdometerInitialEvent(
        vehicle: vehicle,
        todoItems: todoItems,
        selectedVehicle: selectedVehicle,
      )),
      child: BlocListener<OdometerBloc, OdometerState>(listener: (context, state)
      {
        if(state.isLoading){
          EasyLoading.show(status: 'Loading...');
        } else {
          EasyLoading.dismiss();
        }
      },
        child: BlocBuilder<OdometerBloc, OdometerState>(
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                            text: "Previous Oil Change Odometer : ",
                            children: [
                              TextSpan(
                                  text:
                                  "${state.odometerData ?? 0}",
                                  style: context.textTheme.labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w900))
                            ]),
                        style: context.textTheme.labelLarge,
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Utils.getText(
                              'Oil Change Odometer',
                              weight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Utils.getText(
                              'Next Miles Check',
                              weight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child:
                            Utils.getTextFormField(
                              'Oil Change Odometer',
                              autoValidate: AutovalidateMode.always,
                              context.read<OdometerBloc>().oilChangeController,
                              inputAction: TextInputAction.next,
                              textType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*')),
                              ],
                              validator: (val) => (double.tryParse(
                                  val.toString()) ?? 0) <
                                  (double.tryParse("${state.odometerData ?? 0}") ?? 0)
                                  ? "Cannot enter lower than previous oil change odometer"
                                  : null,
                            ),
                          ),
                          Expanded(
                            child: Utils.getTextFormField(
                                'Next Miles Check',
                                textType: const TextInputType.numberWithOptions(
                                    decimal: true),
                                textInputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*')),
                                ],
                                context.read<OdometerBloc>().nextMilesCheckController,
                                inputAction: TextInputAction.done),
                          ),
                        ],
                      ),
                      // Utils.getText("Next Odometer",align: TextAlign.start),
                      // Utils.getTextFormField("Enter", TextEditingController())
                      Utils.getText('Next Odometer', weight: FontWeight.bold),
                      Utils.getTextFormField('Next Odometer',
                          context.read<OdometerBloc>().nextOdometerController,
                          readOnly: true),
                        SuccessButton(
                          onPressed: (){
                            var currentOdometer = num.tryParse(context.read<OdometerBloc>().oilChangeController.text);
                            var nextMileCheck = num.tryParse(context.read<OdometerBloc>().nextMilesCheckController.text);
                            var nextOdometer = num.tryParse(context.read<OdometerBloc>().nextOdometerController.text);
                            context.read<OdometerBloc>().add(OdometerSaveEvent(
                              currentOdometer: currentOdometer,
                              nextOdometer: nextOdometer,
                              nextMilesCheck: nextMileCheck,
                              toDoId: todoItems['id'],)
                            );
                          },
                        )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
