
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillListItem extends TableRow {
  final Map<String, dynamic>? model;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onPass;
  final VoidCallback? onViewAttachment;

  final bool? isCheck;
  const BillListItem({required this.model,this.onPass, this.onViewAttachment,required this.onEdit,required this.isCheck, this.onDelete});

  @override
  List<Widget> get children => [
    TableRowInkWell(child:Checkbox(
      activeColor: AppC.appColor,
      value: model?['expense_status'] == 1 ? true : false,
      onChanged: (v)=>model?['expense_status'] == 0 ? onPass?.call():{},
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(8.spMin),),
      side: BorderSide(color: AppC.appColor,width: 1.spMin,),
    )),
    TableRowInkWell(onTap: onEdit, child: Padding(padding: 10.spMin.padding, child: Utils.getText(DateTime.tryParse(model?['created_at']??'').toFormat(format: "M-dd-yyy").toString()))),
    TableRowInkWell(onTap: onEdit, child: Padding(padding: 10.spMin.padding, child: Utils.getText("${model?['title'] ?? ""}",size: 12.spMin))),
    TableCell(child: model?['billimages']?.isNotEmpty ? IconButton(onPressed: onViewAttachment, icon: const Icon(Icons.remove_red_eye,size: 20,), color: AppC.appColor):const SizedBox.shrink(),),
    TableRowInkWell(child: Padding(padding: 10.spMin.padding, child: Utils.getText(<String>[(model?['users']?['first_name'] ?? ""), (model?['users']?['last_name'] ?? "")].toInitial,))),
    TableCell(child: IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline,size: 20,), color: AppC.redAccent),),
  ];
}