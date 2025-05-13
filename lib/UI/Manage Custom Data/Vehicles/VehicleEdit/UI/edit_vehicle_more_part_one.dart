
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/Bloc/edit_vehicle_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/UI/edit_vehicle_more_part_two.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/checkbox_with_text.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/formatter/upper_case_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class EditVehicleMorePartOne extends StatelessWidget {
  const EditVehicleMorePartOne({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditVehicleBloc, EditVehicleState>(
      builder: (context, state) => Visibility(
          visible: context.watch<EditVehicleBloc>().showMore,
          child: Column(
            children: [
              Utils.getTextFormField(
                "Earnings",context.read<EditVehicleBloc>().earningsController,
              ),
              10.height,
              Utils.getTextFormField(
                "Utilization Rate",context.read<EditVehicleBloc>().utilizationRateController,
              ),
              10.height,
              Utils.getTextFormField(
                "Platform",context.read<EditVehicleBloc>().platformController,
              ),
              10.height,
              Utils.getTextFormField(
                "Mileage",context.read<EditVehicleBloc>().mileageController,
              ),
              10.height,
              Utils.getTextFormField(
                "Whole Sale Amount",context.read<EditVehicleBloc>().wholeSaleAmountController,
                textType: TextInputType.number,
                textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
              ),
              10.height,
              Utils.dropdownBox('Select Vehicle Status', context.read<EditVehicleBloc>().vehicleStatus, (value) => context.read<EditVehicleBloc>().add(VehicleStatusDropDownEvent(model: value)), labelKey: 'category_name',initialSelection: context.read<EditVehicleBloc>().selectedVehicleStatus),
              10.height,
              Utils.dropdownBox('Select Active Status', context.read<EditVehicleBloc>().activeStatus, (value) => context.read<EditVehicleBloc>().add(VehicleStatusDropDownEvent(model: value)), labelKey: 'category_name',initialSelection: context.read<EditVehicleBloc>().selectedActiveStatus),
              10.height,
              Utils.getTextFormField(
                'Address',context.read<EditVehicleBloc>().addressController,
                minLines: 3,
                maxLines: 3,
              ),
              10.height,
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckBoxWithText(
                            value: context.read<EditVehicleBloc>().bouncie,
                            onChanged: (_) => context.read<EditVehicleBloc>().add(BouncieEvent()),
                            label: 'Bouncie',
                          ),
                          10.height,
                          CheckBoxWithText(
                            value: context.read<EditVehicleBloc>().tollTags,
                            onChanged: (_) => context.read<EditVehicleBloc>().add(TollTagsEvent()),
                            label: 'Toll Tags',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckBoxWithText(
                            value: context.read<EditVehicleBloc>().airTag,
                            onChanged: (_) => context.read<EditVehicleBloc>().add(AirTagEvent()),
                            label: 'Air Tag',
                          ),
                          10.height,
                          CheckBoxWithText(
                            value: context.read<EditVehicleBloc>().spareTire,
                            onChanged: (_) => context.read<EditVehicleBloc>().add(SpareTireEvent()),
                            label: 'Spare Tires',
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
              10.height,
              Visibility(
                  visible: context.read<EditVehicleBloc>().tollTags || context.read<EditVehicleBloc>().spareTire,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Visibility(
                          visible: context.read<EditVehicleBloc>().tollTags,
                          child: Column(
                            children: [
                              Utils.getTextFormField(
                                'Toll Tags',context.read<EditVehicleBloc>().tollTagsController,
                              ),
                              10.height,
                              ImageUploadSection(
                                title: 'Toll Image',
                                borderColor: Colors.grey,
                                onUpload: () =>context.read<EditVehicleBloc>().add(TollImageEvent()),
                                onRemove: (file) => context.read<EditVehicleBloc>().add(RemoveTollImageEvent(data: file)),
                                images: context.watch<EditVehicleBloc>().tollImage,
                                logName: "TollImageEvent",
                              ),
                            ],
                          ),
                        ),
                      ),
                      10.width,
                      Expanded(
                        child: Visibility(
                            visible: context.read<EditVehicleBloc>().spareTire,
                            child:Utils.getTextFormField(
                              'e.g.,T165/70D18',
                              context.read<EditVehicleBloc>().spareTireController,
                              textType: TextInputType.text,
                                textCapitalization : TextCapitalization.characters,
                                textInputFormatter: [UpperCaseFormatter()],
                              autoValidate: AutovalidateMode.onUserInteraction,
                                validator: (value){
                                  final reg = RegExp(r'^[A-Z]?\d{3}/\d{2}[A-Z]\d{2}$');
                                  if(value!.isNotEmpty){
                                    if (!reg.hasMatch(value)) {
                                      return 'T165/70D18';
                                    }
                                  }
                                  return null;
                                }
                            ) ),
                      ),
                    ],
                  )
              ),
              CheckBoxWithText(
                value: context.read<EditVehicleBloc>().spareKey,
                onChanged: (_) => context.read<EditVehicleBloc>().add(SpareKeyEvent()),
                label: 'Spare Key',
              ),
              10.height,
              Row(
                children: [
                  Expanded(
                    child: CheckBoxWithText(
                      value: context.read<EditVehicleBloc>().permanentPlate,
                      onChanged: (_) => context.read<EditVehicleBloc>().add(PermanentPlateEvent()),
                      label: 'Permanent Plate',
                    ),
                  ),
                  Expanded(
                    child: Visibility(
                      visible: context.read<EditVehicleBloc>().permanentPlate,
                      child: CheckBoxWithText(
                        value: context.read<EditVehicleBloc>().frontLicensePlate,
                        onChanged: (_) => context.read<EditVehicleBloc>().add(FrontLicensePlateEvent()),
                        label: 'Front License Plate',
                      ),
                    ),
                  ),
                ],
              ),
              10.height,
              const EditVehicleMoreTwo(),
            ],
          )
      ),
    );
  }
}
