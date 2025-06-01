import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/coumn_tile.dart';
import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/todo_task_item_card.dart';
import 'package:fairpytasker/UI/resource/task_details/component/task_expansion_tile.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'detailed_report_header.dart';
part 'detailed_report_by_task.dart';
part 'detailed_report_by_day.dart';

class DetailedReportUi extends StatelessWidget {
  const DetailedReportUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        titleText: "<PERSON NAME>",
        automaticallyImplyleading: false,
        onClose: () {

        },
      ),
      body: Column(
        spacing: 10.spMin,
        children: const [
          DetailedReportHeader(),
          // Expanded(child: DetailedReportByTask()),
          Expanded(child: DetailedReportByDay()),
        ],
      ),
    );
  }
}
