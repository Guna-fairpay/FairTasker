
import 'package:fairpytasker/Component/bottom_nav_for_task.dart';
import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_single_selection_field.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/UI/Finance/Expense/UI/Vehicle/Bloc/add_expense_vehicle_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/UI/Vehicle/Event/add_expense_vehicle_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/UI/Vehicle/State/add_expense_vehicle_state.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ExpenseVehicleAddUI extends StatelessWidget {
  const ExpenseVehicleAddUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddExpenseVehicleBloc>(
      create: (context) => AddExpenseVehicleBloc()..add(const GetVehicleExpenseAddData()),
      child: BlocListener<AddExpenseVehicleBloc, AddExpenseVehicleState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
        },
        child:
            BlocBuilder<AddExpenseVehicleBloc, AddExpenseVehicleState>(builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                foregroundColor: Colors.white,
                backgroundColor: AppC.appColor,
                title: const Text('Add Expense'),
                actions: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: AppC.white,
                      ))
                ],
              ),
              body: SafeArea(
                  minimum: 10.padding,
                  child: Form(
                    child: ListView(
                      children: [
                        Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context
                                    .read<AddExpenseVehicleBloc>()
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
                                          color: AppC.blue,
                                          weight: FontWeight.bold),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context
                                    .read<AddExpenseVehicleBloc>()
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
                                        description:
                                            "Do you want to delete this Expense Image?",
                                        positiveText: "Yes, delete it!",
                                        negativeText: "Cancel",
                                        isReasonRequired: false,
                                        onPositivePressed: () => context
                                            .read<AddExpenseVehicleBloc>()
                                            .add(RemoveImageEvent(
                                                data: state.expenseAttachments[
                                                    index])));
                                  },
                                  child: Stack(
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
                                            color: AppC.grey
                                                .withValues(alpha: 0.2)),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: ImageViewer(
                                          fit: BoxFit.cover,
                                          imageInput:
                                              state.expenseAttachments[index],
                                          isNotImage:
                                              !((state.expenseAttachments[index]
                                                      as Object)
                                                  .isImage),
                                        ),
                                      ),
                                      if ((state.expenseAttachments[index]
                                              as Object)
                                          .isPDF)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppC.green,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Utils.openURL(state
                                                  .expenseAttachments[index]);
                                            },
                                            child: Padding(
                                              padding: 4.padding,
                                              child: const Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: AppC.white,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )),
                            ),
                          ),
                        10.height,
                        CustomSingleSelectionField<Map<String, dynamic>>(
                          suggestionsList: state.vehicleList,
                          itemAsString: (item) => item['vehicle_name'] ?? '',
                          selected: state.selectedVehicle,
                          labelText: "Vehicle Name",
                          hintText: "",
                          onSelected: (val) {
                            context
                                .read<AddExpenseVehicleBloc>()
                                .add(VehicleEvent(selectedVehicle: val));
                          },
                          controller:
                              context.read<AddExpenseVehicleBloc>().vehicleController,
                        ),
                        10.height,
                        Row(
                          children: [
                            Expanded(
                              child: Utils.getTextFormField(
                                'Amount in dollars',
                                context.read<AddExpenseVehicleBloc>().amountController,
                                textType: const TextInputType.numberWithOptions(decimal: true),
                                inputAction: TextInputAction.done,
                                textInputFormatter:[
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                                ],
                              ),
                            ),
                            10.width,
                            Expanded(
                              child: Utils.dropdownBox(
                                  'Select Payment Method',
                                  state.paymentType,
                                  (value) => context.read<AddExpenseVehicleBloc>().add(
                                      SelectedPaymentEvent(paymentType: value)),
                                  labelKey: 'name'),
                            ),
                          ],
                        ),
                        10.height,
                        Utils.getTextFormField(
                          'Enter Description',
                          context.read<AddExpenseVehicleBloc>().descriptionController,
                          inputAction: TextInputAction.done,
                        ),
                        10.height,
                        Utils.dropdownBox(
                          'Select Category',
                          state.categories,
                          (value) => context
                              .read<AddExpenseVehicleBloc>()
                              .add(CategoryListEvent(selectedCategory: value)),
                          labelKey: 'name',
                        ),
                        10.height,
                        Utils.dropdownBox(
                          'Select Sub Category',
                          state.subCategories,
                          (value) => context.read<AddExpenseVehicleBloc>().add(
                              SubCategoryListEvent(selectedSubCategory: value)),
                          labelKey: 'name',
                          selectedKey: state.selectedSubCategory,
                          initialSelection: state.selectedSubCategory,
                        ),
                        10.height,
                        Utils.dropdownBox(
                          'Select Expense To',
                          state.cohorts,
                          (value) => context
                              .read<AddExpenseVehicleBloc>()
                              .add(CohortListEvent(selectedCohort: value)),
                          labelKey: 'name',
                          selectedKey: state.selectedCohorts,
                          initialSelection: state.selectedCohorts,
                        ),
                        10.height,
                        CustomDateTimePicker<DateTime>(
                          controller:
                              context.read<AddExpenseVehicleBloc>().dateController,
                          format: "dd-MM-yyyy",
                          suffixIcon: Icon(Icons.calendar_month_rounded,
                              size: 18, color: context.theme.hintColor),
                          textAlign: TextAlign.center,
                          value: state.selectedDate,
                          onChanged: (value) => context
                              .read<AddExpenseVehicleBloc>()
                              .add(DateChangeEvent(selectedDate: value)),
                        ),
                        10.height,
                        Utils.getTextFormField('Odometer Reading',
                            context.read<AddExpenseVehicleBloc>().odometerController,
                            textType: TextInputType.number,
                            suffixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Icon(
                                Icons.speed,
                                color: AppC.redAccent,
                              ),
                            )),
                        10.height,
                        Utils.getElevatedButton(
                          () {
                            context.read<AddExpenseVehicleBloc>().add(const SaveExpenseEvent());
                            Future.delayed(
                              const Duration(seconds: 1),
                                  () => Navigator.pop(context),
                            );
                           // context.pushAndRemoveUntil(const BottomNavigationForTaskView(selectedIndex: 4, message: '',));
                          }
                        )
                      ],
                    ),
                  )));
        }),
      ),
    );
  }
}
