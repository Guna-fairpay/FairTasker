
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/Bloc/add_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/formatter/upper_case_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddVehicleMoreTwo extends StatelessWidget {
  const AddVehicleMoreTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddVehicleBloc, AddVehicleState>(
      builder: (context, state) => Visibility(
        visible: context.watch<AddVehicleBloc>().showMore,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: ImageUploadSection(
                      title: 'Upload Tire Image',
                      borderColor: Colors.grey,
                      onUpload: () =>context.read<AddVehicleBloc>().add(TireImageEvent()),
                      onRemove: (file) => context.read<AddVehicleBloc>().add(RemoveTireImageEvent(data: file)),
                      images: context.watch<AddVehicleBloc>().tireImage,
                      logName: "TireImageEvent",
                    ),
                ),
                10.width,
                Expanded(
                  child: Utils.getTextFormField(
                    'Number Plate',
                    context.read<AddVehicleBloc>().numberPlateController,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Expanded(
                  child: Column(
                    spacing: 10,
                    children: [
                      Utils.getTextFormField(
                        "Car Number",
                        context.read<AddVehicleBloc>().carNumberController,
                        textType: TextInputType.number,
                        textInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      ),
                      Utils.getTextFormField(
                          "Front tire e.g., 215/55R17",
                          context.read<AddVehicleBloc>().frontTireController,
                          textType: TextInputType.text,
                          textCapitalization : TextCapitalization.characters,
                          textInputFormatter: [UpperCaseFormatter()],
                          autoValidate: AutovalidateMode.onUserInteraction,
                          validator: (value){
                            final reg = RegExp(r'^\d{3}/\d{2}[A-Z]\d{2}$');
                            if(value!.isNotEmpty){
                              if (!reg.hasMatch(value)) {
                                return '215/55R17';
                              }
                            }
                            return null;
                          }
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 10,
                    children: [
                      Utils.getTextFormField("Oil Grade", context.read<AddVehicleBloc>().oilGradeController),
                      Utils.getTextFormField(
                          "Rear tire e.g., 215/55R17",
                          context.read<AddVehicleBloc>().rearTireController,
                          textType: TextInputType.text,
                          textCapitalization : TextCapitalization.characters,
                          textInputFormatter: [UpperCaseFormatter()],
                          autoValidate: AutovalidateMode.onUserInteraction,
                          validator: (value){
                            final reg = RegExp(r'^\d{3}/\d{2}[A-Z]\d{2}$');
                            if(value!.isNotEmpty){
                              if (!reg.hasMatch(value)) {
                                return '215/55R17';
                              }
                            }
                            return null;
                          }
                      ),
                    ],
                  ),
                ),
              ],
            ),
            10.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Utils.getText('Reg Sticker Date'),
                      CustomDateTimePicker<DateTime>(
                        controller:
                        context.read<AddVehicleBloc>().renewalDateController,
                        padding: 8.spMin.padding,
                        format: "MM-dd-yyyy",
                        labelText: "dd-mm-yyyy",
                        suffixIcon: Icon(Icons.calendar_month_rounded,
                            size: 18, color: context.theme.hintColor),
                        textAlign: TextAlign.start,
                        value: context.read<AddVehicleBloc>().selectedRegStickerDate,
                        onChanged: (value) => context
                            .read<AddVehicleBloc>().add(RegStickerDateEvent(selectedDate: value)),
                        showAsExpanded: true,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 5,
                    children: [
                      Utils.getText(''),
                      ImageUploadSection(
                        title: 'Upload Reg Sticker',
                        borderColor: Colors.grey,
                        onUpload: () =>context.read<AddVehicleBloc>().add(UploadRegStickerImageEvent()),
                        onRemove: (file) => context.read<AddVehicleBloc>().add(RemoveRegStickerImageEvent(data: file)),
                        images: context.watch<AddVehicleBloc>().uploadRegSticker,
                        logName: "UploadRegStickerImageEvent",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Utils.getTextFormField("Current Odometer", context.read<AddVehicleBloc>().currentOdometerController),),
                10.width,
                Expanded(child: Utils.getTextFormField("Oil Change Odometer (next)", context.read<AddVehicleBloc>().oilChangeOdometerController),),
              ],
            ),
            10.height,
            Utils.getTextFormField("Maintenance Check (days from today)", context.read<AddVehicleBloc>().maintenanceCheckController),
            10.height,
            Row(
              children: [
                Expanded(child: Utils.getTextFormField("Insurance Agent", context.read<AddVehicleBloc>().insuranceAgentController),),
                10.width,
                Expanded(child: Utils.getTextFormField("Insurance Cost", context.read<AddVehicleBloc>().insuranceCostController,
                  textType: const TextInputType.numberWithOptions(decimal: true),
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ]
                ),),
              ],
            ),
            10.height,
            ImageUploadSection(
              title: 'Insurance Image',
              borderColor: Colors.grey,
              onUpload: () =>context.read<AddVehicleBloc>().add(InsuranceImageEvent()),
              onRemove: (file) => context.read<AddVehicleBloc>().add(RemoveInsuranceImageEvent(data: file)),
              images: context.watch<AddVehicleBloc>().insuranceImage,
              logName: "InsuranceImageEvent",
            ),
          ],
        ),
      ),
    );
  }
}
