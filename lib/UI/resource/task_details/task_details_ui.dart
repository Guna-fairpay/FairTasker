import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/UI/resource/task_details/component/task_expansion_tile.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart' show DateRange;
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskDetailsUi extends StatelessWidget {
  final Map<String, dynamic>? model;
  final DateRange? dateRange;
  const TaskDetailsUi({super.key, required this.model, this.dateRange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model?['name'] ?? ""),
        automaticallyImplyLeading: false,
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        actions: [
          IconButton(onPressed: context.pop, icon: const Icon(Icons.close_rounded))
        ],
      ),
      body: Column(
        spacing: 10.sp,
        children: [
          ListTile(
            title: Text(dateRange?.toFormat() ?? ""),
            trailing: GestureDetector(
              child: const Icon(Icons.filter_alt_rounded),
            ),
          ),
          ListView(
            padding: 16.sp.horizontalPadding,
            shrinkWrap: true,
            children: [
              ExpansionTile(
                title: const CompactText("Checking", color: AppC.appColor, fontWeight: FontWeight.bold, styleType: TextStyleType.titleMedium),
                iconColor: AppC.appColor,
                collapsedIconColor: AppC.appColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5.sp), side: const BorderSide(width: Num.borderWidthThinField, color: AppC.borderColor)),
                collapsedBackgroundColor: AppC.lightBlue,
                backgroundColor: AppC.lightBlue,
                minTileHeight: 40.sp,
                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5.sp)),
                children: [
                  Container(
                    width: double.maxFinite,
                    color: AppC.white,
                    padding: 10.sp.padding,
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => 10.sp.height,
                      itemBuilder: (context, index) => TaskExpansionTile(styleType: TextStyleType.labelLarge), itemCount: 5,),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
