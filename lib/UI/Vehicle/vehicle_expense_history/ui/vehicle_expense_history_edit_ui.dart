import 'dart:developer';

import 'package:fairpytasker/UI/Vehicle/vehicle_expense_history/ui/vehicle_expense_history_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Component/close_badge.dart';
import '../../../../Component/custom_date_time_picker.dart';
import '../../../../Component/custom_single_selection_field.dart';
import '../../../../Component/image_viewer.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/num.dart';
import '../../../dialog/show_attachments_dialog.dart';
import '../bloc/vehicle_expense_history_bloc.dart';
import '../event/vehicle_expense_history_event.dart';
import '../state/vehicle_expense_history_state.dart';

class VehicleExpenseHistoryEditPage extends StatelessWidget {
  final String? id;
  final bool showTotalAmount;
  final double? currentExpenseAmount;
  const VehicleExpenseHistoryEditPage({super.key, required this.id,required this.showTotalAmount,this.currentExpenseAmount});

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
              title: const Text("Edit Expense"),
              foregroundColor: Colors.white,
              backgroundColor: AppC.appColor,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () {
                    AskPermissionDialog.show(context,
                        title: "Are you sure?",
                        description: "Do you want to delete this Expense?",
                        positiveText: "Yes, delete it!",
                        negativeText: "Cancel",
                        isReasonRequired: false, onPositivePressed: () {
                      context
                          .read<VehicleExpenseHistoryBloc>()
                          .add(DeleteVehicleExpenseHistoryEvent(id: id));
                      Future.delayed(
                        const Duration(seconds: 1),
                        () => context.pushReplacement(VehicleExpenseHistoryUI(
                          vin: state.vin,
                          vehicleName: state.vehicleName,
                          showTotalAmount: showTotalAmount,
                          currentExpenseAmount: currentExpenseAmount,
                        )),
                      );
                    });
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
                IconButton(
                  onPressed: () =>
                      context.pushReplacement(VehicleExpenseHistoryUI(
                    vin: state.vin,
                    vehicleName: state.vehicleName,
                        showTotalAmount: showTotalAmount,
                        currentExpenseAmount: currentExpenseAmount,
                  )),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            body: SafeArea(
              minimum: 20.padding,
              child: ListView(
                children: [
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context
                              .read<VehicleExpenseHistoryBloc>()
                              .add(PickImageEvent()),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppC.blue,
                                width: Num.borderWidthField,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(Num.subradiusButton),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.cloud_upload,
                                  color: AppC.blue,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Utils.getText('Upload',
                                    color: AppC.blue, weight: FontWeight.bold),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context
                              .read<VehicleExpenseHistoryBloc>()
                              .add(CaptureImageEvent()),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppC.redAccent,
                                width: Num.borderWidthField,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(Num.subradiusButton),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.camera_enhance,
                                  color: AppC.redAccent,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Utils.getText('Capture',
                                    color: AppC.redAccent,
                                    weight: FontWeight.bold),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.height,
                  if (state.expenseAttachments.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: state.expenseAttachments.length,
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, mainAxisSpacing: 10),
                        itemBuilder: (context, index) => CloseBadge(
                            onTapView: () {
                              ShowAttachmentsDialog.of.show(context,
                                  attachments: state.expenseAttachments,
                                  title: "",
                                  currentAttachment:
                                      state.expenseAttachments[index]);
                            },
                            onTapDelete: () {
                              AskPermissionDialog.show(context,
                                  title: "Are you sure?",
                                  description: "Do you want to delete this Expense Image?",
                                  positiveText: "Yes, delete it!",
                                  negativeText: "Cancel",
                                  isReasonRequired: false,
                                  onPositivePressed: () =>
                                    context.read<VehicleExpenseHistoryBloc>().add(
                                        RemoveImageEvent(
                                            data: state.expenseAttachments[index])));

                            },
                            child:Stack(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    minHeight:
                                    MediaQuery.sizeOf(context).height,
                                    minWidth:
                                    MediaQuery.sizeOf(context).width,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(16),
                                      color:
                                      AppC.grey.withValues(alpha: 0.2)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: ImageViewer(
                                    fit: BoxFit.cover,
                                    imageInput: state.expenseAttachments[index],
                                    isNotImage: !((state.expenseAttachments[index]
                                    as Object)
                                        .isImage),
                                  ),
                                ),
                                // Add download button only for PDF
                                if ((state.expenseAttachments[index] as Object).isPDF)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppC.green,
                                      borderRadius: BorderRadius.circular(16),

                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Utils.openURL(state.expenseAttachments[index]);
                                      },child:Padding(
                                      padding: 4.padding,
                                      child: const Icon(Icons.remove_red_eye_outlined,color: AppC.white,size: 15,),
                                    ),),
                                  ),

                              ],
                            ), /*Column(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    minHeight: MediaQuery.sizeOf(context).height,
                                    minWidth: MediaQuery.sizeOf(context).width,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: AppC.grey.withValues(alpha: 0.2)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: ImageViewer(
                                    fit: BoxFit.cover,
                                    imageInput: state.expenseAttachments[index],
                                    isNotImage: !((state.expenseAttachments[index]
                                            as Object)
                                        .isImage),
                                  ),
                                ),
                              ],
                            )*/),
                      ),
                    ),
                  10.height,
                  CustomSingleSelectionField<Map<String, dynamic>>(
                    suggestionsList: state.vehicle,
                    itemAsString: (item) => item['vehicle_name'] ?? '',
                    selected: state.selectedVehicle,
                    labelText: "Vehicle Name",
                    hintText: "",
                    onSelected: (val) {
                      context
                          .read<VehicleExpenseHistoryBloc>()
                          .add(VehicleEvent(selectedVehicle: val));
                    },
                    controller: context
                        .read<VehicleExpenseHistoryBloc>()
                        .vehicleController,
                  ),
                  10.height,
                  Row(
                    children: [
                      Expanded(
                        child: Utils.getTextFormField(
                          'Amount',
                          context
                              .read<VehicleExpenseHistoryBloc>()
                              .amountController,
                        ),
                      ),
                      10.width,
                      Expanded(
                          child: Utils.dropdownBox(
                              'Select Payment Method',
                              state.paymentMethods,
                              (value) => context
                                  .read<VehicleExpenseHistoryBloc>()
                                  .add(
                                      SelectedPaymentEvent(paymentType: value)),
                              labelKey: 'name',
                              initialSelection: state.selectedPaymentMethod))
                    ],
                  ),
                  10.height,
                  Utils.getTextFormField(
                    'Description',
                    context
                        .read<VehicleExpenseHistoryBloc>()
                        .descriptionController,
                  ),
                  10.height,
                  Utils.dropdownBox('Select Category', state.categories,
                      (value) {
                    context
                        .read<VehicleExpenseHistoryBloc>()
                        .add(CategoryListEvent(category: value));
                  },
                      labelKey: 'name',
                      selectedKey: state.selectedCategory,
                      initialSelection: state.selectedCategory),
                  10.height,
                  Utils.dropdownBox('Select SubCategory', state.subCategories,
                      (value) {
                    context
                        .read<VehicleExpenseHistoryBloc>()
                        .add(SubCategoryListEvent(subCategory: value));
                  },
                      labelKey: 'name',
                      selectedKey: state.selectedSubCategory,
                      initialSelection: state.selectedSubCategory),
                  10.height,
                  Utils.dropdownBox(
                    'Select Expense To',
                    state.cohorts,
                    (value) {},
                    labelKey: 'name',
                    initialSelection: state.selectedCohorts,
                  ),
                  10.height,
                  CustomDateTimePicker<DateTime>(
                    controller: context
                        .read<VehicleExpenseHistoryBloc>()
                        .dateController,
                    format: "dd-MM-yyyy",
                    suffixIcon: Icon(Icons.calendar_month_rounded,
                        size: 18, color: context.theme.hintColor),
                    textAlign: TextAlign.center,
                    value: state.selectedDate,
                    onChanged: (value) => context
                        .read<VehicleExpenseHistoryBloc>()
                        .add(DateChangeEvent(selectedDate: value)),
                  ),
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Utils.getElevatedButton(
                        () {
                          context.read<VehicleExpenseHistoryBloc>().add(
                              UpdateVehicleExpenseHistoryEvent(
                                  id: "${state.editResponse['id']}"));
                          Future.delayed(
                              const Duration(seconds: 1),
                              () => context
                                      .pushReplacement(VehicleExpenseHistoryUI(
                                    vin: state.vin,
                                    vehicleName: state.vehicleName,
                                    showTotalAmount: showTotalAmount,
                                currentExpenseAmount: currentExpenseAmount,
                                  )));
                        },
                        text: 'Update',
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
