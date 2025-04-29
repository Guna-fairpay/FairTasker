
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_bloc.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_state.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Component/custom_radio_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/utils.dart';

class CategorySelectionField extends StatelessWidget {
  final Map<String, dynamic>? model;
  final Function? onConfirm;
  final Function? onCancel;
  const CategorySelectionField({super.key, this.onConfirm, this.onCancel, this.model});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TCCDBloc, TCCDState>(
        builder: ( context, state) => Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
                Utils.getText("Do you want to move the status to ?",size: 12.sp,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomRadioButton(
                      label: 'Recon',
                      value: true,
                      groupValue: true,
                      onChanged: () {},
                    ),
                    CustomRadioButton(
                      label: 'Rental',
                      value: true,
                      groupValue: true,
                      onChanged: () {},
                    ),
                    CustomRadioButton(
                      label: 'PreSale',
                      value: true,
                      groupValue: true,
                      onChanged: () {},
                    ),
                  ],),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children: [
                    InkWell(
                      child: Transform.scale(
                        scale: 0.6,
                        child: SizedBox(
                          width: 40,
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 4),
                            child: Switch(
                                trackOutlineColor:
                                WidgetStateColor.resolveWith(
                                      (states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return AppC.green;
                                    } else {
                                      return AppC.grey;
                                    }
                                  },
                                ),
                                inactiveThumbColor: AppC.white,
                                inactiveTrackColor: AppC.appColor,
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                activeColor: AppC.white,
                                activeTrackColor: AppC.green,
                                // value: completeAllDay,
                                value: true,
                                onChanged: (value) { }),
                          ),
                        ),
                      ),
                    ),
                    Utils.getText("Unblock Calendar",size: 12.sp,),
                    Expanded(
                      child: FittedBox(child: CustomCheckboxListTile(
                        useExpand: false,
                        mainAxisSize: MainAxisSize.min,
                        title: Utils.getText('Is Clean Required?',size: 12.sp,),
                        value: true, onChanged:(value){},
                        padding: 0.padding,
                      ),
                      ),
                    ),
                  ],
                ),
              Utils.getText("Vehicle Id : ${model?['vehicle_id']}",),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children: [
                    SuccessButton(
                      text: "Confirm",
                      onPressed: (){
                        onConfirm?.call();
                        context.pop();
                      },
                    ),
                    SuccessButton(
                      text: "Cancel",
                      backgroundColor: AppC.red,
                      onPressed:(){
                        onCancel?.call();
                        context.pop();
                      },
                    )
                  ],
                ),
            ]
        ));
  }
}
