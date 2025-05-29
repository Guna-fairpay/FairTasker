import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/label_view.dart';
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

class OffShoreProjectStatus extends StatelessWidget {
  const OffShoreProjectStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.spMin,
      children: [
        Card(
          color: context.theme.cardColor,
          elevation: 5.spMin,
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16.spMin)),
          child: Container(
            padding: 16.spMin.padding,
            width: double.maxFinite,
            child: Column(
              spacing: 10.spMin,
              children: [
                Row(
                  spacing: 16.spMin,
                  children: [
                    Expanded(child: Material(
                        elevation: 3.spMin, borderRadius: BorderRadius.circular(30.spMin),
                        child: CompactSearchView(
                      filled: true,
                      prefixIcon: IntrinsicHeight(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(30.spMin))
                          ),
                          padding: 8.spMin.padding,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: SizedBox.fromSize(size: Size.fromRadius(10.spMin),child: SvgPicture.asset(Assets.searchIcon, clipBehavior: Clip.antiAliasWithSaveLayer, theme: const SvgTheme(currentColor: AppC.appColor))),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(30.spMin),
                    ))),
                    CompactIconButton(elevation: 5.spMin, icon: Icons.filter_alt_outlined, shape: const WidgetStatePropertyAll(CircleBorder()) , backgroundColor: Colors.white, foregroundColor: AppC.appColor, onTapDown: (details) => Console.of.log(details.globalPosition))
                  ],
                ),
                FittedBox(
                  child: SegmentedButton<int>(segments: [
                    const ButtonSegment<int>(value: 1, label: Text('Milestone'), icon: Icon(Icons.sports_score_rounded)),
                    const ButtonSegment<int>(value: 2, label: Text('Backlog'), icon: Icon(Icons.checklist_rounded)),
                    ButtonSegment<int>(value: 3, label: const Text('Roadmap'), icon: SizedBox.fromSize(child: SvgPicture.asset(Assets.roadMapIcon), size: Size.fromRadius(10.spMin),)),
                  ], selected: const {3},
                    onSelectionChanged: (value) {

                    },
                    style: ButtonStyle(
                      side: const WidgetStatePropertyAll(BorderSide(color: AppC.borderColor, width: Num.borderWidthButton)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(Num.radiusButton),
                        side: const BorderSide(color: AppC.appColor, width: Num.borderWidthButton)
                      )),
                      backgroundBuilder: (context, states, child) => states.contains(WidgetState.selected) ? Container(
                        decoration: BoxDecoration(
                          color: AppC.white,
                          borderRadius: BorderRadius.circular(Num.radiusButton),
                        ),
                        child: child,
                      ) : (child ?? const SizedBox.shrink()),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        CustomCard(
         color: AppC.redAccent,
         padding: 10.spMin.padding,
         child: Column(
           spacing: 4.0,
           children: [
             RowTile(
               expandTitle: true,
               title: CompactText("Landing / Task View / ToDo List"),
               trailing: Label(labelText: "High", backgroundColor: AppC.redAccent, foregroundColor: Colors.white),
             ),
             RowTile(
               expandTitle: true,
               title: CompactText("2025-03-21 | 2025-03-31", color: Colors.grey),
               trailing: CompactText("Tasker Mobile App", color: AppC.green),
             ),
             Html(data: '<ul><li>Listing Details modification and Adding missing things<\/li><li>Vehicle Search Dialog \/ Popup<\/li><li>Swipe Complete Dialogs \/ Popups<\/li><li>Swipe Previous Dialog \/ Popups<\/li><\/ul>',)
           ],
         ),
        )
      ],
    );
  }
}
