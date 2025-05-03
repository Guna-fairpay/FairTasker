


import 'dart:developer';

import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Todo/Set_vehicle/set_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Todo/Set_vehicle/set_vehicle_event.dart';
import 'package:fairpytasker/UI/Todo/Set_vehicle/set_vehicle_state.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../Component/custom_date_time_picker.dart';
import '../../../Component/image_viewer.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';

class SetVehicleUi extends StatelessWidget {
  final dynamic selectedVehicle;
  final Map<String, dynamic> todoItems;
  SetVehicleUi({super.key, this.selectedVehicle, required this.todoItems});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => setVehicleBloc()..add(setVehicleInitialEvents(vehicle: selectedVehicle, todoItems: todoItems)),
      child: BlocListener<setVehicleBloc, setVehicleState>(
        listener: (context, state) {
          if(state is setVehicleLoading){
            EasyLoading.show();
          }
          else if(state is setVehicleLoaded){
            if (EasyLoading.isShow) EasyLoading.dismiss();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        },
        child: BlocBuilder<setVehicleBloc, setVehicleState>(
          builder: (BuildContext context, state){
            return SafeArea(
              minimum: const EdgeInsets.all(8),
              child:
              Form(
                autovalidateMode: AutovalidateMode.onUnfocus,
                key: context.read<setVehicleBloc>().formKey,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Utils.getTextFormField(
                      "Address",
                      TextEditingController(),
                      inputAction: TextInputAction.newline,
                      textType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child:
                          Column(
                            spacing: 10,
                            children: [
                              checkBoxWithSingleText(
                                value: context.read<setVehicleBloc>().bouncie,
                                onChanged: (bool? value) {
                                  context.read<setVehicleBloc>().add(setVehicleBouncieEvent(value: value ?? false));
                                },
                                label: 'Bouncie',
                              ),
                              checkBoxWithSingleText(
                                value: context.read<setVehicleBloc>().tollTags,
                                onChanged: (bool? value) {
                                  context.read<setVehicleBloc>().add(setVehicleTollTagsEvent(value: value ?? false));
                                },
                                label: 'Toll tags',
                              ),
                              checkBoxWithSingleText(
                                value: context.read<setVehicleBloc>().spareKey,
                                onChanged: (bool? value) {
                                  context.read<setVehicleBloc>().add(setVehicleSpareKeyEvent(value: value ?? false));
                                },
                                label: 'Spare Key',
                              ),
                              checkBoxWithSingleText(
                                value: context.read<setVehicleBloc>().permanentPlate,
                                onChanged: (bool? value) {
                                  context.read<setVehicleBloc>().add(setVehiclePermanentPlateEvent(value: value ?? false));
                                },
                                label: 'Permanent Plate',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              checkBoxWithSingleText(
                                value: context.read<setVehicleBloc>().airTag,
                                onChanged: (bool? value) {
                                  context.read<setVehicleBloc>().add(setVehicleAirTagEvent(value: value ?? false));
                                },
                                label: 'AirTag',
                              ),
                              checkBoxWithSingleText(
                                value: context.read<setVehicleBloc>().spareTire,
                                onChanged: (bool? value) {
                                  context.read<setVehicleBloc>().add(setVehicleSpareTireEvent(value: value ?? false));
                                },
                                label: 'Spare Tire',
                              ),
                              if(context.read<setVehicleBloc>().permanentPlate)...[
                                checkBoxWithSingleText(
                                  value: context.read<setVehicleBloc>().frontLicensePlate,
                                  onChanged: (bool? value) {
                                    context.read<setVehicleBloc>().add(setVehicleFLicensePlateEvent(value: value ?? false));
                                  },
                                  label: 'Front license plate',
                                ),
                              ] else ...[
                                const SizedBox()
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            spacing: 10,
                            children: [
                              if(context.read<setVehicleBloc>().tollTags)...[
                                Utils.getTextFormField('Enter the toll tag id', context.read<setVehicleBloc>().tollTagsIdController),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppC.fieldBase,
                                        width: Num.borderWidthField,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(Num.subradiusButton))),
                                  child:
                                  Utils.getOutlinedButton(
                                    'Toll Image',
                                        () {
                                      // Utils.dismissKeyboard(context);
                                      // var result = await _pickImages2();
                                      // if (result != null) {
                                      //   var files = tollImage.whereType<File>().map((e) => e.path);
                                      //   for (var element in result) {
                                      //     if (!files.contains(element.path)) {
                                      //       tollImage.add(element);
                                      //     }
                                      //   }
                                      // }
                                    },
                                    iconData: const Icon(Icons.cloud_upload, color: AppC.blue, size: 12),
                                    verticalPadding: 0,
                                    radius: BorderRadius.zero,
                                    bgColor: AppC.trans,
                                    borderColor: AppC.trans,
                                    textColor: AppC.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        if(context.read<setVehicleBloc>().spareTire)...[
                          Expanded(
                            child:
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Utils.getTextFormField('e.g.,T165/70D18',
                                  context.read<setVehicleBloc>().spareTireController,
                                  validator: (value){
                                    final SpareTireRegex = RegExp(r'^[A-Z]?\d{3}/\d{2}[A-Z]\d{2}$');
                                    if (!SpareTireRegex.hasMatch(value ?? '')) {
                                      return 'T165/70D18';
                                    }
                                    return null;
                                  }
                              ),
                            ),
                          ),
                        ] else...[
                          const SizedBox()
                        ],
                      ],
                    ),
                    Utils.getText("Toll image"),
                    SizedBox(
                      height: 100,
                      child: GridView.builder(
                          shrinkWrap: true,
                          itemCount : context.read<setVehicleBloc>().tollImage.length,
                          scrollDirection: Axis.horizontal,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1, mainAxisSpacing: 10),
                          itemBuilder: (context, index) => CloseBadge(child: Stack(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: MediaQuery.sizeOf(context).height,
                                  minWidth: MediaQuery.sizeOf(context).width,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: AppC.grey.withValues(alpha: 0.2)),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: ImageViewer(
                                  fit: BoxFit.cover,
                                  imageInput: context.read<setVehicleBloc>().tollImage[index],
                                  isNotImage:
                                  !((context.read<setVehicleBloc>().tollImage[index] as Object)
                                      .isImage),
                                ),
                              ),
                            ],
                          ))
                      ),
                    ),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: AppC.fieldBase,
                                width: Num.borderWidthField,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(Num.subradiusButton))),
                          child:
                          // Utils.getOutlinedButton(
                          //   'Tire Image Upload',
                          //       () {
                          //     // var result = await _pickImages2();
                          //     // if (result != null) {
                          //     //   var files = tireImageFile.whereType<File>().map((e) => e.path);
                          //     //   for (var element in result) {
                          //     //     if (!files.contains(element.path)) {
                          //     //       tireImageFile.add(element);
                          //     //     }
                          //     //   }
                          //     //   setState(() {});
                          //     // }
                          //   },
                          //   iconData: const Icon(Icons.cloud_upload, color: AppC.blue, size: 12),
                          //   radius: BorderRadius.zero,
                          //   bgColor: AppC.trans,
                          //   borderColor: AppC.trans,
                          //   textColor: AppC.grey,
                          //   verticalPadding: 0,
                          // ),
                            const SuccessButton(
                              text: 'Tire Image Upload',
                              icon: Icons.cloud_upload,
                              iconColor: AppC.blue,
                              backgroundColor: AppC.white,
                              foregroundColor: AppC.grey,
                            )
                        ),
                        Expanded(
                          child: Utils.getTextFormField('Number Plate', context.read<setVehicleBloc>().vehicleNumberController,
                              hintTextColor: AppC.grey),
                        ),
                      ],
                    ),
                    //Tire Image Space
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Utils.getTextFormField('Car Number', context.read<setVehicleBloc>().carNumberController,
                              hintTextColor: AppC.grey),
                        ),
                        Expanded(
                          child: Utils.getTextFormField('Oil grade', context.read<setVehicleBloc>().oilGradeController,
                              hintTextColor: AppC.grey),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Utils.getTextFormField('Front tire e.g., 215/55R17',
                              context.read<setVehicleBloc>().frontTireController,
                              hintTextColor: AppC.grey,
                              validator: (value){
                                final FrontTireRegex = RegExp(r'^\d{3}/\d{2}[A-Z]\d{2}$');
                                if (!FrontTireRegex.hasMatch(value ?? '')) {
                                  return '215/55R17';
                                }
                                return null;
                              }
                          ),
                        ),
                        Expanded(
                          child: Utils.getTextFormField('Rear tire e.g., 215/55R17',
                              context.read<setVehicleBloc>().rearTireController,
                              hintTextColor: AppC.grey,
                              validator: (value){
                                final BackTireRegex = RegExp(r'^\d{3}/\d{2}[A-Z]\d{2}$');
                                if (!BackTireRegex.hasMatch(value ?? '')) {
                                  return '215/55R17';
                                }
                                return null;
                              }
                          ),
                        ),
                      ],
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child:
                        Utils.getText(
                            'Reg Sticker date',
                            weight: FontWeight.bold,
                            align: TextAlign.start)
                    ),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomDateTimePicker<DateTime>(
                            controller: context.read<setVehicleBloc>().renewalDateController,
                            format: "MM-dd-yyyy",
                            suffixIcon: Icon(Icons.calendar_month_rounded,
                                size: 18, color: context.theme.hintColor),
                            textAlign: TextAlign.center,
                            value: context.read<setVehicleBloc>().renewalDate,
                            onChanged: (value){
                              log("Renewal Date: $value");
                              context.read<setVehicleBloc>().add(setVehicleDatePickerEvent(value: value));
                                log("Renewal Date: ${context.read<setVehicleBloc>().renewalDate}");
                            },
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              // Container(
                              //   height: 48,
                              //   decoration: BoxDecoration(
                              //       border: Border.all(
                              //         color: AppC.fieldBase,
                              //         width: Num.borderWidthField,
                              //       ),
                              //       borderRadius:
                              //       const BorderRadius.all(Radius.circular(Num.subradiusButton))),
                              //   child: Utils.getOutlinedButton(
                              //     'Upload Reg Sticker',
                              //         () {
                              //       // var result = await _pickImages2();
                              //       // if (result != null) {
                              //       //   var files = uploadRegSticker.whereType<File>().map((e) => e.path);
                              //       //   for (var element in result) {
                              //       //     if (!files.contains(element.path)) {
                              //       //       uploadRegSticker.add(element);
                              //       //     }
                              //       //   }
                              //       // }
                              //     },
                              //     iconData: const Icon(Icons.cloud_upload, color: AppC.blue, size: 12),
                              //     verticalPadding: 0,
                              //     radius: BorderRadius.zero,
                              //     bgColor: AppC.trans,
                              //     borderColor: AppC.trans,
                              //     textColor: AppC.grey,
                              //   ),
                              // ),
                              Container(
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppC.fieldBase,
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(Num.subradiusButton)
                                    )
                                ),
                                child: const SuccessButton(
                                  text: 'Upload Reg Sticker',
                                  icon: Icons.cloud_upload,
                                  iconColor: AppC.blue,
                                  backgroundColor: AppC.white,
                                  foregroundColor: AppC.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Upload RegisterSticker
                      ],
                    ),
                    //Upload RegisterSticker
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Utils.getTextFormField('Insurance Agent', context.read<setVehicleBloc>().insuranceAgentController),
                        ),
                        Expanded(
                          child: Utils.getTextFormField('Insurance Cost', context.read<setVehicleBloc>().insuranceCostController),
                        ),
                      ],
                    ),
                    // Container(
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //         color: AppC.fieldBase,
                    //         width: Num.borderWidthField,
                    //       ),
                    //       borderRadius: const BorderRadius.all(Radius.circular(Num.subradiusButton))
                    //   ),
                    //   child: Utils.getOutlinedButton(
                    //     'Insurance Image',
                    //         () {
                    //       // var result = await _pickImages2();
                    //       // if (result != null) {
                    //       //   var files = insuranceImage.whereType<File>().map((e) => e.path);
                    //       //   for (var element in result) {
                    //       //     if (!files.contains(element.path)) {
                    //       //       insuranceImage.add(element);
                    //       //     }
                    //       //   }
                    //       //   setState(() {});
                    //       // }
                    //     },
                    //     iconData: const Icon(Icons.cloud_upload, color: AppC.blue, size: 12),
                    //     verticalPadding: 0,
                    //     radius: BorderRadius.zero,
                    //     bgColor: AppC.trans,
                    //     borderColor: AppC.trans,
                    //     textColor: AppC.grey,
                    //   ),
                    // ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppC.fieldBase,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Num.subradiusButton)
                        )
                      ),
                      child: const SuccessButton(
                        text: 'Insurance Image',
                        icon: Icons.cloud_upload,
                        iconColor: AppC.blue,
                        backgroundColor: AppC.white,
                        foregroundColor: AppC.grey,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: SuccessButton(
                        text: 'Save',
                        onPressed: ()=> context.read<setVehicleBloc>().add(setVehicleSaveEvent()),
                      ),
                    )
                  ],
                ),
              ),);
          },
        ),
      ),
    );
  }
}

//int boolToInt(bool value) => value ? 1 : 0;
Widget checkBoxWithSingleText({
  required bool value,
  required ValueChanged<bool?> onChanged,
  required String label,
  double scale = 1.0,
}) {
  return Row(
    children: [
      Transform.scale(
        scale: scale,
        child: SizedBox(
          height: 15,
          child: Checkbox(
            activeColor: AppC.blue,
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
      Expanded(child: Utils.getText(label)),
    ],
  );
}