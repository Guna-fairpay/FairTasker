
import 'package:fairpytasker/UI/Todo/private_rental/Bloc/private_renal_check_list_bloc.dart';
import 'package:fairpytasker/UI/Todo/private_rental/Bloc/private_rental_check_list_event.dart';
import 'package:fairpytasker/UI/Todo/private_rental/Bloc/private_rental_check_list_state.dart';
import 'package:fairpytasker/UI/Todo/private_rental/UI/private_rental_check_listing_page.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/maintenance_check/maintenance_check_confirmation_dialog.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PrivateRentalCheckMainPage extends StatelessWidget {
  final dynamic todoData;
  const PrivateRentalCheckMainPage({super.key, required this.todoData});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider<PrivateRenalCheckBloc>(
        create: (context)=>PrivateRenalCheckBloc()..add(PrivateRentalCheckInitialEvent(todoData:todoData)),

        child: BlocListener<PrivateRenalCheckBloc,PrivateRentalCheckState>(
          listener: (context, state) {
            if(state is PrivateRentalCheckLoadingState) EasyLoading.show();
            if(state is PrivateRentalCheckCommonState) EasyLoading.dismiss();
            if(state  is PrivateRentalCheckSuccessState) context.pop();
            if(state is PrivateRentalCheckPopupState) {
              MaintenanceCheckConfirmDialog.show(context, model: state.model,
                onComplete:()=>context.read<PrivateRenalCheckBloc>().add(PrivateRentalCheckCompleteEvent(state.model)),
                onDelete: ()=>context.read<PrivateRenalCheckBloc>().add(PrivateRentalCheckDeleteEvent(state.model)));
            }
            if(state is PrivateRentalCheckDialogState){
              AskPermissionDialog.show(context,
                  title: "Are you sure?",
                  description: "${Session.of.getString("name")},  are you sure you want to delete this task? Kindly enter a valid reason to confirm the deletion",
            boldWords: [(Session.of.getString("name") ?? ''),","],
            positiveText: "Yes, delete it!",
            negativeText: "Cancel",
            isReasonRequired: true,
            onReasonSubmitted: (reason) => context.read<PrivateRenalCheckBloc>().add(PrivateRentalCheckDeleteEvent(state.model, reason: reason)));
          }
          },
            child: const PrivateRentalCheckListingPage()));
  }
}
