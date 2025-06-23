import 'package:fairpytasker/Component/simple_popup_menu.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/UI/vehicle_main_view_ui.dart';
import 'package:fairpytasker/UI/Todo/add_todo_ui.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_view/ui/cumulative_expense_main_page.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_checklist/UI/vehicle_status_checklist_ui.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_config/UI/vehicle_status_config_ui.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_list/bloc/vehicle_status_config.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_list/bloc/vehicle_status_events.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_list/bloc/vehicle_status_bloc.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_list/bloc/vehicle_status_states.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_status_list/vehicle_status_list_body.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/vehicle_history_view_ui.dart';
import 'package:fairpytasker/UI/vehicle_status/vehicle_notes_page/UI/vehicle_notes_history_main_ui.dart';
import 'package:fairpytasker/UI/dialog/show_notes_dialog.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/UI/transportcar_pop.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VehicleStatusListUi extends StatelessWidget {
  const VehicleStatusListUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          VehicleStatusBloc()..add(VehicleStatusInitialEvent()),
      child: BlocListener<VehicleStatusBloc, VehicleStatusState>(
          listener: (context, state)  {
            if (state is VehicleStatusLoadingState) {
              if (!EasyLoading.isShow) EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              switch(state) {
                case VehicleStatusErrorState(): Toaster.showError("${state.errorMessage}"); break;
                case VehicleStatusSuccessState(): Toaster.showSuccess("${state.successMessage}"); break;
                case VehicleStatusOnPressedState(): {
                  var pressType = state.type;
                  var data = state.data;
                  var tripCategory = state.tripCategory;
                  if ((pressType != null) && (data != null)) {
                    switch(pressType) {

                      case VehicleStatusOnPressed.last_checklist:
                        context.push(VehicleStatusChecklistUI(
                          vehicleName: data['vehicle_name'] ?? '',
                          vin: data['vin'] ?? '',
                          data:data,
                        )
                        );
                      case VehicleStatusOnPressed.vehicle_config:
                        context.push(VehicleStatusConfigUI(
                          // vehicleStatusListData: data,
                          vehicleName: data['vehicle_name'] ?? '',
                          vin: data['vin'] ?? '',
                        ));
                      case VehicleStatusOnPressed.vehicle_edit:
                        context.push(VehicleNotesHistoryViewUi(
                          vin: data['vin'] ?? '',
                          vehicleName: data['vehicle_name'] ?? '',
                        ));
                      case VehicleStatusOnPressed.vehicle_details:
                        context.push(VehicleHistoryViewUI(
                          vehicleName: data['vehicle_name'] ?? '',
                          vin: data['vin'] ?? '',
                          isAsset: true,
                        ));
                      case VehicleStatusOnPressed.date_pickup:
                        Utils.showPickerDate(context, value: (data['followup_date'] ?? "").toString().toDateTime(inputFormat: "yyyy-MM-dd"), onChanged: (value) => context.read<VehicleStatusBloc>().add(VehicleStatusSaveDateEvent(data, value)));
                      case VehicleStatusOnPressed.view_history:
                        context.push(VehicleHistoryViewUI(
                          vehicleName: data['vehicle_name'] ?? '',
                          vin: data['vin'] ?? '',
                          isAsset: true,
                        ));
                      case VehicleStatusOnPressed.view_expense:
                        context.push(CumulativeExpenseMainPage(data: data));
                        // context.push(CumulativeCostListUI(vehicleStatusListData: data, createExpenseFieldData: CreateExpenseFieldData()));
                      case VehicleStatusOnPressed.add_vehicle:
                        context.push(const CreateTodoUI());
                      case VehicleStatusOnPressed.view_notes:
                        NotesDialog.show(context, message: data['note']);
                      case VehicleStatusOnPressed.vehicle_page:
                        context.push(VehicleMainViewUi(vin: data['vin'],));
                    }
                  }
                } break;
                case VehicleStatusShowDatePickerState(): {
                  var data = state.data;
                  Utils.showPickerDate(context, value: data?['followup_date'].toString().toDateTime(inputFormat: "yyyy-MM-dd"), onChanged: (value) => context.read<VehicleStatusBloc>().add(VehicleStatusSaveDateEvent(data, value)));
                } break;
                case VehicleStatusShowSortingState(): {
                  var details = state.details;
                  if (details != null) {
                    var offSet = Offset(details.globalPosition.dx, details.globalPosition.dy);
                    var items = context.read<VehicleStatusBloc>().filterBys;
                    SimplePopUpMenu.instance.show(context, items: items, position: offSet, itemAsString: (item) => item['name'] ?? "", onTap: (item) => context.read<VehicleStatusBloc>().add(VehicleStatusSortEvent(item)));
                  }
                } break;
                case VehicleStatusCompletedPopupState(): {
                  TransportCarPopup.show(context,model:  state.data,
                  isComplete: true,
                  );
                }break;
                case VehicleStatusPreviousPopupState():{
                  TransportCarPopup.show(context,model: state.data,
                    isComplete: false,
                  );
                }
                }
            }
          }, child: const VehicleStatusListBody()),
    );
  }
}
