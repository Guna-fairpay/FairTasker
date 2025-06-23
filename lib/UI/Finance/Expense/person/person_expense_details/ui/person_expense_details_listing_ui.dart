part of 'person_expense_details_main_ui.dart';

class PersonExpenseDetailsListingUI extends StatelessWidget {
  const PersonExpenseDetailsListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonExpenseDetailsBloc, PersonExpenseDetailsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: CompactAppBar(
              titleText: '${context.read<PersonExpenseDetailsBloc>().title ?? ''} ',
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
                        text: '\$${context.read<PersonExpenseDetailsBloc>().totalAmount.toStringAsFixed(2) ?? 0.00}',
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
                        itemCount: context.watch<PersonExpenseDetailsBloc>().filteredResponse.length,
                        itemBuilder: (context, index) {
                          var data = context.watch<PersonExpenseDetailsBloc>().filteredResponse[index];
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
                                        onTap: () => context.read<PersonExpenseDetailsBloc>().add(EditEvent(data)),
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
                    currentPage: context.watch<PersonExpenseDetailsBloc>().currentIndex,
                    totalPages: (context.watch<PersonExpenseDetailsBloc>().totalCount /
                        context.watch<PersonExpenseDetailsBloc>().itemsPerPage)
                        .ceil(),
                    onPageChanged: (value) => context
                        .read<PersonExpenseDetailsBloc>()
                        .add(PaginationEvent(page: value)),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
