
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_expense_history/ui/vehicle_expense_history_edit_preview.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../../../dialog/show_attachments_dialog.dart';
import '../bloc/vehicle_expense_history_bloc.dart';
import '../event/vehicle_expense_history_event.dart';
import '../state/vehicle_expense_history_state.dart';

class VehicleExpenseHistoryUI extends StatelessWidget {
  final String vin;
  final String? vehicleName;
  final bool showTotalAmount;
  final double? currentExpenseAmount;
  const VehicleExpenseHistoryUI(
      {super.key,
        required this.vin,
        required this.vehicleName,
        required this.showTotalAmount,
        this.currentExpenseAmount});

  @override
  Widget build(BuildContext context) {
    Console.of.log("SHOW_TOTAL $showTotalAmount", name: "VehicleExpenseHistoryUI");
    return BlocProvider<VehicleExpenseHistoryBloc>(
      create: (context) => VehicleExpenseHistoryBloc()
        ..add(GetVehicleExpenseHistoryList(vin: vin, isExpenseApprove: showTotalAmount)),
      child:
          BlocListener<VehicleExpenseHistoryBloc, VehicleExpenseHistoryState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
        },
        child:
            BlocBuilder<VehicleExpenseHistoryBloc, VehicleExpenseHistoryState>(
                builder: (context, state) {
                  String total = "${/*(currentExpenseAmount ?? 0) +*/ (state.totalAmount ?? 0)}";
                  return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white,
                backgroundColor: AppC.appColor,
                title: Text(
                  "$vehicleName - $vin",
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  maxLines: 2,
                ),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
              body: SafeArea(
                minimum: 20.padding,
                child: Column(
                  children: [
                    if(showTotalAmount)...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Total Expense Till Date: ', // Normal text
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ), // Regular style
                              children: <TextSpan>[
                                TextSpan(
                                  text: '\$$total', // Bold amount
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                        const Divider(height: 0.5,),
                    ],
                    Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => Divider(height: 0.5, color: Colors.grey.shade400,),
                          itemCount:/*showTotalAmount ? state.approvedList.length :*/state.filteredResponse.length,
                          itemBuilder: (context, index) {
                            var data = /*showTotalAmount
                                ? state.approvedList[index]
                                :*/ state.filteredResponse[index];
                            List<dynamic> images = data?['attachments'];
                            List<dynamic> todoImages = images
                                .map((e) => e['path'].toString().toStorageURL)
                                .toList();
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
                                        Utils.getText(DateFormat('MM-dd-yy').format(DateTime.parse(data['expense_date']))),
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
                                        if (images.isNotEmpty)
                                          InkWell(
                                            onTap: () =>
                                                ShowAttachmentsDialog.of.show(
                                                    context,
                                                    attachments: todoImages,
                                                    title: 'Expense Image'),
                                            child: const Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: AppC.blue,
                                              size: 20,
                                            ),
                                          ),
                                        InkWell(
                                          onTap: () =>
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          VehicleExpenseHistoryEditPreviewUI(
                                                            id: "${data['id']}",
                                                            showTotalAmount: showTotalAmount,
                                                            currentExpenseAmount: currentExpenseAmount,
                                                          ))),
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
                      currentPage: context.watch<VehicleExpenseHistoryBloc>().currentIndex,
                      totalPages: (context.watch<VehicleExpenseHistoryBloc>().totalCount /
                          context.watch<VehicleExpenseHistoryBloc>().itemsPerPage)
                          .ceil(),
                      onPageChanged: (value) => context
                          .read<VehicleExpenseHistoryBloc>()
                          .add(PaginationEvent(page: value)),
                    ),
                  ],
                ),
              ));
        }),
      ),
    );
  }
}
