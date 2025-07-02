part of 'vendor_type_main_ui.dart';

class VendorTypeListingUI extends StatelessWidget {
  const VendorTypeListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorTypeBloc, VendorTypeState>(
      builder: (context, state) =>
          Form(
            key: context.read<VendorTypeBloc>().formKey,
            child: SafeArea(
              minimum: 15.spMin.padding,
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  5.spMin.height,
                  Utils.getTextFormField(
                      'Name',
                      context.read<VendorTypeBloc>().nameController,
                      autoValidate: context.watch<VendorTypeBloc>().autoValidateMode,
                      validator: (value)=>(value == null || value.isEmpty) ? 'Please Enter the Name' : null,
                  ),
                  10.height,
                  Row(
                      spacing: 10,
                      children: [
                          SuccessButton(
                            text:(!context.read<VendorTypeBloc>().isEdit) ? 'Save' : 'Update',
                            onPressed: ()=> context.read<VendorTypeBloc>().add(SaveEvent()),
                          ),
                        if (context.read<VendorTypeBloc>().isEdit) ...[
                          SuccessButton(
                            text: 'Cancel',
                            backgroundColor: AppC.red,
                            onPressed: ()=> context.read<VendorTypeBloc>().add(CancelEvent()),
                          ),
                        ],
                        Expanded(
                          flex: 8,
                          child: CompactSearchView(
                            controller: context.read<VendorTypeBloc>().searchController,
                            onChanged: (value) => context.read<VendorTypeBloc>().add(SearchEvent(value)),
                          ),
                        ),
                      ]
                  ),
                  10.height,
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(),
                      1: IntrinsicColumnWidth(),
                    },
                    border: const TableBorder(horizontalInside: BorderSide(width: 0.5,color: AppC.borderColor)),
                    children: [
                      TableHeaderRow(
                          tableDecoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(4.spMin), topRight: Radius.circular(4.spMin)),
                            color: const Color(0xFFBDC9E8),
                          ),
                          labels: const ["Type", "Actions"],
                      ),
                      ...context.watch<VendorTypeBloc>().filteredResponse.map((e) => TableRow(
                          children: [
                            TableRowInkWell(
                              child: Padding(
                                padding: 10.spMin.padding,
                                child: Utils.getText(e['name']),
                              ),
                              onTap: () {},
                            ),
                              TableCell(child: Padding(
                                padding: 10.spMin.padding,
                                child:  Row(children: [
                                  GestureDetector(
                                      onTap: () => context.read<VendorTypeBloc>().add(EditEvent(e)),
                                      child: const Icon(Icons.edit_outlined,color: AppC.blue,)),
                                  5.spMin.width,
                                  GestureDetector(
                                      onTap: (){
                                        AskPermissionDialog.show(context,
                                            title: "Are you sure?",
                                            description: "Do you want to delete this vendor type?",
                                            positiveText: "Yes, delete it!",
                                            negativeText: "Cancel",
                                            isReasonRequired: false,
                                            onPositivePressed:()=> context.read<VendorTypeBloc>().add(DeleteEvent(e)));
                                      },
                                      child: const Icon(Icons.delete_outline_rounded, color: AppC.redAccent)),
                                ],),
                              )),
                          ])).toList(),
                    ],
                  ),
                  10.height,
                  CompactPagination(
                    currentPage: context.watch<VendorTypeBloc>().currentIndex,
                    totalPages: (context.watch<VendorTypeBloc>().totalCount / context.watch<VendorTypeBloc>().itemsPerPage).ceil(),
                    onPageChanged: (value) => context.read<VendorTypeBloc>().add(PaginationEvent(value)),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
