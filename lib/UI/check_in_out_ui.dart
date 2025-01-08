import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Bloc/upcoming_task_bloc.dart';

class CheckInOutUI extends StatefulWidget {
  const CheckInOutUI({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckInOutUI> createState() => _CheckInOutUIState();
}

class _CheckInOutUIState extends State<CheckInOutUI> {
  UpcomingTaskBloc? upcomingTaskBloc;

  @override
  void initState() {
    upcomingTaskBloc = UpcomingTaskBloc();
    super.initState();
  }

  List resourceList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //   backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppC.trans,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: AppC.black,
                )),
            title: Utils.getText('Check In/Out',
                size: 18, weight: FontWeight.w700)),
        body: BlocProvider(
            create: (context) =>
                upcomingTaskBloc!..add(const GetAssignedToList()),
            child: BlocConsumer<UpcomingTaskBloc, UpcomingTaskState>(
                listener: (context, state) async {},
                builder: (context, state) {
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: const BorderSide(
                                        color: AppC.white, width: 1),
                                    left: const BorderSide(
                                        color: AppC.white, width: 1),
                                    right: const BorderSide(
                                        color: AppC.white, width: 1),
                                    bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.1),
                                        width: 1),
                                  ),
                                  boxShadow: const [
                                    // BoxShadow(
                                    //   color: Colors.grey.withOpacity(0.3),
                                    //   spreadRadius: 1,
                                    //  // blurRadius: 1,
                                    //   offset: const Offset(0,  5),
                                    // ),
                                  ],
                                  color: AppC.grey.withOpacity(0.3),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Utils.getText('User',
                                            weight: FontWeight.bold)),
                                    Expanded(
                                        flex: 3,
                                        child: Utils.getText('CheckIn',
                                            weight: FontWeight.bold)),
                                    Expanded(
                                        flex: 3,
                                        child: Utils.getText('CheckOut',
                                            weight: FontWeight.bold)),
                                    Expanded(
                                        flex: 3,
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Utils.getText('Total Hours',
                                                weight: FontWeight.bold))),
                                  ],
                                ),
                              ),

                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: const BorderSide(
                                            color: AppC.white, width: 1),
                                        left: const BorderSide(
                                            color: AppC.white, width: 1),
                                        right: const BorderSide(
                                            color: AppC.white, width: 1),
                                        bottom: BorderSide(
                                            color: Colors.grey.withOpacity(0.1),
                                            width: 1),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: const Offset(0,
                                              5), // Adjust the offset for the side you want the shadow
                                        ),
                                      ],
                                      color: AppC.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: Utils.getText('Dinesh')),
                                        Expanded(
                                            flex: 3,
                                            child: InkWell(
                                                onTap: () {},
                                                child:
                                                    Utils.getText("10:00 AM"))),
                                        Expanded(
                                            flex: 3,
                                            child: InkWell(
                                                onTap: () async {},
                                                child:
                                                    Utils.getText("08:00 PM"))),
                                        Expanded(
                                            flex: 3,
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: InkWell(
                                                    onTap: () async {},
                                                    child: Utils.getText(
                                                        "10:00:00")))),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              //   Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //     Utils.getText('Dinesh', size: 16),
                              //     Utils.getText(
                              //       '10:00:00',
                              //       size: 16,
                              //     ),
                              //   ]),
                              //  const SizedBox(height: 5),
                              //   Row(
                              //        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //     Utils.getText('10:00 AM', size: 16),
                              //     Utils.getText('08:00 PM', size: 16),
                              //   ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                })));
  }
}
