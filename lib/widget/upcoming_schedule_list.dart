import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';

class UpcomingScheduleListView extends StatefulWidget {
  final Function? onTap;
  final List<Map<String, dynamic>>? taskList;
  const UpcomingScheduleListView({this.onTap, this.taskList, Key? key})
      : super(key: key);

  @override
  State<UpcomingScheduleListView> createState() =>
      _UpcomingScheduleListViewState();
}

class _UpcomingScheduleListViewState extends State<UpcomingScheduleListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Utils.getText(
                "Schedule",
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppC().base),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateTaskView(),
                        ),
                      );*/
                    },
                    child: Utils.getText("+ Add New", color: AppC.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.taskList?.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 06, bottom: 06),
                  child: InkWell(
                    onTap: () {
                      widget.onTap!(index);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppC.containerTextB.withOpacity(0.2)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(14),
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppC().containerIconB),
                            child: Container(
                              alignment: Alignment.center,
                              child: Image.asset(Assets.icDashBoard,
                                  height: 40, width: 40, fit: BoxFit.cover),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Utils.getText(
                                        '${widget.taskList?[index]['task_name'] ?? 'n/a'} Priority ${widget.taskList?[index]['task_name'] ?? 'n/a'} By ${widget.taskList?[index]['assigned_to'] ?? 'n/a'}',
                                      ),
                                    ),
                                    Expanded(
                                        child: Utils.getText(
                                            widget.taskList?[index]['status'] ??
                                                'n/a'))
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Utils.getText(
                                        '${widget.taskList?[index]['task_date'] ?? 'n/a'} | ${widget.taskList?[index]['start_time'] ?? 'n/a'} - ${widget.taskList?[index]['end_time'] ?? 'n/a'}',
                                        color: AppC().bottomIconColor,
                                      ),
                                    ),
                                    Expanded(
                                      child: Utils.getText(
                                        '${widget.taskList?[index]['create_by']?.firstName ?? 'n/a'} ${widget.taskList?[index]['create_by']?.lastName ?? 'n/a'}',
                                        color: AppC().bottomIconColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
