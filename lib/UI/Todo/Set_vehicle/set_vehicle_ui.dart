


import 'dart:developer';

import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Todo/Set_vehicle/set_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Todo/Set_vehicle/set_vehicle_event.dart';
import 'package:fairpytasker/UI/Todo/Set_vehicle/set_vehicle_state.dart';
import 'package:fairpytasker/UI/Todo/Set_vehicle/sparekeyTask_popup.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
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
            if(state.pop ?? false){
              context.pop();
            }
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
          else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        },
        child: BlocBuilder<setVehicleBloc, setVehicleState>(
          builder: (BuildContext context, state){
            return SafeArea(
              minimum: const EdgeInsets.all(8),
              child:
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: context.read<setVehicleBloc>().formKey,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Utils.getText("${selectedVehicle['vehicle_name'] ?? ''}", weight: FontWeight.bold),
                    Utils.getTextFormField(
                      "Address",
                      context.read<setVehicleBloc>().addressController,
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
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppC.fieldBase,
                                        width: Num.borderWidthField,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(Num.subradiusButton))),
                                  child:
                                  SuccessButton(
                                    text: 'Toll Image',
                                    icon: Icons.cloud_upload,
                                    backgroundColor: AppC.white,
                                    foregroundColor: AppC.grey,
                                    onPressed: ()=> context.read<setVehicleBloc>().add(setVehicleAddAttachmentEvent(imageType: 5)),
                                  )
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        if(context.read<setVehicleBloc>().spareTire)...[
                          Expanded(
                            child:
                            Utils.getTextFormField('e.g.,T165/70D18',
                                context.read<setVehicleBloc>().spareTireController,
                                validator: (value){
                                  final SpareTireRegex = RegExp(r'^[A-Z]?\d{3}/\d{2}[A-Z]\d{2}$');
                                  if(value!.isNotEmpty){
                                    if (!SpareTireRegex.hasMatch(value)) {
                                      return 'T165/70D18';
                                    }
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ] else...[
                          const Spacer()
                        ],
                      ],
                    ),
                    if(context.read<setVehicleBloc>().tollImage.isNotEmpty && context.read<setVehicleBloc>().tollTags)
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
                          ),
                            onTapView:()=> ShowAttachmentsDialog.of.show(context,
                                attachments: context.read<setVehicleBloc>().tollImage, title: "", currentAttachment: context.read<setVehicleBloc>().tollImage[index]
                            ),
                            onTapDelete: () => context.read<setVehicleBloc>().add(setVehicleRemoveAttachmentEvent(context.read<setVehicleBloc>().tollImage[index], context.read<setVehicleBloc>().tollImage, 5)),
                          )
                      ),
                    ),
                    checkBoxWithSingleText(
                      value: context.read<setVehicleBloc>().spareKey,
                      onChanged: (bool? value) {
                        context.read<setVehicleBloc>().add(setVehicleSpareKeyEvent(value: value ?? false));
                      },
                      label: 'Spare Key',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: checkBoxWithSingleText(
                            value: context.read<setVehicleBloc>().permanentPlate,
                            onChanged: (bool? value) {
                              context.read<setVehicleBloc>().add(setVehiclePermanentPlateEvent(value: value ?? false));
                            },
                            label: 'Permanent Plate',
                          ),
                        ),
                        if(context.read<setVehicleBloc>().permanentPlate)...[
                          Expanded(
                            child: checkBoxWithSingleText(
                              value: context.read<setVehicleBloc>().frontLicensePlate,
                              onChanged: (bool? value) {
                                context.read<setVehicleBloc>().add(setVehicleFLicensePlateEvent(value: value ?? false));
                              },
                              label: 'Front license plate',
                            ),
                          ),
                        ] else ...[
                          const Spacer()
                        ]
                      ],
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
                            SuccessButton(
                              text: 'Tire Image Upload',
                              icon: Icons.cloud_upload,
                              backgroundColor: AppC.white,
                              foregroundColor: AppC.grey,
                              onPressed: ()=> context.read<setVehicleBloc>().add(setVehicleAddAttachmentEvent(imageType: 2)),
                            )
                        ),
                        Expanded(
                          child: Utils.getTextFormField('Number Plate', context.read<setVehicleBloc>().vehicleNumberController,
                              hintTextColor: AppC.grey),
                        ),
                      ],
                    ),
                    //Tire Image Space
                    if(context.read<setVehicleBloc>().tireImageFile.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: GridView.builder(
                          shrinkWrap: true,
                          itemCount : context.read<setVehicleBloc>().tireImageFile.length,
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
                                  imageInput: context.read<setVehicleBloc>().tireImageFile[index],
                                  isNotImage:
                                  !((context.read<setVehicleBloc>().tireImageFile[index] as Object)
                                      .isImage),
                                ),
                              ),
                            ],
                          ),
                            onTapView:()=> ShowAttachmentsDialog.of.show(context,
                                attachments: context.read<setVehicleBloc>().tireImageFile, title: "", currentAttachment: context.read<setVehicleBloc>().tireImageFile[index]),
                            onTapDelete: () => context.read<setVehicleBloc>().add(setVehicleRemoveAttachmentEvent(context.read<setVehicleBloc>().tireImageFile[index], context.read<setVehicleBloc>().tireImageFile, 2)),
                          )
                      ),
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Utils.getNumberFormField(
                              'Car Number',
                              context.read<setVehicleBloc>().carNumberController,
                              hintTextColor: AppC.grey,
                          ),
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
                                if(value!.isNotEmpty){
                                  if (!FrontTireRegex.hasMatch(value)) {
                                    return '215/55R17';
                                  }
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
                                if(value!.isNotEmpty){
                                  if (!BackTireRegex.hasMatch(value)) {
                                    return '215/55R17';
                                  }
                                }
                                return null;
                              }
                          ),
                        ),
                      ],
                    ),
                    Utils.getText(
                        'Reg Sticker date',
                        weight: FontWeight.bold,
                        align: TextAlign.start
                    ),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              //Utils.dismissKeyboard(context);
                              context.read<setVehicleBloc>().add(setVehicleDatePickerEvent(value: value));
                            },
                            labelText: "mm-dd-yyyy",
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppC.fieldBase,
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(Num.subradiusButton)
                                    )
                                ),
                                child: SuccessButton(
                                  text: 'Upload Reg Sticker',
                                  icon: Icons.cloud_upload,
                                  backgroundColor: AppC.white,
                                  foregroundColor: AppC.grey,
                                  onPressed: ()=> context.read<setVehicleBloc>().add(setVehicleAddAttachmentEvent(imageType: 3)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Upload RegisterSticker
                      ],
                    ),
                    //Upload RegisterSticker
                    if(context.watch<setVehicleBloc>().uploadRegSticker.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: GridView.builder(
                            shrinkWrap: true,
                            itemCount : context.watch<setVehicleBloc>().uploadRegSticker.length,
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
                                    imageInput: context.read<setVehicleBloc>().uploadRegSticker[index],
                                    isNotImage:
                                    !((context.read<setVehicleBloc>().uploadRegSticker[index] as Object)
                                        .isImage),
                                  ),
                                ),
                              ],
                            ),
                              onTapView:()=> ShowAttachmentsDialog.of.show(context,
                                  attachments: context.read<setVehicleBloc>().uploadRegSticker, title: "", currentAttachment: context.read<setVehicleBloc>().uploadRegSticker[index]),
                              onTapDelete: () => context.read<setVehicleBloc>().add(setVehicleRemoveAttachmentEvent(context.read<setVehicleBloc>().uploadRegSticker[index], context.read<setVehicleBloc>().uploadRegSticker, 3)),
                            )
                        ),
                      ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Utils.getTextFormField('Insurance Agent', context.read<setVehicleBloc>().insuranceAgentController),
                        ),
                        Expanded(
                          child: Utils.getNumberFormField('Insurance Cost', context.read<setVehicleBloc>().insuranceCostController),
                        ),
                      ],
                    ),
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
                      child: SuccessButton(
                        text: 'Insurance Image',
                        icon: Icons.cloud_upload,
                        backgroundColor: AppC.white,
                        foregroundColor: AppC.grey,
                        onPressed: ()=> context.read<setVehicleBloc>().add(setVehicleAddAttachmentEvent(imageType: 4)),
                      ),
                    ),
                    if(context.read<setVehicleBloc>().insuranceImage.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: GridView.builder(
                            shrinkWrap: true,
                            itemCount : context.read<setVehicleBloc>().insuranceImage.length,
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
                                    imageInput: context.read<setVehicleBloc>().insuranceImage[index],
                                    isNotImage:
                                    !((context.read<setVehicleBloc>().insuranceImage[index] as Object)
                                        .isImage),
                                  ),
                                ),
                              ],
                            ),
                              onTapView:()=> ShowAttachmentsDialog.of.show(context,
                                  attachments: context.read<setVehicleBloc>().insuranceImage, title: "", currentAttachment: context.read<setVehicleBloc>().insuranceImage[index]),
                              onTapDelete: () => context.read<setVehicleBloc>().add(setVehicleRemoveAttachmentEvent(context.read<setVehicleBloc>().insuranceImage[index], context.read<setVehicleBloc>().insuranceImage, 4)),
                            )
                        ),
                      ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: SuccessButton(
                        text: 'Save',
                        onPressed: () {
                            if(context.read<setVehicleBloc>().spareKey == true){
                              context.read<setVehicleBloc>().add(setVehicleSaveEvent());
                            } else {
                              SpareKeyTaskDialog.show(
                                  context,
                                  save: (){
                                    context.read<setVehicleBloc>().add(setVehicleSaveEvent());
                                    },
                                  spareKeyCreate: (){context.read<setVehicleBloc>().add(createSparekeyTask());},
                                  cancel: (){}
                              );
                            }
                        },
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
