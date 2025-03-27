
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Components/image_upload_selection.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/UI/edit_vehicle_more_part_one.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class EditVehicleBody extends StatelessWidget {
  const EditVehicleBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditVehicleBloc, EditVehicleState>(
      builder: (context, state) => Form(
        key: context.watch<EditVehicleBloc>().formKey,
        child: ListView(
          children: [
            10.height,
            Utils.getTextFormField(
              "Year",context.read<EditVehicleBloc>().yearController,
              autoValidate: AutovalidateMode.onUserInteraction,
              validator: (val) =>
              val!.isEmpty ? 'Please enter year' : null,
              textType: TextInputType.number,
              textInputFormatter:[
                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}'))
              ],
            ),
            10.height,
            Utils.getTextFormField(
              "Make",context.read<EditVehicleBloc>().makeController,
              autoValidate: AutovalidateMode.onUserInteraction,
              validator: (val) => val!.isEmpty ? 'Please enter make' : null,
            ),
            10.height,
            Utils.getTextFormField(
              "Model",context.read<EditVehicleBloc>().modelController,
              autoValidate: AutovalidateMode.onUserInteraction,
              validator: (val) => val!.isEmpty ? 'Please enter model' : null,
            ),
            10.height,
            Utils.dropdownBox(
              'Cohort',
              context.read<EditVehicleBloc>().cohort,
                  (value)=>context.read<EditVehicleBloc>().add(CohortDropDownEvent(selectedCohort: value)),
              labelKey: 'cohort',
              initialSelection : context.read<EditVehicleBloc>().selectedCohort,
            ),
            10.height,
            Utils.getTextFormField(
              "Vin",context.read<EditVehicleBloc>().vinController,
              readOnly: true,
              fillColor: Colors.grey.shade200,
            ),
            10.height,
            Utils.getTextFormField(
              "Vehicle Id",context.read<EditVehicleBloc>().vehicleIdController,
            ),
            10.height,
            CustomDateTimePicker<DateTime>(
              controller:
              context.read<EditVehicleBloc>().purchaseDateController,
              format: "dd-MM-yyyy",
              suffixIcon: Icon(Icons.calendar_month_rounded,
                  size: 18, color: context.theme.hintColor),
              textAlign: TextAlign.center,
              value: context.read<EditVehicleBloc>().selectedDate,
              onChanged: (value) => context
                  .read<EditVehicleBloc>().add(DateChangeEvent(selectedDate: value)),
            ),
            10.height,
            Utils.getTextFormField(
              "Purchase Price",context.read<EditVehicleBloc>().purchasePriceController,
              autoValidate: AutovalidateMode.onUserInteraction,
              validator: (val) => val!.isEmpty ? 'Please enter purchasePrice' : null,
            ),
            10.height,
            ImageUploadSection(
              title: 'Upload Purchase Receipt',
              borderColor: Colors.blue,
              onUpload: () =>context.read<EditVehicleBloc>().add(PurchaseReceiptImageEvent()),
              onRemove: (file) => context.read<EditVehicleBloc>().add(RemovePurchaseReceiptImageEvent(data: file)),
              images: context.watch<EditVehicleBloc>().receiptImage,
              logName: "PurchaseReceiptImageEvent",
            ),
            10.height,
            ImageUploadSection(
              title: 'Upload Vehicle Image',
              borderColor: Colors.blue,
              onUpload: () => context.read<EditVehicleBloc>().add(VehicleImageEvent()),
              onRemove: (file) => context.read<EditVehicleBloc>().add(RemoveVehicleImageEvent(data: file)),
              images: context.watch<EditVehicleBloc>().vehicleImage,
              logName: "VehicleImageEvent",
            ),
            10.height,
            Utils.dropdownBox(
              'Select Branch',
              context.read<EditVehicleBloc>().branch,
                  (value)=>context.read<EditVehicleBloc>().add(BranchDropDownEvent(selectedBranch: value)),
              labelKey: 'city',
              initialSelection: context.read<EditVehicleBloc>().selectedBranch,
            ),
            10.height,
            const EditVehicleMorePartOne(),
            10.height,
            GestureDetector(
              onTap: () =>
                  context.read<EditVehicleBloc>().add(AddVehicleShowMoreEvent()),
              child: Utils.getText(
                  '${context.watch<EditVehicleBloc>().showMore ? "Less" : "More"}...',
                  color: (context.watch<EditVehicleBloc>().showMore
                      ? Colors.lightBlue
                      : Colors.lightGreen)
                      .shade800),
            ),
            10.height,
            Utils.getElevatedButton((){}),
          ],
        ),
      ),
    );
  }
}
