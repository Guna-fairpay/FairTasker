
import 'package:fairpytasker/UI/Vehicle/vehicle_expense_history/ui/vehicle_expense_history_edit_preview.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../../../dialog/show_attachments_dialog.dart';
import '../bloc/vehicle_expense_history_bloc.dart';
import '../event/vehicle_expense_history_event.dart';
import '../state/vehicle_expense_history_state.dart';

class VehicleExpenseHistoryUI extends StatelessWidget {
  final String vin;
  final String? vehicleName;
  const VehicleExpenseHistoryUI(
      {super.key, required this.vin, required this.vehicleName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VehicleExpenseHistoryBloc>(
      create: (context) => VehicleExpenseHistoryBloc()
        ..add(GetVehicleExpenseHistoryList(vin: vin)),
      child:
          BlocListener<VehicleExpenseHistoryBloc, VehicleExpenseHistoryState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
        },
        child:
            BlocBuilder<VehicleExpenseHistoryBloc, VehicleExpenseHistoryState>(
                builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white,
                backgroundColor: AppC.appColor,
                title: Text(
                  "$vehicleName - $vin",
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 18),
                  maxLines: 2,
                ),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              body: SafeArea(
                minimum: 20.padding,
                child: Column(
                  children: [
                    Utils.getSearchBarUI(
                        onChange: (value) => context
                            .read<VehicleExpenseHistoryBloc>()
                            .add(SearchVehicleExpenseHistoryEvent(value)),
                        searchController: state.searchController),
                    Expanded(
                      child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                                height: 0.5,
                                color: Colors.grey.shade400,
                              ),
                          itemCount: state.filteredResponse.length,
                          itemBuilder: (context, index) {
                            var data = state.filteredResponse[index];
                            List<dynamic> images = data?['attachments'];

                            List<dynamic> todoImages = images
                                .map((e) => e['path'].toString().toStorageURL)
                                .toList();
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VehicleExpenseHistoryEditViewUI(
                                              id: "${data['id']}",
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        spacing: 5,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_month,
                                                  color: AppC.grey, size: 20),
                                              10.width,
                                              Utils.getText(
                                                  "${data['expense_date'] ?? ''}"),
                                              const Spacer(),
                                              Utils.getText(
                                                  "\$ ${data['expense_amount'] ?? ''}",
                                                  color: AppC.green),
                                            ],
                                          ),
                                          Utils.getText(
                                              "${data['expense_description'] ?? ''}"),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          if (images.isNotEmpty)
                                            IconButton(
                                              onPressed: () =>
                                                  ShowAttachmentsDialog.of.show(
                                                      context,
                                                      attachments: todoImages,
                                                      title: 'Expense Image'),
                                              icon: const Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: AppC.blue,
                                                size: 20,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ));
        }),
      ),
    );
  }
}
