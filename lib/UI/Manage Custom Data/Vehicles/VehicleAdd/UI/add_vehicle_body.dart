
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/Bloc/add_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/Bloc/add_vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/Bloc/add_vehicle_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleAdd/UI/add_vehicle_more_part_one.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AddVehicleBody extends StatelessWidget {
  final Widget? searchChild;
  const AddVehicleBody({super.key, this.searchChild});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddVehicleBloc, AddVehicleState>(
      builder: (context, state) => Form(
        key: context.read<AddVehicleBloc>().formKey,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            10.height,
            Utils.getTextFormField(
                "Year",context.read<AddVehicleBloc>().yearController,
              autoValidate: AutovalidateMode.onUserInteraction,
              validator: (val) => val!.isEmpty ? 'Please enter year' : null,
              textType: TextInputType.number,
              textInputFormatter:[
                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}'))
              ],
              ),
            10.height,
            Utils.getTextFormField(
              "Make",context.read<AddVehicleBloc>().makeController,
              autoValidate: AutovalidateMode.onUserInteraction,
              validator: (val) => val!.isEmpty ? 'Please enter make' : null,
            ),
            10.height,
            Utils.getTextFormField(
              "Model",context.read<AddVehicleBloc>().modelController,
              autoValidate: AutovalidateMode.onUserInteraction,
              validator: (val) => val!.isEmpty ? 'Please enter model' : null,
            ),
            10.height,
            Utils.dropdownBox(
              'Cohort',
              context.read<AddVehicleBloc>().cohort,
                (value)=>context.read<AddVehicleBloc>().add(CohortDropDownEvent(selectedCohort: value)),
              labelKey: 'cohort',
              initialSelection : context.read<AddVehicleBloc>().selectedCohort,
            ),
            10.height,
            Utils.getTextFormField(
              "Vin",context.read<AddVehicleBloc>().vinController,
            ),
            10.height,
            Utils.getTextFormField(
              "Vehicle Id",context.read<AddVehicleBloc>().vehicleIdController,
            ),
            10.height,
            CustomDateTimePicker<DateTime>(
              controller:
              context.read<AddVehicleBloc>().purchaseDateController,
              format: "MM-dd-yyyy",
              suffixIcon: Icon(Icons.calendar_month_rounded,
                  size: 18, color: context.theme.hintColor),
              textAlign: TextAlign.center,
              value: context.read<AddVehicleBloc>().selectedPurchaseDate,
              onChanged: (value) => context
                  .read<AddVehicleBloc>().add(DateChangeEvent(selectedDate: value)),
            ),
            10.height,
            Utils.getTextFormField(
              "Purchase Price",context.read<AddVehicleBloc>().purchasePriceController,
              autoValidate: AutovalidateMode.onUserInteraction,
              validator: (val) => val!.isEmpty ? 'Please enter purchasePrice' : null,
            ),
            10.height,
            ImageUploadSection(
              title: 'Upload Purchase Receipt',
              borderColor: Colors.grey,
              onUpload: () =>context.read<AddVehicleBloc>().add(PurchaseReceiptImageEvent()),
              onRemove: (file) => context.read<AddVehicleBloc>().add(RemovePurchaseReceiptImageEvent(data: file)),
              images: context.watch<AddVehicleBloc>().receiptImage,
              logName: "PurchaseReceiptImageEvent",
            ),
            10.height,
            ImageUploadSection(
              title: 'Upload Vehicle Image',
              borderColor: Colors.grey,
              onUpload: () => context.read<AddVehicleBloc>().add(VehicleImageEvent()),
              onRemove: (file) => context.read<AddVehicleBloc>().add(RemoveVehicleImageEvent(data: file)),
              images: context.watch<AddVehicleBloc>().vehicleImage,
              logName: "VehicleImageEvent",
            ),
            10.height,
            Utils.dropdownBox(
                'Select Branch',
                context.read<AddVehicleBloc>().branch,
                (value)=>context.read<AddVehicleBloc>().add(BranchDropDownEvent(selectedBranch: value)),
                labelKey: 'city',
              initialSelection: context.read<AddVehicleBloc>().selectedBranch,
            ),
            10.height,
            const AddVehicleMorePartOne(),
            10.height,
            GestureDetector(
              onTap: () =>
                  context.read<AddVehicleBloc>().add(AddVehicleShowMoreEvent()),
              child: Utils.getText(
                  '${context.watch<AddVehicleBloc>().showMore ? "Less" : "More"}...',
                  color: (context.watch<AddVehicleBloc>().showMore
                      ? Colors.lightBlue
                      : Colors.lightGreen)
                      .shade800),
            ),
            10.height,
            Row(
              children: [
                SuccessButton(text: "Save", onPressed: () => context.read<AddVehicleBloc>().add(SaveNewVehicleEvent())),
                const Spacer(flex: 1),
                (searchChild ?? const SizedBox.shrink()),
              ],
            ),
            // Utils.getElevatedButton(() {
            //   if (context.read<AddVehicleBloc>().formKey.currentState?.validate() ?? false) {
            //     context.read<AddVehicleBloc>().add(SaveNewVehicleEvent());
            //   }
            // }),
          ],
        ),
      ),
    );
  }
}
