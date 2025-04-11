import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPrivateRentalBody extends StatelessWidget {
  final Widget? searchChild;
  final VoidCallback? onClear;
  const EditPrivateRentalBody({super.key, this.searchChild, this.onClear});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditPrivateRentalBloc, EditPrivateRentalState>(
        builder: (context, state) => ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            10.height,
            SearchViewField<Map<String, dynamic>>(
              controller: context.read<EditPrivateRentalBloc>().vehicleController,
              suggestions: context.watch<EditPrivateRentalBloc>().vehicleList,
              itemAsString: (item) => (item)['vehicle_name'] ?? '',
              onSelected: (value) => context.read<EditPrivateRentalBloc>().add(VehicleSearchEvent(selectedVehicle: value)),
              selectedItem: context.watch<EditPrivateRentalBloc>().selectedVehicle,
              showEmpty: false,
              labelText: 'Vehicle',
              hintText: "Select Vehicle",
            ),
            10.height,
            SearchViewField<Map<String, dynamic>>(
              controller: context.read<EditPrivateRentalBloc>().customerController,
              suggestions: context.watch<EditPrivateRentalBloc>().customerList,
              itemAsString: (item) => (item)['customer_name']?? '',
              onSelected: (value) => context.read<EditPrivateRentalBloc>().add(CustomerSearchEvent(selectedCustomer: value)),
              selectedItem: context.watch<EditPrivateRentalBloc>().selectedCustomer,
              showEmpty: false,
              labelText: 'Customer',
              hintText: "Select Customer",
            ),
            10.height,
            Utils.getText('CheckIn Date',weight: FontWeight.bold),
            5.height,
            CustomDateTimePicker<DateTime>(
              controller: context.read<EditPrivateRentalBloc>().checkInController,
              format: "MM-dd-yyyy",
              suffixIcon: Icon(Icons.calendar_month_rounded,
                  size: 18, color: context.theme.hintColor),
              textAlign: TextAlign.center,
              value: context.read<EditPrivateRentalBloc>().selectedCheckInDate,
              onChanged: (value) => context
                  .read<EditPrivateRentalBloc>()
                  .add(CheckInDateEvent(selectedDate: value)),
            ),
            10.height,
            Utils.getText('CheckOut Date',weight: FontWeight.bold),
            5.height,
            CustomDateTimePicker<DateTime>(
              controller: context.read<EditPrivateRentalBloc>().checkOutController,
              format: "MM-dd-yyyy",
              suffixIcon: Icon(Icons.calendar_month_rounded,
                  size: 18, color: context.theme.hintColor),
              textAlign: TextAlign.center,
              value: context.read<EditPrivateRentalBloc>().selectedCheckOutDate,
              onChanged: (value) => context
                  .read<EditPrivateRentalBloc>()
                  .add(CheckOutDateEvent(selectedDate: value)),
            ),
            10.height,
            Utils.getTextFormField("CheckIn Mileage", context.read<EditPrivateRentalBloc>().checkInMileageController,textType: TextInputType.number,),
            10.height,
            Utils.getTextFormField("CheckOut Mileage", context.read<EditPrivateRentalBloc>().checkOutMileageController,textType: TextInputType.number,),
            10.height,
            Utils.dropdownBox(
              'Validation',
              context.read<EditPrivateRentalBloc>().validation,
                  (value) => context.read<EditPrivateRentalBloc>().add(ValidationDropDownEvent(validation: value)),
              initialSelection:  context.read<EditPrivateRentalBloc>().selectedStatus, labelKey: 'status',),
            10.height,
            ImageUploadSection(
              title: 'Choose Files',
              borderColor: Colors.blue,
              onUpload: () =>context.read<EditPrivateRentalBloc>().add(ImageUploadEvent()),
              onRemove: (file) => context.read<EditPrivateRentalBloc>().add(RemoveImageEvent(data: file)),
              images: context.watch<EditPrivateRentalBloc>().attachment,
              logName: "ImageUploadEvent",
            ),
            10.height,
            Row(
              spacing: 10,
              children: [
                SuccessButton(text: "Update", onPressed: () => context.read<EditPrivateRentalBloc>().add(EditPrivateRentalSubmitEvent())),
                SuccessButton(text: "Cancel", onPressed: onClear, backgroundColor: AppC.redAccent),
                const Spacer(flex: 1),
                (searchChild ?? const SizedBox.shrink())
              ],
            ),
          ],
        )
    );
  }
}
