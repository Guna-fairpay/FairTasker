import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Bloc/workHoursBloc.dart';
import '../Event/workingHoursEvent.dart';
import '../State/workingHoursState.dart';
import 'by_day_component.dart';

class ByDayView extends StatelessWidget {
  final String date;
  final int userId;
  const ByDayView({
    super.key,
    required this.date,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return
      BlocProvider(
        create: (context) => WorkingHoursBloc()..add(ByDayInitialEvent(date: date, userId: userId)),
        child: BlocListener<WorkingHoursBloc, WorkingHoursState>(
        listener: (context, state) {
          if (state.isLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        },
        child:
        BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
            builder: (context, state){
              return SafeArea(
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.byDayData.length,
                        itemBuilder: (context, index){
                          final item = state.byDayData[index];
                          return ByDayComponent(
                            title: item['title'],
                            vehicleName: item['vehicle_name'] ?? item['vehicles'][0]['vehicle_name'] ?? '',
                            time: item['todo_time'].toString().substring(0,5),
                            resource: "${item['users']['first_name'].toString().substring(0,1)}${item['users']['last_name'].toString().substring(0,1)}",
                            notes: item['notes'],
                            vendorName: item['vendor_name'] ?? item['location'] ?? '',
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(),
                      )
                    ],
                  )
              );
            }
        ),
            ),
      );
  }
}
