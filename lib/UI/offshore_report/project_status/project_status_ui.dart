import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/custom_segmented_button/segment_button.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/label_view.dart';
import 'package:fairpytasker/Component/limited_html_view.dart';
import 'package:fairpytasker/Component/row_tile.dart';
import 'package:fairpytasker/UI/offshore_report/componet/card.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

part 'project_status_header.dart';

class OffShoreProjectStatus extends StatelessWidget {
  const OffShoreProjectStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.spMin,
      children: [
        const ProjectStatusHeader(),
        Expanded(child: ListView(
          children: [
            CustomCard(
              color: AppC.redAccent,
              padding: 10.spMin.padding,
              child: Column(
                spacing: 4.0,
                children: [
                  const RowTile(
                    expandTitle: true,
                    title: CompactText("Landing / Task View / ToDo List"),
                    trailing: Label(labelText: "High", backgroundColor: AppC.redAccent, foregroundColor: Colors.white),
                  ),
                  const RowTile(
                    expandTitle: true,
                    title: CompactText("2025-03-21 | 2025-03-31", color: Colors.grey),
                    trailing: CompactText("Tasker Mobile App", color: AppC.green),
                  ),
                  LimitedHtmlView(data: '<p>https:\/\/docs.google.com\/spreadsheets\/d\/1Qwu2hybmtmPi0kCgjU805TJDhU3MU4pC7V2XXoRtkso\/edit?usp=sharing<\/p><p><br><\/p><p>March Month Earrings and Expenses datils <\/p>',)
                ],
              ),
            )
          ],
        ))
      ],
    );
  }
}
