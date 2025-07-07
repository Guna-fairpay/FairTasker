part of '../tasker_create_todo.dart';

class MainForm extends StatelessWidget {
  const MainForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(builder: (context, state) => Column(
      spacing: 10.spMin,
      children: [
        TaskIdentifier(
            taskIdentifierController: context.read<AddToDoBloc>().identifierController,
            location: getIt<CommonService>().locationsList,
            persons: getIt<CommonService>().resourcesList,
            tasks: getIt<CommonService>().taskExpenseDataList,
            vehicles: getIt<CommonService>().activeVehicleList,
            gVehicles: getIt<CommonService>().groupVehicleList,
            vendors: getIt<CommonService>().vendorsList,
            selected: context.watch<AddToDoBloc>().selectedTaskIdentifier,
            onSelected: (val) => context.read<AddToDoBloc>().add(IdentifierEvent(val)),
        ),
        CompactTextField(hintText: "Task Name", controller: context.read<AddToDoBloc>().taskNameController),
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
            vehiclesList: getIt<CommonService>().activeVehicleList,
            personsList: getIt<CommonService>().resourcesList,
            groupVehicles: getIt<CommonService>().groupVehicleList,
            selected: context.watch<AddToDoBloc>().selectedVPerson,
            onSelected: (val) => context.read<AddToDoBloc>().add(VehiclePersonEvent(val)),
            controller: context.read<AddToDoBloc>().vehicleController
        ),
        if (context.watch<AddToDoBloc>().isRentalTask)
        CustomVendorLocationField(
            vendorsList: getIt<CommonService>().vendorsList,
            locationsList: getIt<CommonService>().locationsList,
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
