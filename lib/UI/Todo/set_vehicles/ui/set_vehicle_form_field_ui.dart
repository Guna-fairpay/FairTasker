part of 'set_vehicles_main_ui.dart';

class SetVehicleFormFieldUI extends StatelessWidget {
  const SetVehicleFormFieldUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetVehiclesBloc, SetVehiclesState>(
      builder: (context, state) => SafeArea(
        minimum: 10.verticalPadding,
          child: Form(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Utils.getText(context.watch<SetVehiclesBloc>().vehicle?['vehicle_name'] ?? '', weight: FontWeight.w900),
                  10.height,
                  Utils.getTextFormField(
                    'Address',context.read<SetVehiclesBloc>().addressController,
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
                                value: context.read<SetVehiclesBloc>().bouncie,
                                onChanged: (_) => context.read<SetVehiclesBloc>().add(BouncieEvent()),
                                label: 'Bouncie',
                              ),
                              10.height,
                              CheckBoxWithText(
                                value: context.read<SetVehiclesBloc>().tollTags,
                                onChanged: (_) => context.read<SetVehiclesBloc>().add(TollTagsEvent()),
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
                                value: context.read<SetVehiclesBloc>().airTag,
                                onChanged: (_) => context.read<SetVehiclesBloc>().add(AirTagEvent()),
                                label: 'Air Tag',
                              ),
                              10.height,
                              CheckBoxWithText(
                                value: context.read<SetVehiclesBloc>().spareTire,
                                onChanged: (_) => context.read<SetVehiclesBloc>().add(SpareTireEvent()),
                                label: 'Spare Tires',
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                  10.height,
                  Visibility(
                      visible: context.read<SetVehiclesBloc>().tollTags || context.read<SetVehiclesBloc>().spareTire,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Visibility(
                              visible: context.read<SetVehiclesBloc>().tollTags,
                              child: Column(
                                children: [
                                  Utils.getTextFormField(
                                    'Toll Tags',context.read<SetVehiclesBloc>().tollTagsController,
                                  ),
                                  10.height,
                                  ImageUploadSection(
                                    title: 'Toll Image',
                                    borderColor: Colors.grey,
                                    onUpload: () =>context.read<SetVehiclesBloc>().add(TollImageEvent()),
                                    onRemove: (file) => context.read<SetVehiclesBloc>().add(RemoveTollImageEvent(data: file)),
                                    images: context.watch<SetVehiclesBloc>().tollImage,
                                    logName: "TollImageEvent",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          10.width,
                          Expanded(
                            child: Visibility(
                                visible: context.read<SetVehiclesBloc>().spareTire,
                                child:Utils.getTextFormField(
                                    'e.g.,T165/70D18',
                                    context.read<SetVehiclesBloc>().spareTireController,
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
                    value: context.read<SetVehiclesBloc>().spareKey,
                    onChanged: (_) => context.read<SetVehiclesBloc>().add(SpareKeyEvent()),
                    label: 'Spare Key',
                  ),
                  10.height,
                  Row(
                    children: [
                      Expanded(
                        child: CheckBoxWithText(
                          value: context.read<SetVehiclesBloc>().permanentPlate,
                          onChanged: (_) => context.read<SetVehiclesBloc>().add(PermanentPlateEvent()),
                          label: 'Permanent Plate',
                        ),
                      ),
                      Expanded(
                        child: Visibility(
                          visible: context.read<SetVehiclesBloc>().permanentPlate,
                          child: CheckBoxWithText(
                            value: context.read<SetVehiclesBloc>().frontLicensePlate,
                            onChanged: (_) => context.read<SetVehiclesBloc>().add(FrontLicensePlateEvent()),
                            label: 'Front License Plate',
                          ),
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
                        child: ImageUploadSection(
                          title: 'Upload Tire Image',
                          borderColor: Colors.grey,
                          onUpload: () =>context.read<SetVehiclesBloc>().add(TireImageEvent()),
                          onRemove: (file) => context.read<SetVehiclesBloc>().add(RemoveTireImageEvent(data: file)),
                          images: context.watch<SetVehiclesBloc>().tireImage,
                          logName: "TireImageEvent",
                        ),
                      ),
                      Expanded(
                        child: Utils.getTextFormField(
                          'Number Plate',
                          context.read<SetVehiclesBloc>().numberPlateController,
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
                            Utils.getTextFormField("Car Number", context.read<SetVehiclesBloc>().carNumberController,
                              textType: TextInputType.number,
                              textInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],),
                            Utils.getTextFormField(
                                "Front tire e.g., 215/55R17",
                                context.read<SetVehiclesBloc>().frontTireController,
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
                            Utils.getTextFormField("Oil Grade", context.read<SetVehiclesBloc>().oilGradeController),
                            Utils.getTextFormField(
                                "Rear tire e.g., 215/55R17",
                                context.read<SetVehiclesBloc>().rearTireController,
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
                              context.read<SetVehiclesBloc>().renewalDateController,
                              format: "MM-dd-yyyy",
                              padding: 8.spMin.padding,
                              suffixIcon: Icon(Icons.calendar_month_rounded,
                                  size: 18, color: context.theme.hintColor),
                              textAlign: TextAlign.start,
                              value: context.read<SetVehiclesBloc>().selectedRegStickerDate,
                              onChanged: (value) => context
                                  .read<SetVehiclesBloc>().add(RegStickerDateEvent(selectedDate: value)),
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
                              onUpload: () =>context.read<SetVehiclesBloc>().add(UploadRegStickerImageEvent()),
                              onRemove: (file) => context.read<SetVehiclesBloc>().add(RemoveRegStickerImageEvent(data: file)),
                              images: context.watch<SetVehiclesBloc>().uploadRegSticker,
                              logName: "UploadRegStickerImageEvent",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //10.height,
                  Row(
                    spacing: 10 ,
                    children: [
                      Expanded(child: Utils.getTextFormField("Insurance Agent", context.read<SetVehiclesBloc>().insuranceAgentController),),
                      Expanded(child: Utils.getTextFormField("Insurance Cost", context.read<SetVehiclesBloc>().insuranceCostController,
                        textType: const TextInputType.numberWithOptions(decimal: true),
                        textInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      ),),
                    ],
                  ),
                  10.height,
                  ImageUploadSection(
                    title: 'Insurance Image',
                    borderColor: Colors.grey,
                    onUpload: () =>context.read<SetVehiclesBloc>().add(InsuranceImageEvent()),
                    onRemove: (file) => context.read<SetVehiclesBloc>().add(RemoveInsuranceImageEvent(data: file)),
                    images: context.watch<SetVehiclesBloc>().insuranceImage,
                    logName: "InsuranceImageEvent",
                  ),
                  10.height,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SuccessButton(
                      text: 'Save',
                      onPressed:()=> context.read<SetVehiclesBloc>().add(SaveVehicle()),
                    ),
                  ),
                ],
              ),
          ),
      ),
    );
  }
}
