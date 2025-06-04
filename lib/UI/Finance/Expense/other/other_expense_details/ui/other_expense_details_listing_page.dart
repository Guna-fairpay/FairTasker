import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_add_edit/ui/other_add_edit_main_page.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_expense_details/bloc/other_expense_details_bloc.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtherExpenseDetailsListingPage extends StatelessWidget {
  const OtherExpenseDetailsListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherExpenseDetailsBloc, OtherExpenseDetailsState>(
        builder: (context, state) {
      return Scaffold(
        appBar: CompactAppBar(
          titleText: '${context.read<OtherExpenseDetailsBloc>().title ?? ''} ',
          foregroundColour: AppC.white,
          onClose: context.pop,
        ),
        body: SafeArea(
          minimum: 15.spMin.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(textAlign: TextAlign.end,
                  text:  TextSpan(children: [
                 TextSpan(
                  text: 'Total Expense Till Date : ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xff212529), fontSize: 13.spMin),
                ),
                TextSpan(
                  text: '\$${context.read<OtherExpenseDetailsBloc>().totalAmount.toStringAsFixed(2) ?? 0.00}',
                  style: TextStyle(color: const Color(0xff212529), fontWeight: FontWeight.w900, fontSize: 16.spMin ),
                ),
              ]),
              ),
              const Divider(thickness: 0.5, height: 0.5,),
              Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => Divider(height: 0.5, color: Colors.grey.shade400,),
                    itemCount: context.watch<OtherExpenseDetailsBloc>().filteredResponse.length,
                    itemBuilder: (context, index) {
                      var data = context.watch<OtherExpenseDetailsBloc>().filteredResponse[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Utils.getText((DateTime.tryParse(data['expense_date'])?.toFormat(format: 'MM-dd-yy') ?? '')),
                                  Utils.getText("\$ ${data['expense_amount'] ?? ''}",),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                spacing: 20,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Utils.getText(
                                      (data['expense_description'] ?? '').toString().toSentenceCase(),
                                      overFlow: TextOverflow.visible,
                                    ),
                                  ),
                                  if (data['attachments_paths'].isNotEmpty)
                                    InkWell(
                                      onTap: () =>
                                          ShowAttachmentsDialog.of.show(
                                              context,
                                              attachments: data['attachments_paths'],
                                              title: 'Expense Image'),
                                      child: const Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: AppC.blue,
                                        size: 20,
                                      ),
                                    ),
                                  InkWell(
                                    onTap: () => context.push(OtherAddEditMainPage(id: data['id'].toString(),)),
                                    child: const Icon(
                                      Icons.edit_outlined,
                                      color: AppC.redAccent,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              CompactPagination(
                currentPage: context.watch<OtherExpenseDetailsBloc>().currentIndex,
                totalPages: (context.watch<OtherExpenseDetailsBloc>().totalCount /
                    context.watch<OtherExpenseDetailsBloc>().itemsPerPage)
                    .ceil(),
                onPageChanged: (value) => context
                    .read<OtherExpenseDetailsBloc>()
                    .add(PaginationEvent(page: value)),
              ),
            ],
          ),
        ),
      );
    });
  }
}
