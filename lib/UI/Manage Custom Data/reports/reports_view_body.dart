import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/reports/reports_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsViewBody extends StatelessWidget {
  const ReportsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              ListTile(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
                contentPadding: EdgeInsets.zero,
                title:
                Utils.getText('Reports', size: 20, weight: FontWeight.bold),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFeaf0fa),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text("Maintenance Check List"),
                          trailing: (state.isMaintenanceLoading) ? const CircularProgressIndicator() : GestureDetector(
                            onTap: () => context.read<ReportsBloc>().add(ReportMaintenanceEvent()),
                            child: Icon((state.maintenanceFile != null) ? Icons.file_open : Icons.download_rounded),
                          ),
                        ),
                        Container(
                          color: AppC.white.withValues(alpha: 0.2),
                          height: 1,
                        ),
                        ListTile(
                          title: const Text("Vehicle Odometer Summary"),
                          trailing: (state.isVehicleLoading) ? const CircularProgressIndicator() :  GestureDetector(
                            onTap: () => context.read<ReportsBloc>().add(ReportVehicleEvent()),
                            child: Icon((state.vehicleFile != null) ? Icons.file_open : Icons.download_rounded),
                          ),
                        ),
                        Container(
                          color: AppC.white.withValues(alpha: 0.2),
                          height: 1,
                        ),
                        ListTile(
                          title: const Text("Earnings Summary"),
                          trailing: (state.isEarningLoading) ? const CircularProgressIndicator() :  GestureDetector(
                            onTap: () => context.read<ReportsBloc>().add(ReportEarningEvent()),
                            child: Icon((state.earningFile != null) ? Icons.file_open : Icons.download_rounded),
                          ),
                        ),
                        Container(
                          color: AppC.white.withValues(alpha: 0.2),
                          height: 1,
                        ),
                        ListTile(
                          title: const Text("Vehicle Inventory Data"),
                          trailing: (state.isVehicleInventoryLoading) ? const CircularProgressIndicator() :  GestureDetector(
                            onTap: () => context.read<ReportsBloc>().add(ReportVehicleInventoryEvent()),
                            child: Icon((state.vehicleInventoryFile != null) ? Icons.file_open : Icons.download_rounded),
                          ),
                        ),
                        Container(
                          color: AppC.white.withValues(alpha: 0.2),
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
