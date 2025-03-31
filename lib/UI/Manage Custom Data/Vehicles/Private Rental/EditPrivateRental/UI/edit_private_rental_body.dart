
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/EditPrivateRental/Bloc/edit_private_rental_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPrivateRentalBody extends StatelessWidget {
  const EditPrivateRentalBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditPrivateRentalBloc, EditPrivateRentalState>(
        builder: (context, state) => SafeArea(
          minimum: 10.padding,
          child: ListView(
            children: [
              10.height,
              SearchViewField(
                controller: context.read<EditPrivateRentalBloc>().vehicleController,
                suggestions: context.read<EditPrivateRentalBloc>().vehicleList,
                itemAsString: (item) => (item as Map<String, dynamic>)['vehicle_name'] ?? '',
                onSelected: (value) => context.read<EditPrivateRentalBloc>().add(VehicleSearchEvent(selectedVehicle: value)),
                selectedItem: (context.read<EditPrivateRentalBloc>().selectedVehicle.isEmpty) ? null : context.read<EditPrivateRentalBloc>().selectedVehicle,
                showEmpty: false,
                labelText: 'Vehicle',
                hintText: "Select Vehicle",
              ),
              10.height,
              SearchViewField(
                controller: context.read<EditPrivateRentalBloc>().customerController,
                suggestions: context.read<EditPrivateRentalBloc>().customerList,
                itemAsString: (item) => (item as Map<String, dynamic>)['customer_name']?? '',
                onSelected: (value) => context.read<EditPrivateRentalBloc>().add(CustomerSearchEvent(selectedCustomer: value)),
                selectedItem: (context.read<EditPrivateRentalBloc>().selectedCustomer.isEmpty) ? null : context.read<EditPrivateRentalBloc>().selectedCustomer,
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
              Utils.getElevatedButton(() => context.read<EditPrivateRentalBloc>().add(EditPrivateRentalSubmitEvent())),
            ],
          ),
        )
    );
  }
}
