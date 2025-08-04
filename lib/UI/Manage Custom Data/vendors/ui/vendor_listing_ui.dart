part of 'vendor_main_ui.dart';

class VendorListingUI extends StatelessWidget {
  const VendorListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorBloc, VendorState>(
      builder: (context, state) {
        return Column(
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(),
                1: IntrinsicColumnWidth(),
              },
              border: const TableBorder(horizontalInside: BorderSide(width: 0.5,color: AppC.borderColor)),
              children: [
                TableHeaderRow(
                  firstTextAlign: TextAlign.start,
                  textAlign: TextAlign.end,
                  tableDecoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(4.spMin), topRight: Radius.circular(4.spMin)),
                    color: const Color(0xFFBDC9E8),
                  ),
                  labels: const ["Vendor Name", "Actions"],
                ),
                ...context.watch<VendorBloc>().filteredResponse.map((e) => TableRow(
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
                        child:  Row(

                          children: [
                          (e['images']?.isNotEmpty ?? false)?
                          InkWell(
                            onTap: () {
                              ShowAttachmentsDialog.of.show(
                                context,
                                attachments: e['images']
                                    ?.map((element) => element['path'].toString().toStorageURL)
                                    .toList(),
                                title: e['name'] ?? '',
                              );
                            },
                            child:  Icon(
                              Iconsax.eye,
                              color: AppC.appColor,
                              size: 20.spMin,
                            )
                          ) : Icon(
                            Icons.visibility,
                            color: AppC.trans,
                            size: 20.spMin,
                          ),
                          10.spMin.width,
                          (e['latitude'] != null && e['longitude'] != null)?
                          InkWell(
                            onTap: ()=> context.read<VendorBloc>().add(GetDirectionEvent(e)),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationZ(30 * math.pi / -120),
                              child: Icon(
                                Iconsax.direct_right,
                                color: AppC.green,
                                size: 20.spMin,
                              ),
                            ),
                          ): Icon(
                            Icons.navigation_outlined,
                            color: AppC.trans,
                            size: 20.spMin,
                          ),
                          10.spMin.width,
                          GestureDetector(
                              onTap: () => context.read<VendorBloc>().add(EditEvent(e)),
                              child: const Icon(Iconsax.edit_2,color: AppC.blue,)
                          ),
                          10.spMin.width,
                          GestureDetector(
                              onTap: (){
                                AskPermissionDialog.show(context,
                                    title: "Are you sure?",
                                    description: "Do you want to delete this vendor?",
                                    positiveText: "Yes, delete it!",
                                    negativeText: "Cancel",
                                    isReasonRequired: false,
                                    onPositivePressed:()=> context.read<VendorBloc>().add(DeleteEvent(e)));
                              },
                              child: const Icon(Iconsax.trash, color: AppC.redAccent)),
                        ],),
                      )),
                    ])).toList(),
              ],
            ),
            10.height,
            CompactPagination(
              currentPage: context.watch<VendorBloc>().currentIndex,
              totalPages: (context.watch<VendorBloc>().totalCount / context.watch<VendorBloc>().itemsPerPage).ceil(),
              onPageChanged: (value) => context.read<VendorBloc>().add(PaginationEvent(value)),
            ),
          ],
        );
      }
    );
  }
}
