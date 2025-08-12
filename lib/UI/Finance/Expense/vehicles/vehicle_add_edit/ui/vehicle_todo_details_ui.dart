part of 'vehicle_add_edit_main_ui.dart';

class VehicleTodoDetailsUI extends StatelessWidget {
  const VehicleTodoDetailsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleAddEditBloc, VehicleAddEditState>(
        builder: (context, state) {
          var item = context.read<VehicleAddEditBloc>().todoItems;
          var bookingDetails = item?['bookingDetails'] ?? {};
          var name = bookingDetails?['user']?['name'] ?? "";
          var email = bookingDetails?['user']?['email'] ?? "";
          var bookedOn = bookingDetails?['booked_on'].toString().toFormat(format: "MM-dd-yyyy") ?? "";
          var from = "${bookingDetails?['booking_start_date'].toString().toFormat(format: "MM-dd-yy") ?? ""} ${bookingDetails?['booking_start_time'].toString().toFormat(inputFormat: 'HH:mm:ss', format: "hh:mm a") ?? ""}";
          var till = "${bookingDetails?['booking_return_date'].toString().toFormat(format: "MM-dd-yy") ?? ""} ${bookingDetails?['booking_return_time'].toString().toFormat(inputFormat: 'HH:mm:ss', format: "hh:mm a") ?? ""}";
          var total = bookingDetails?['cost_summary']?['finalEstimate'] ?? "";
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
                      label: (item['notes'] ?? '').toString().removeHtmlTags,
                    ),
                ],
              ),
              20.spMin.height,
              Visibility(
                visible: item['rental_booking_id'] != null,
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CompactText('BOOKING DETAILS', styleType: TextStyleType.titleSmall, fontWeight: FontWeight.bold,),
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(2),
                        },
                        border: TableBorder.all(
                            borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
                            width: Num.borderWidthThinField,
                            color: AppC.borderColor),
                        children: [
                          TableRow(
                              children: [
                                TableCell(
                                    child: Padding(
                                      padding: 10.padding,
                                      child: const CompactText("Name",
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis),
                                    )),
                                TableCell(
                                    child: Padding(
                                      padding: 10.padding,
                                      child: CompactText(
                                          name,
                                          fontWeight: FontWeight.normal,
                                          overflow: TextOverflow.ellipsis),
                                    )),
                              ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                                  padding: 10.padding,
                                  child: const CompactText("Email",
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                )),
                            TableCell(
                                child: Padding(
                                  padding: 10.padding,
                                  child: CompactText(
                                      email,
                                      fontWeight: FontWeight.normal,
                                      overflow: TextOverflow.ellipsis),
                                )),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                                  padding: 10.padding,
                                  child: const CompactText("Booked On",
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                )),
                            TableCell(
                                child: Padding(
                                  padding: 10.padding,
                                  child: CompactText(
                                      bookedOn,
                                      fontWeight: FontWeight.normal,
                                      overflow: TextOverflow.ellipsis),
                                )),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                                  padding: 10.padding,
                                  child: const CompactText("From",
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                )),
                            TableCell(
                                child: Padding(
                                  padding: 10.padding,
                                  child: CompactText(
                                      from,
                                      fontWeight: FontWeight.normal,
                                      overflow: TextOverflow.ellipsis),
                                )),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                                  padding: 10.padding,
                                  child: const CompactText("Till",
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                )),
                            TableCell(
                                child: Padding(
                                  padding: 10.padding,
                                  child: CompactText(
                                      till,
                                      fontWeight: FontWeight.normal,
                                      overflow: TextOverflow.visible),
                                )),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                                  padding: 10.padding,
                                  child: const CompactText("Total",
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.visible),
                                )),
                            TableCell(
                                child: Padding(
                                  padding: 10.padding,
                                  child: CompactText(
                                      "\$$total",
                                      fontWeight: FontWeight.normal,
                                      overflow: TextOverflow.visible),
                                )),
                          ]),
                        ],
                      ),
                    ],
                  ),
              )
        ],
      );
    });
  }
}