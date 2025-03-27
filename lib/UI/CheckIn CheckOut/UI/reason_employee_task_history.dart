
import 'dart:developer';

import 'package:fairpytasker/UI/CheckIn%20CheckOut/Bloc/workHoursBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import '../Event/workingHoursEvent.dart';
import '../State/workingHoursState.dart';

class ExtendedDetailsTask extends StatelessWidget {
  final int id;
  const ExtendedDetailsTask({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: BlocProvider(
        create: (context) => WorkingHoursBloc()..add(ExtendedDetailsTaskEvent(id: id)),
        child: BlocListener<WorkingHoursBloc, WorkingHoursState>(
          listener: (context, state) {
            if (state.isLoading) {
              EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              log("${state.extendedDetails}", name: "Extended Details");
            }
          },
          child: BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color.fromRGBO(7, 90, 51, 1.0),
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Utils.getText(
                          state.extendedDetails['title'] ?? '',
                          color: Colors.white,
                          size: 14,
                          weight: FontWeight.bold
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_month),
                          title: Row(
                            children: [
                              Utils.getText(state.extendedDetails['todo_date'] ?? ''),
                              const SizedBox(width: 5),
                              Utils.getText(state.extendedDetails['todo_time'] ?? '')
                            ],
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person_outline_outlined),
                          title: Utils.getText("${state.extendedDetails['users']?['first_name'][0] ?? ''}${state.extendedDetails['users']?['last_name'][0] ?? ''}"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.directions_car_filled_outlined),
                          title: Utils.getText(
                              state.extendedDetails['vehicle_name'] ??
                                  state.extendedDetails['vehicles']?[0]['vehicle_name'] ?? ''),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person_pin_circle_outlined),
                          title: Utils.getText(state.extendedDetails['vendor_name'] ?? ''),
                        ),
                        if(state.extendedDetails['notes'] != null)
                        ListTile(
                          leading: const Icon(Icons.sticky_note_2_outlined),
                          title: Utils.getText(state.extendedDetails['notes'] ?? ''),
                        ),
                        if(state.extendedDetails['reason'] != null)
                        ListTile(
                          leading: const Icon(Icons.sticky_note_2_outlined),
                          title: Utils.getText(state.extendedDetails['reason'] ?? ''),
                        ),
                        //reason_images
                        //parts
                        //supplies
                        if(state.extendedDetails['resolution_notes'] != null)
                        ListTile(
                          leading: const Icon(Icons.article_outlined),
                          title: Utils.getText(state.extendedDetails['resolution_notes'] ?? ''),
                        ),
                        ListTile(
                          leading: const Icon(Icons.location_on_outlined),
                          title: state.extendedDetails['mileage'] != null ?
                          Utils.getText("Odometer - ${state.extendedDetails['mileage']}") : Utils.getText("No Odometer") ,
                        ),
                        if(state.extendedDetails['reference_id'] != null)
                        ListTile(
                          leading: Utils.getText("Reservation No- ${state.extendedDetails['reference_id'] ?? ''}", color: AppC.red),
                        ),
                        if(state.extendedDetails['expense_amount'] != null || state.extendedDetails['expense_description'] != null
                        || state.extendedDetails['category_name'] != null || state.extendedDetails['subcategory_name'] != null ||
                        state.extendedDetails['expense_attachment'] != null)
                        const ListTile(
                          leading: Text("Expense",style: TextStyle(color: Colors.indigo,fontSize: 14,fontWeight: FontWeight.bold),),
                        ),
                        if(state.extendedDetails['expense_amount'] != null)
                        ListTile(
                          leading: const Icon(Icons.attach_money_outlined),
                          title: Utils.getText(state.extendedDetails['expense_amount'] ?? ''),
                        ),
                        if(state.extendedDetails['expense_description'] != null)
                        ListTile(
                          leading: const Icon(Icons.message_outlined),
                          title: Utils.getText(state.extendedDetails['expense_description'] ?? ''),
                        ),
                        if(state.extendedDetails['category_name'] != null)
                        ListTile(
                          leading: const Icon(Icons.message_outlined),
                          title: Utils.getText(state.extendedDetails['category_name'] ?? ''),
                        ),
                        if(state.extendedDetails['subcategory_name'] != null)
                        ListTile(
                          leading: const Icon(Icons.message_outlined),
                          title: Utils.getText(state.extendedDetails['subcategory_name'] ?? ''),
                        ),
                        if(state.extendedDetails['expense_attachment'] != null)
                        ListTile(
                          leading: const Icon(Icons.attachment),
                          title: Utils.getText(''),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
