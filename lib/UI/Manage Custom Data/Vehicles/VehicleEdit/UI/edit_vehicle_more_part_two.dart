
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class EditVehicleMoreTwo extends StatelessWidget {
  const EditVehicleMoreTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditVehicleBloc, EditVehicleState>(
      builder: (context, state) => Visibility(
        visible: context.watch<EditVehicleBloc>().showMore,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ImageUploadSection(
                    title: 'Upload Tire Image',
                    borderColor: Colors.blue,
                    onUpload: () =>context.read<EditVehicleBloc>().add(TireImageEvent()),
                    onRemove: (file) => context.read<EditVehicleBloc>().add(RemoveTireImageEvent(data: file)),
                    images: context.watch<EditVehicleBloc>().tireImage,
                    logName: "TireImageEvent",
                  ),
                ),
                10.width,
                Expanded(
                  child: Utils.getTextFormField(
                    'Number Plate',
                    context.read<EditVehicleBloc>().numberPlateController,
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
                      Utils.getTextFormField("Car Number", context.read<EditVehicleBloc>().carNumberController),
                      Utils.getTextFormField("Front tire e.g., 215/55R17", context.read<EditVehicleBloc>().frontTireController),

                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 10,
                    children: [
                      Utils.getTextFormField("Oil Grade", context.read<EditVehicleBloc>().oilGradeController),
                      Utils.getTextFormField("Rear tire e.g., 215/55R17", context.read<EditVehicleBloc>().rearTireController),
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
                        context.read<EditVehicleBloc>().renewalDateController,
                        format: "MM-dd-yyyy",
                        suffixIcon: Icon(Icons.calendar_month_rounded,
                            size: 18, color: context.theme.hintColor),
                        textAlign: TextAlign.start,
                        value: context.read<EditVehicleBloc>().selectedRegStickerDate,
                        onChanged: (value) => context
                            .read<EditVehicleBloc>().add(RegStickerDateEvent(selectedDate: value)),
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
                        borderColor: Colors.blue,
                        onUpload: () =>context.read<EditVehicleBloc>().add(UploadRegStickerImageEvent()),
                        onRemove: (file) => context.read<EditVehicleBloc>().add(RemoveRegStickerImageEvent(data: file)),
                        images: context.watch<EditVehicleBloc>().uploadRegSticker,
                        logName: "UploadRegStickerImageEvent",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Utils.getTextFormField("Current Odometer", context.read<EditVehicleBloc>().currentOdometerController),),
                10.width,
                Expanded(child: Utils.getTextFormField("Oil Change Odometer (next)", context.read<EditVehicleBloc>().oilChangeOdometerController),),
              ],
            ),
            10.height,
            Utils.getTextFormField("Maintenance Check (days from today)", context.read<EditVehicleBloc>().maintenanceCheckController),
            10.height,
            Row(
              children: [
                Expanded(child: Utils.getTextFormField("Insurance Agent", context.read<EditVehicleBloc>().insuranceAgentController),),
                10.width,
                Expanded(child: Utils.getTextFormField("Insurance Cost", context.read<EditVehicleBloc>().insuranceCostController),),
              ],
            ),
            10.height,
            ImageUploadSection(
              title: 'Insurance Image',
              borderColor: Colors.blue,
              onUpload: () =>context.read<EditVehicleBloc>().add(InsuranceImageEvent()),
              onRemove: (file) => context.read<EditVehicleBloc>().add(RemoveInsuranceImageEvent(data: file)),
              images: context.watch<EditVehicleBloc>().insuranceImage,
              logName: "InsuranceImageEvent",
            ),
          ],
        ),
      ),
    );
  }
}
