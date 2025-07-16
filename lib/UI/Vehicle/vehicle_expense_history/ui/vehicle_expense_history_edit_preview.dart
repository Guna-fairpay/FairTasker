
import 'package:fairpytasker/Component/custom_vehicle_expense_history_Info.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/icon_with_text.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_expense_history/ui/vehicle_expense_history_edit_ui.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_expense_history/ui/vehicle_expense_history_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Component/close_badge.dart';
import '../../../../Component/image_viewer.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../core/initializer/common_initializer.dart';
import '../../../dialog/show_attachments_dialog.dart';
import '../bloc/vehicle_expense_history_bloc.dart';
import '../event/vehicle_expense_history_event.dart';
import '../state/vehicle_expense_history_state.dart';

class VehicleExpenseHistoryEditPreviewUI extends StatelessWidget {
  final String? id;
  final bool showTotalAmount;
  final double? currentExpenseAmount;
  const VehicleExpenseHistoryEditPreviewUI({
    super.key, required this.id,required this.showTotalAmount,this.currentExpenseAmount});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VehicleExpenseHistoryBloc>(
      create: (context) => VehicleExpenseHistoryBloc()
        ..add(GetEditVehicleExpenseHistory(id: id)),
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
              title: const Text("View Expense"),
              foregroundColor: Colors.white,
              backgroundColor: AppC.appColor,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VehicleExpenseHistoryUI(
                        vin: state.editResponse?['vin'],
                        vehicleName: state.vehicleName, showTotalAmount: showTotalAmount,
                        currentExpenseAmount: currentExpenseAmount,
                      ))),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            body: SafeArea(
              minimum: 20.padding,
              child: ListView(
                children: [
                  if (getIt<CommonService>().isAdmin)...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(onPressed: () => context.pushReplacement(
                        VehicleExpenseHistoryEditPage(
                          id: "${state.editResponse['id']}",
                          showTotalAmount: showTotalAmount,
                          currentExpenseAmount: currentExpenseAmount,
                        ), fullscreenDialog: true
                    ), icon: const Icon(Icons.edit_outlined,color: AppC.blue,)),
                  ),],
                  IconAndText(
                    icon: Icons.monetization_on_outlined,
                    label: "${state.editResponse['expense_amount'] ?? ''}",
                  ),
                  IconAndText(
                    icon: Icons.message,
                    label: "${state.editResponse['expense_description'] ?? ''}",
                  ),
                  IconAndText(
                    icon: Icons.category,
                    label: "${state.selectedCategory?['name'] ?? ''}",
                  ),
                  IconAndText(
                    icon: Icons.category_outlined,
                    label: "${state.selectedSubCategory?['name'] ?? ''}",
                  ),
                  IconAndText(
                    icon: Icons.payment,
                    label: "${state.selectedPaymentMethod['name'] ?? ''}",
                  ),
                  const IconAndText(
                    icon: Icons.attachment_outlined,
                    label: "",
                  ),
                  if (state.expenseAttachments.isNotEmpty)
                    ImageUploadSection(
                      title: '',
                      borderColor: Colors.blue,
                      onRemove: (file)=> context.read<VehicleExpenseHistoryBloc>().add(RemoveImageEvent(data:file)),
                      images: state.expenseAttachments,
                      logName: "expenseAttachments",
                      isRequired: false,
                      isDeleteDialog: false,
                      isDeleteIcon: false,
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
