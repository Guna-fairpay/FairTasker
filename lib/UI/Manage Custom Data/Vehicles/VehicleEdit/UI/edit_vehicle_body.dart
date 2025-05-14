
import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/UI/edit_vehicle_more_part_one.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class EditVehicleBody extends StatelessWidget {
  final dynamic vehicleData;
  final Widget? searchChild;
  final VoidCallback? onClear;
  const EditVehicleBody({super.key, required this.vehicleData, this.searchChild, this.onClear});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditVehicleBloc, EditVehicleState>(
      builder: (context, state) => Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: context.watch<EditVehicleBloc>().formKey,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            if (context.read<EditVehicleBloc>().vehicleImage.isNotEmpty)
              SizedBox(
                height: 200,
                child: FittedBox(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
                        color: AppC.grey.withValues(alpha: 0.2)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: ImageViewer(
                      fit: BoxFit.contain,
                      imageInput: context.read<EditVehicleBloc>().vehicleImage[0] ?? {},
                      isNotImage: !(context.read<EditVehicleBloc>().vehicleImage[0] as Object).isImage,
                    ),
                  ),
                ),
              ),
            10.height,
            Utils.getTextFormField(
              "Year",
              context.read<EditVehicleBloc>().yearController,
              autoValidate: context.watch<EditVehicleBloc>().autoValidateMode,
              validator: (val) => val!.isEmpty ? 'Please enter year' : null,
              textType: TextInputType.number,
              textInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}'))],
            ),
            10.height,
            Utils.getTextFormField(
              "Make",
              context.read<EditVehicleBloc>().makeController,
              autoValidate: context.watch<EditVehicleBloc>().autoValidateMode,
              validator: (val) => val!.isEmpty ? 'Please enter make' : null,
            ),
            10.height,
            Utils.getTextFormField(
              "Model",
              context.read<EditVehicleBloc>().modelController,
              autoValidate: context.watch<EditVehicleBloc>().autoValidateMode,
              validator: (val) => val!.isEmpty ? 'Please enter model' : null,
            ),
            10.height,
            Utils.dropdownBox(
              'Cohort',
              context.read<EditVehicleBloc>().cohort,
              (value) => context.read<EditVehicleBloc>().add(CohortDropDownEvent(selectedCohort: value)),
              labelKey: 'cohort',
              initialSelection: context.read<EditVehicleBloc>().selectedCohort,
            ),
            10.height,
            Utils.getTextFormField(
              "Vin",
              context.read<EditVehicleBloc>().vinController,
              readOnly: true,
              fillColor: Colors.grey.shade200,
            ),
            10.height,
            Utils.getTextFormField(
              "Vehicle Id",
              context.read<EditVehicleBloc>().vehicleIdController,
                textType: TextInputType.number,
                textInputFormatter: [FilteringTextInputFormatter.digitsOnly]
            ),
            10.height,
            CustomDateTimePicker<DateTime>(
              controller: context.read<EditVehicleBloc>().purchaseDateController,
              format: "MM-dd-yyyy",
              suffixIcon: Icon(Icons.calendar_month_rounded, size: 18, color: context.theme.hintColor),
              textAlign: TextAlign.center,
              labelText: "dd-mm-yyyy",
              validator: (value) => (value == null) ? "Please select date" : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              value: context.read<EditVehicleBloc>().selectedPurchaseDate,
              onChanged: (value) => context.read<EditVehicleBloc>().add(DateChangeEvent(selectedDate: value)),
            ),
            10.height,
            Utils.getTextFormField(
              "Purchase Price",
              context.read<EditVehicleBloc>().purchasePriceController,
              textType: TextInputType.number,
              textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
              autoValidate: context.watch<EditVehicleBloc>().autoValidateMode,
              validator: (val) => val!.isEmpty ? 'Please enter purchasePrice' : null,
            ),
            10.height,
            ImageUploadSection(
              title: 'Upload Purchase Receipt',
              borderColor: Colors.grey,
              onUpload: () => context.read<EditVehicleBloc>().add(PurchaseReceiptImageEvent()),
              onRemove: (file) => context.read<EditVehicleBloc>().add(RemovePurchaseReceiptImageEvent(data: file)),
              images: context.watch<EditVehicleBloc>().receiptImage,
              logName: "PurchaseReceiptImageEvent",
            ),
            10.height,
            ImageUploadSection(
              title: 'Upload Vehicle Image',
              borderColor: Colors.grey,
              onUpload: () => context.read<EditVehicleBloc>().add(VehicleImageEvent()),
              onRemove: (file) => context.read<EditVehicleBloc>().add(RemoveVehicleImageEvent(data: file)),
              images: context.watch<EditVehicleBloc>().vehicleImage,
              logName: "VehicleImageEvent",
            ),
            10.height,
            Utils.dropdownBox(
              'Select Branch',
              context.read<EditVehicleBloc>().branch,
              (value) => context.read<EditVehicleBloc>().add(BranchDropDownEvent(selectedBranch: value)),
              labelKey: 'city',
              initialSelection: context.read<EditVehicleBloc>().selectedBranch,
            ),
            10.height,
            const EditVehicleMorePartOne(),
            10.height,
            GestureDetector(
              onTap: () => context.read<EditVehicleBloc>().add(AddVehicleShowMoreEvent()),
              child: Utils.getText('${context.watch<EditVehicleBloc>().showMore ? "Less" : "More"}...',
                  color: (context.watch<EditVehicleBloc>().showMore
                      ? Colors.lightBlue
                      : Colors.lightGreen).shade800),
            ),
            10.height,
            Row(
              spacing: 5,
              children: [
                CompactIconButton(icon: Icons.save_rounded,
                    backgroundColor: AppC.green,
                    onPressed: () => context.read<EditVehicleBloc>().add(SaveUpdatedVehicle(data: vehicleData))),
                CompactIconButton(icon: Icons.clear_rounded,
                    backgroundColor: AppC.red,
                    onPressed: onClear),
                const Spacer(flex: 1),
                (searchChild ?? const SizedBox.shrink()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
