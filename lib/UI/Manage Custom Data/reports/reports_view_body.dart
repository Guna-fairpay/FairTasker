import 'dart:io';

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
              Expanded(
                child: ListView(
                  children:[
                    Container(
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
                    ListTile(leading: Utils.getText("Tolls", weight: FontWeight.bold, size: 18),contentPadding: EdgeInsets.zero,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: GestureDetector(
                              onTap: (){context.read<ReportsBloc>().add(ReportTollsEvent());},
                              child: Row(
                                children: [
                                  Material(
                                    color: Colors.grey.shade100,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      bottomLeft: Radius.circular(6),
                                    ),
                                    child: InkWell(
                                      onTap: (){
                                        context.read<ReportsBloc>().add(ReportTollsEvent());
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Choose File",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child:
                                          context.read<ReportsBloc>().tolls.text != '' ?
                                      Text(
                                        "${context.read<ReportsBloc>().tolls.text}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14),
                                      ) : const Text("No file chosen"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.download_rounded),
                          onPressed: () => context.read<ReportsBloc>().add(UploadFileEvent()),
                        ),
                      ],
                    )
                  ]
                ),
              ),

            ],
          ),
        );
      }
    );
  }
}
