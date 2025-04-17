
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/AddPrivateRental/Bloc/add_private_rental_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/AddPrivateRental/Bloc/add_private_rental_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/AddPrivateRental/Bloc/add_private_rental_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPrivateRentalBody extends StatelessWidget {
  final Widget? searchChild;
  const AddPrivateRentalBody({super.key, this.searchChild});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPrivateRentalBloc, AddPrivateRentalState>(
        builder: (context, state) => ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            10.height,
            SearchViewField(
              controller: context.read<AddPrivateRentalBloc>().vehicleController,
              suggestions: context.read<AddPrivateRentalBloc>().vehicleList,
              itemAsString: (item) => (item as Map<String, dynamic>)['vehicle_name'] ?? '',
              onSelected: (value) => context.read<AddPrivateRentalBloc>().add(VehicleSearchEvent(selectedVehicle: value)),
              selectedItem: (context.read<AddPrivateRentalBloc>().selectedVehicle.isEmpty) ? null : context.read<AddPrivateRentalBloc>().selectedVehicle,
              showEmpty: false,
              labelText: 'Vehicle',
              hintText: "Select Vehicle",
            ),
            10.height,
            SearchViewField(
              controller: context.read<AddPrivateRentalBloc>().customerController,
              suggestions: context.read<AddPrivateRentalBloc>().customerList,
              itemAsString: (item) => (item as Map<String, dynamic>)['customer_name']?? '',
              onSelected: (value) => context.read<AddPrivateRentalBloc>().add(CustomerSearchEvent(selectedCustomer: value)),
              selectedItem: (context.read<AddPrivateRentalBloc>().selectedCustomer.isEmpty) ? null : context.read<AddPrivateRentalBloc>().selectedCustomer,
              showEmpty: false,
              labelText: 'Customer',
              hintText: "Select Customer",
            ),
            10.height,
            Utils.getText('CheckIn Date',weight: FontWeight.bold),
            5.height,
            CustomDateTimePicker<DateTime>(
              controller: context.read<AddPrivateRentalBloc>().checkInController,
              format: "dd-MM-yyyy",
              labelText: "dd-MM-yyyy",
              suffixIcon: Icon(Icons.calendar_month_rounded,
                  size: 18, color: context.theme.hintColor),
              textAlign: TextAlign.center,
              value: context.read<AddPrivateRentalBloc>().selectedCheckInDate,
              onChanged: (value) => context
                  .read<AddPrivateRentalBloc>()
                  .add(CheckInDateEvent(selectedDate: value)),
            ),
            10.height,
            Utils.getText('CheckOut Date',weight: FontWeight.bold),
            5.height,
            CustomDateTimePicker<DateTime>(
              controller: context.read<AddPrivateRentalBloc>().checkOutController,
              format: "dd-MM-yyyy",
              labelText: "dd-MM-yyyy",
              suffixIcon: Icon(Icons.calendar_month_rounded,
                  size: 18, color: context.theme.hintColor),
              textAlign: TextAlign.center,
              value: context.read<AddPrivateRentalBloc>().selectedCheckOutDate,
              onChanged: (value) => context
                  .read<AddPrivateRentalBloc>()
                  .add(CheckOutDateEvent(selectedDate: value)),
            ),
            10.height,
            Utils.getTextFormField("CheckIn Mileage", context.read<AddPrivateRentalBloc>().checkInMileageController,textType: TextInputType.number,),
            10.height,
            Utils.getTextFormField("CheckOut Mileage", context.read<AddPrivateRentalBloc>().checkOutMileageController,textType: TextInputType.number,),
            10.height,
            Utils.dropdownBox(
              'Validation',
              context.read<AddPrivateRentalBloc>().validation,
                  (value) => context.read<AddPrivateRentalBloc>().add(ValidationDropDownEvent(validation: value)),
              initialSelection:  context.read<AddPrivateRentalBloc>().selectedStatus, labelKey: 'status',),
            10.height,
            ImageUploadSection(
              title: 'Choose Files',
              borderColor: Colors.blue,
              onUpload: () =>context.read<AddPrivateRentalBloc>().add(ImageUploadEvent()),
              onRemove: (file) => context.read<AddPrivateRentalBloc>().add(RemoveImageEvent(data: file)),
              images: context.watch<AddPrivateRentalBloc>().attachment,
              logName: "ImageUploadEvent",
            ),
            10.height,
            Row(
              children: [
                SuccessButton(
                  text: "Save",
                  onPressed: () => context.read<AddPrivateRentalBloc>().add(AddPrivateRentalSubmitEvent()),
                ),
                const Spacer(flex: 1),
                (searchChild ?? const SizedBox.shrink())
              ],
            ),
          ],
        )
    );
  }
}
