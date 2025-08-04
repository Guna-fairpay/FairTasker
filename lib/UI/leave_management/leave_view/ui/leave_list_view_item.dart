
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveListViewItem extends TableRow{

  final Map<String,dynamic>? model;
  final GestureTapDownCallback? onTapDown;

  const LeaveListViewItem({required this.model, this.onTapDown});

  @override
  List<Widget> get children => [
    TableCell(child: Padding(padding: 5.spMin.padding, child: Utils.getText('${model?['user']?['name'] ?? ""}', overFlow: TextOverflow.ellipsis,size: 13.spMin))),
    TableCell(child: Padding(padding: 5.spMin.padding, child: Utils.getText('${model?['leave_type']?['code'] ?? ""}',size: 13.spMin))),
    TableCell(child: Padding(padding: 5.spMin.padding, child: Utils.getText('${model?['reason'] ?? ""}',size: 13.spMin,overFlow: TextOverflow.ellipsis, align: TextAlign.start))),
    TableCell(child: Padding(padding: 5.spMin.padding, child: Utils.getText('${DateTime.parse(model?['start_date']).toFormat(format: 'MM-dd-yy') ?? ""} - ${DateTime.parse(model?['end_date']).toFormat(format: 'MM-dd-yy')  ?? ""}', softWrap: true,size: 13.spMin))),
    TableCell(child: Padding(padding: 5.spMin.padding, child: Utils.getText('${model?['difference'] ?? ""}',size: 13.spMin))),
    TableCell(child: Padding(padding: 5.spMin.padding,
        child: model?['status'] == 'Pending' ? const Icon(Icons.hourglass_empty_outlined,color: Color(0xffff4500),size: 15,)
            : model?['status'] == 'Approved' ? const Icon(Icons.thumb_up_off_alt_rounded,color: AppC.green,size: 15,)
            : model?['status'] == 'Rejected' ? const Icon(Icons.thumb_down,color: AppC.redAccent,size: 15,):null)),
    TableCell(child: InkWell(onTapDown: onTapDown,child: Padding(padding: 5.spMin.padding, child: const Icon(Icons.more_horiz,color: AppC.blue,size: 15,)))),
  ];
}