part of 'edit_todo_ui.dart';

class EditTodoMoreForm extends StatelessWidget {
  const EditTodoMoreForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditToDoBloc, EditTodoState>(
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 10,
        children: [
          if (state.selectedVLocations['type'] == 'location' && (state.isMoreEnable))
            SearchViewField<Map<String, dynamic>>(
                suggestions: List.from(state.selectedVLocations['value']['addresses'] ?? []),
                selectedItem: state.addresses.lastOrNull,
                controller: TextEditingController(),
                labelText: "Address",
                onCleared: (val) => context
                    .read<EditToDoBloc>()
                    .add(EditToDoAddressSelectionEvent(val, false)),
                onSelected: (value) => context
                    .read<EditToDoBloc>()
                    .add(EditToDoAddressSelectionEvent(value, true)),
                itemAsString: (item) => item['address'].toString()),
          if (state.isMoreEnable)
            Row(
              spacing: 10,
              children: [
                Utils.getCircleCheckWidget(
                    () => context
                        .read<EditToDoBloc>()
                        .add(EditToDoShowPartsEvent()),
                    state.isPartServiceEnable,
                    'Parts/Services'),
                Utils.getCircleCheckWidget(
                    () => context
                        .read<EditToDoBloc>()
                        .add(EditToDoShowSuppliesEvent()),
                    state.isSuppliesEnable,
                    'Supplies'),
                if (state.showCleanCar && (DateTime.now().compareTo(state.selectedDate??DateTime.now()) == 1))
                  IconButton(
                    onPressed: () => context.read<EditToDoBloc>().cleanCarIsActive? context.read<EditToDoBloc>().add(EditToDoCleanCarEvent()):null,
                    icon:  Icon(Icons.local_car_wash_sharp,color: context.watch<EditToDoBloc>().cleanCarIsActive?AppC.green:AppC.redAccent,),
                    style: ButtonStyle(
                        shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: context.watch<EditToDoBloc>().cleanCarIsActive?AppC.green:AppC.redAccent, width: 1)))),
                  ),
                if (state.showCleanCar && (DateTime.now().compareTo(state.selectedDate??DateTime.now()) == 1))
                  Flexible(
                    child: Utils.dropdownBox(
                        'Clean Car Duration',
                        state.clearDurations,
                            (value) => context.read<EditToDoBloc>().add(EditToDoCleanCarDuration(value)),
                        labelKey:'value',
                        initialSelection: state.selectedClearDuration,
                    ),
                  )
              ],
            ),
          if (state.isMoreEnable && state.isPartServiceEnable)
            CustomMultiSelectionChipsField<Map<String, dynamic>>(
                selectedPartsList: List.from(state.selectedParts),
                suggestionsList: context.watch<EditToDoBloc>().partsList,
                controller: context.read<EditToDoBloc>().partsController,
                labelText: "Parts",

                itemAsString: (item) => item['name'].toString(),
                onChanged: (isChecked, value) => context
                    .read<EditToDoBloc>()
                    .add(EditToDoPartSelectionEvent(isChecked, value)),
                onEmptyTap: () =>
                    context.push( PartsMainUI(title: context.read<EditToDoBloc>().partsController.text,), fullscreenDialog: true)),
          if (state.isMoreEnable && state.isSuppliesEnable)
            CustomMultiSelectionChipsField<Map<String, dynamic>>(
                selectedPartsList: List.from(state.selectedSupplies),
                suggestionsList: context.watch<EditToDoBloc>().suppliesLists,
                controller: context.read<EditToDoBloc>().suppliesController,
                labelText: "Supplies",
                onChanged: (isChecked, value) => context
                    .read<EditToDoBloc>()
                    .add(EditToDoSupplySelectionEvent(isChecked, value)),
                itemAsString: (item) => item['name'].toString(),
                onEmptyTap: () => context.push(SuppliesMainUI(title: context.read<EditToDoBloc>().suppliesController.text),
                    fullscreenDialog: true)
            ),
          if (state.showPlatformCheck ||Str.platFormCheckIds.contains(state.selectedTask['id']))
            Utils.getCircleCheckWidget(() => context.read<EditToDoBloc>().add(EditToDoPlatformCheckEvent()),
                state.isSelectedPlatformCheck,
                'Platform Check'),
          if (state.isMoreEnable && (Str.completedOdometer.contains(state.apiResponse['title'])))
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              Expanded(child: Utils.getTextFormField("Trip driven miles", context.read<EditToDoBloc>().tripDrivenController,)),
              Expanded(
                child: Utils.dropdownBox(
                  "Selected Sentiments",
                  state.sentiments,
                      (val)=>context.read<EditToDoBloc>().add(EditToDoSelectSentimentsEvent(val)),
                  labelKey: 'name',
                  initialSelection: state.selectedSentiment,
                ),
              ),
            ],
          ),
          Row(
            spacing: 10,
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () =>
                    context.read<EditToDoBloc>().add(EditToDoShowMoreEvent()),
                child: Utils.getText(
                  align: TextAlign.start,
                    '${state.isMoreEnable ? "Less" : "More"}...',
                    color: (state.isMoreEnable
                            ? Colors.lightBlue
                            : Colors.lightGreen)
                        .shade800),
              ),
              if(state.selectedTask['user_type'] != 4)
              Flexible(
                  child: Utils.dropdownBox(
                      'Select',
                      state.linkOptions,
                      (val) => context
                          .read<EditToDoBloc>()
                          .add(EditToDoSelectLinkOptionEvent(val)),
                      labelKey: 'label',
                      initialSelection: state.selectedLinkOption))
            ],
          ),
          if (state.selectedLinkOption != null && state.selectedTask['user_type'] != 4)
            Utils.getTextFormField("${state.selectedLinkOption?['label']}",
                context.read<EditToDoBloc>().customLinkController,
                inputAction: TextInputAction.done,
                isDense: true,
                borderRadius: Num.borderRadius,
                contentPadding: 10.padding,
                labelStyle: context.textTheme.labelMedium
                    ?.copyWith(color: context.theme.hintColor),
                style:
                    context.textTheme.labelLarge?.copyWith(fontFamily: "Lato")),
          // if ((Str.completedOdometer.contains(state.apiResponse['identifier_id'])
          //     && state.apiResponse['status']=="Completed")
          //     || (Str.unCompletedOdometer.contains(state.apiResponse['identifier_id'])))
           if(state.showOdometer)
            Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(state.previousOdometer.toString() != '0')
                RichText(text: TextSpan(
                  text: 'Previous Odometer : ',
                  style: context.textTheme.labelMedium?.copyWith(),
                  children: [
                    TextSpan(
                      text: state.previousOdometer,
                      style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
                Utils.getTextFormField(
                  'Odometer',
                  context.read<EditToDoBloc>().odometerController,
                  validator: (val) => ((val == null || val.isEmpty) /*|| double.tryParse(val) == 0*/)
                      ? "Please enter oil change odometer"
                      : null,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return null;
                  //   }
                  //   final inputValue = num.tryParse(value) ?? 0;
                  //   final minMileage = num.tryParse(state.previousOdometer) ?? 0;
                  //   return inputValue < minMileage
                  //       ? "Can't enter lower than previous oil change odometer"
                  //       : null;
                  // },
                  autoValidate: AutovalidateMode.onUserInteraction,
                  inputAction: TextInputAction.done,
                  textType: const TextInputType.numberWithOptions(decimal: true),
                  textInputFormatter:[FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                ),
              ],
            ),
          if(state.apiResponse['odour'] != null && state.apiResponse['status']=="Completed")
            Align(
                alignment: Alignment.centerLeft,
                child: Utils.getText(state.apiResponse['odour'] ?? '',
                    align: TextAlign.start,
                    color: const Color(0xffd01601))),
          if(state.apiResponse['clean_required'] != null /*&& state.apiResponse['status']=="Completed"*/)
            Align(
                alignment: Alignment.centerLeft,
                child: Utils.getText(
                    state.apiResponse['clean_required'] ?? '',
                    align: TextAlign.start,
                    color: const Color(0xffd01601)
                ),
            ),
          if(state.mileageImages.isNotEmpty)
            GestureDetector(
              onTap: (){
                ShowAttachmentsDialog.of.show(context,
                    attachments: state.mileageImages, title: "",
                    onDeleted: (data)=>context.read<EditToDoBloc>().add(RemoveMileageImageEvent(data:data))
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 5,
                children: [
                  Utils.getText('General Picture'),
                  Icon(Icons.remove_red_eye_outlined,size: 16.spMin,)
                ],
              ),
            ),
          if(state.notesImages.isNotEmpty)
            GestureDetector(
              onTap: (){
                ShowAttachmentsDialog.of.show(context,
                  attachments: state.notesImages, title: "",
                  onDeleted: (data)=>context.read<EditToDoBloc>().add(RemoveNotesImageEvent(data:data))
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 5,
                children: [
                  Utils.getText('Note attachments'),
                  Icon(Icons.remove_red_eye_outlined,size: 16.spMin,)
                ],
              ),
            ),
          if (state.selectedVehicle.isNotEmpty && state.taskHistory.length > 1)
            Utils.dropdownBox(
                "Select Vehicle Name",
                state.taskHistory,
                (val) => context
                    .read<EditToDoBloc>()
                    .add(EditToDoSelectTaskHistoryEvent(val)),
                labelKey: 'vehicle_name',
                initialSelection: state.selectedVehicle),
          if (state.selectedVPerson.isNotEmpty && state.selectedVPerson.firstOrNull?['type'] != 'person' )
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VehicleHistoryViewUI(
                        showSameTask: true,
                            title: state.apiResponse['title'],
                            vin: state.selectedVehicle['vin'],
                            vehicleName: state.selectedVehicle['vehicle_name'],
                            groupId: state.selectedVPerson.first['id'],
                          )
                  )
              );
            },
            child:
              Utils.getText(
                'Task History - ${state.selectedVPerson.length == 1 ? state.selectedVehicle['vehicle_name'] ?? state.selectedVPerson.first['name'] : state.selectedVehicle['vin'] ?? ''}',
                color: AppC.appColor,
                weight: FontWeight.w500,
              ),
          ),
          if (state.selectedLinkOption != null)
            ValueListenableBuilder(
              valueListenable:
              context.read<EditToDoBloc>().customLinkController,
              builder: (context, value, child) => value.text.isEmpty
                  ? Container()
                  : Text.rich(
                TextSpan(
                    text:
                    "${state.selectedLinkOption!['label'].toString().isCustomLink ? "Link" : "Reservation No"} - ${value.text}",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context
                          .read<EditToDoBloc>()
                          .add(EditToDoOpenCustomLinkEvent())),
                textAlign: TextAlign.end,
                style: context.textTheme.labelMedium?.copyWith(
                    color:[209,211].contains(state.apiResponse['identifier_id'])? AppC.green
                        :[210,212].contains(state.apiResponse['identifier_id'])? AppC.redAccent
                        : AppC.appColor,
                    fontSize: 12.spMin,
                    decoration: TextDecoration.underline,
                    decorationColor: AppC.appColor),
              ),
            ),
        ],
      ),
    );
  }
}
