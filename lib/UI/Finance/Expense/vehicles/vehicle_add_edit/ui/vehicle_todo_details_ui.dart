part of 'vehicle_add_edit_main_ui.dart';

class VehicleTodoDetailsUI extends StatelessWidget {
  const VehicleTodoDetailsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleAddEditBloc, VehicleAddEditState>(
        builder: (context, state) {
          var item = context.read<VehicleAddEditBloc>().todoItems;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utils.getText("TODO DETAILS", weight: FontWeight.bold,size: 16.spMin,),
              10.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconAndText(
                    onTap: ()=> context.read<VehicleAddEditBloc>().add(TodoDetailsEvent()),
                    icon: Icons.subtitles_sharp,
                    label: "${item['title'] ?? ''}",
                    labelColor: AppC.appColor,
                ),
              IconAndText(
                  icon: Icons.date_range,
                  label: "${item['todo_date'].toString().toDateTime()?.toFormat(format: "MM-dd-yyyy") ?? ''}  "
                      "${item['todo_time'].toString().toFormat(inputFormat: 'HH:mm:ss', format: 'hh:mm a') ?? ''}",
              ),
              IconAndText(
                icon: Icons.person,
                label: (context.read<VehicleAddEditBloc>().userNameList ?? []).join(','),
              ),
              IconAndText(
                icon: Icons.directions_car_filled,
                label: context.read<VehicleAddEditBloc>().vehicleNameList.join(','),
              ),
              if (item['vendor_name'] != null)
                IconAndText(
                  icon: Icons.person_pin_outlined,
                  label: "${item['vendor_name'] ?? ''}",
                ),
              if (item['notes'] != null)
                IconAndText(
                  icon: Icons.speaker_notes,
                  label: "${item['notes'] ?? ''}",
                ),
            ],
          ),
        ],
      );
    });
  }
}