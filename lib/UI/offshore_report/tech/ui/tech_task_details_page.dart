
import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TechTaskDetailsPage extends StatelessWidget {
  final dynamic model;
  const TechTaskDetailsPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        titleWidget: const Text('View End of Day Report', style: TextStyle(fontWeight: FontWeight.bold),),
        onClose: context.pop,
      ),
      body: SafeArea(
        minimum: 15.spMin.padding,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Utils.getText('Date', style: GoogleFonts.poppins( fontWeight: FontWeight.bold)),
            Utils.getText(model?['date'] ?? ''),
            Utils.getText('Project', style: GoogleFonts.poppins( fontWeight: FontWeight.bold)),
            Utils.getText(model?['todo']?['project']?['name'] ?? ''),
            Utils.getText('Reporting To', style: GoogleFonts.poppins( fontWeight: FontWeight.bold)),
            Utils.getText(model?['todo']?['reportingTo']?['name'] ?? ' - '),
            Utils.getText('Task Completed Today ', style: GoogleFonts.poppins( fontWeight: FontWeight.bold)),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: FAProgressBar(
                    currentValue: double.tryParse(model?['task_completed_today']?.toString() ?? '') ?? 0.0,
                    maxValue: 100,
                    animatedDuration: Durations.extralong4,
                    size: 18.spMin,
                    progressGradient: const LinearGradient(
                      colors: [AppC.appColor, Color(0xFF3E5BAA),],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    progressColor: AppC.appColor,
                    backgroundColor: AppC.lightGray,
                    displayTextStyle: (context.textTheme.labelLarge ?? const TextStyle()).copyWith(color: Colors.white, fontWeight: FontWeight.bold,),
                  ),
                ),
                Utils.getText('${model?['task_completed_today']} %', style: GoogleFonts.poppins( fontWeight: FontWeight.bold)),
              ],
            ),
            Utils.getText('Today Activity', style: GoogleFonts.poppins( fontWeight: FontWeight.bold)),
            Html(data: model?['today_activity'] ?? ""),
            Utils.getText('Plans for Tomorrow', style: GoogleFonts.poppins( fontWeight: FontWeight.bold)),
            Utils.getText(model?['plans_for_tomorrow'] ?? '',),
            Utils.getText('Additional Information (If Applicable)', style: GoogleFonts.poppins( fontWeight: FontWeight.bold)),
            Utils.getText(model?['additional_information'] ?? '',),
          ],
        ),
      ),
    );
  }
}
