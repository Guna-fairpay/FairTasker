part of '../tasker_create_todo.dart';

class MainForm extends StatelessWidget {
  const MainForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(builder: (context, state) => Column(
      spacing: 10.spMin,
      children: [
        SegmentedAutocomplete<Map<String, dynamic>>(
            segmentedSuggestions: context.watch<AddToDoBloc>().taskIdentifierList,
            itemAsString: (option) => (option.containsKey("subname")) ? "${option['name']} (${option['subname']})" : option['name'],
            itemAsStringTitle: (option) => option?['name'] ?? "",
            itemAsSearchString: (option) => option?['searchBy'] ?? [],
            selectedValues: List<Map<String, dynamic>>.from(context.watch<AddToDoBloc>().selectedTaskIdentifier.values.toList()),
            onChanged: (val) => context.read<AddToDoBloc>().add(IdentifierEvent(val)),
        ),
        CompactTextField(hintText: "Task Name", controller: context.read<AddToDoBloc>().taskNameController,
          validator: (value) => (value?.trim().isNullOrEmpty ?? false) ? "Task Name is required" : null,
        ),
        if (context.watch<AddToDoBloc>().isMeeting)
          CompactDropDown<Map<String, dynamic>>(
            items: ToDoConfig.meetingMode,
            initialSelection: context.watch<AddToDoBloc>().selectedMeetingMode,
            itemAsString: (item) => item['name'] ?? "",
            onChanged: (value) => context.read<AddToDoBloc>().add(MeetingEvent(value)),
          ),
        if (context.watch<AddToDoBloc>().isLeadTask)
        CompactSingleChannelField<Map<String, dynamic>>(
          items: context.watch<AddToDoBloc>().leads,
          itemAsString: (item) => item['customer_name'] ?? "",
          controller: context.read<AddToDoBloc>().leadController,
          selected: context.watch<AddToDoBloc>().selectedLead,
          labelText: "Lead/Channel",
          onSelected: (value) => context.read<AddToDoBloc>().add(LeadEvent(value)),
        ),
        if (!context.watch<AddToDoBloc>().isMeeting)
        CustomVehiclePersonField(
            vehiclesList: context.watch<AddToDoBloc>().vehicles,
            personsList: context.watch<AddToDoBloc>().persons,
            groupVehicles: context.watch<AddToDoBloc>().groupVehicleList,
            selected: context.watch<AddToDoBloc>().selectedVPerson,
            onSelected: (val) => context.read<AddToDoBloc>().add(VehiclePersonEvent(val)),
            controller: context.read<AddToDoBloc>().vehicleController,
        ),
        if (context.watch<AddToDoBloc>().isRentalTask)
        CustomVendorLocationField(
            vendorsList: context.watch<AddToDoBloc>().vendors,
            locationsList: context.watch<AddToDoBloc>().locations,
            selected: context.watch<AddToDoBloc>().selectedTaskIdentifier,
            onCleared: (val) => context.read<AddToDoBloc>().add(ClearVLEvent()),
            onSelected: (val) => context.read<AddToDoBloc>().add(VendorLocationEvent(val)),
            controller: context.read<AddToDoBloc>().vendorController
        ),
        CompactTextField(hintText: "Notes", controller: context.read<AddToDoBloc>().notesController),
        if (context.watch<AddToDoBloc>().hasEnquiry)
          CustomQuillEditor(controller: context.read<AddToDoBloc>().enquiryController),
      ],
    ));
  }
}
