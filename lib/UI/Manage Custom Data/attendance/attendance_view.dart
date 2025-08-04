import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/attendance_body_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/bloc/attendance_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/bloc/attendance_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/bloc/attendance_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
          title: const Text("Attendance"),
          titleTextStyle: context.textTheme.titleMedium
              ?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),
          backgroundColor: AppC.appColor,
          foregroundColor: AppC.white,
          automaticallyImplyLeading: false,
          leadingWidth: 0,
          actions: [
            IconButton(
                onPressed: context.pop, icon: const Icon(Icons.close_rounded))
          ]),
      body: BlocProvider(
        create: (context) => AttendanceBloc()..add(AttendanceInitialEvent()),
        child: BlocListener<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
            if (state is AttendanceLoadingState) {
              EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.spMin, vertical: 10.spMin),
            child: const AttendanceBodyView(),
          ),
        ),
      ),
    );
  }
}
