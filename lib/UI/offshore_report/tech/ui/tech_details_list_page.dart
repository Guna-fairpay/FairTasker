
import 'package:fairpytasker/Component/custom_search_bar.dart';
import 'package:fairpytasker/Component/limited_html_view.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/offshore_report/componet/card.dart';
import 'package:fairpytasker/UI/offshore_report/tech/bloc/tech_bloc.dart';
import 'package:fairpytasker/UI/offshore_report/tech/ui/tech_task_details_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TechDetailsListPage extends StatelessWidget {
  const TechDetailsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TechBloc, TechState>(
      builder: (context, state) => Column(
        spacing: 5,
        children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              flex: 1,
              child: DateRangePicker(
                selectedDateRange: context.read<TechBloc>().selectedDateRange ,
                onDateRangeSelected: (value) => context.read<TechBloc>().add(DateRangeSelectedEvent(value)),
              ),
            ),
            TextButton(child: Utils.getText('P', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppC.appColor, fontSize: 20.spMin)), onPressed: (){},),
            IconButton(onPressed: (){}, icon: const Icon(Icons.filter_alt_outlined, color: AppC.appColor),),

          ],
        ),
        CustomSearchBar(
          controller: context.read<TechBloc>().searchController,
          onChanged: (query) => context.read<TechBloc>().add(SearchEvent(query)),
          hintText: 'Search...',
        ),
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<TechBloc>().filteredData?.length ?? 0,
              itemBuilder: (context, index) {
                final item = context.watch<TechBloc>().filteredData?[index];
               return CustomCard(
                 color: AppC.redAccent,
                child: Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Utils.getText('${item?['todo']?['title']??''}', color: AppC.appColor),
                    Utils.getText('${item?['date']??''}',),
                    Utils.getText('${item?['todo']?['project']?['name'] ?? ''}', color: AppC.green),
                    LimitedHtmlView(data: item?['today_activity'], showEdit: false,),
                    5.spMin.height,
                    GestureDetector(
                      onTap: ()=> context.push(TechTaskDetailsPage(model: item,)),
                      child: Utils.getText(
                          "${item?['user']?['first_name'] ?? ''} ${item?['user']?['last_name'] ?? ''}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppC.appColor)
                      ),
                    ),
                    5.spMin.height,
                    FAProgressBar(
                      currentValue: double.tryParse(item['task_completed_today']?.toString() ?? '') ?? 0.0,
                      maxValue: 100,
                      animatedDuration: Durations.extralong4,
                      displayText: " % ",
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
                  ],
                ),
              );
              }
            ),
          ),
      ],),
    );
  }
}
