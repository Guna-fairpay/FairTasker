import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/notes/edit_share_notes/component/delete_alert_dialog.dart';
import 'package:fairpytasker/UI/notes/shared_notes/component/share_notes_edit_dialog/bloc/share_notes_edit_dialog_bloc.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShareNotesEditDialogUI {
  ShareNotesEditDialogUI._();
  static void show({
    required BuildContext context,
    dynamic model,
    List<dynamic>? list,
  }) async {
    await showDialog(
        context: context,
        builder: (context) => _ShareNotesEditDialogUI(model: model, list: list),
        barrierDismissible: false);
  }
}

class _ShareNotesEditDialogUI extends StatelessWidget {
  final dynamic model;
  final List<dynamic>? list;

  const _ShareNotesEditDialogUI({
    super.key,
    required this.model,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ShareNotesEditDialogBloc()..add(InitialEvent(model: model, list: list)),
      child: BlocListener<ShareNotesEditDialogBloc, ShareNotesEditDialogState>(
        listener: (context, state) {
          if(state is LoadingState){
            EasyLoading.show();
          } else{
            if (state is! SuccessState) if (EasyLoading.isShow) EasyLoading.dismiss();
            switch(state){
              case ErrorState(): Toaster.showError(state.message);
                break;
              case SuccessState():{
                Toaster.showSuccess(state.message);
                context.pop();
              }
              break;
              case DeleteDialogState():{
                DeleteAlertDialog.show(context, onChanged:()=> context.read<ShareNotesEditDialogBloc>().add(DeleteEvent()));
              }
              break;
              default: break;
            }
          }
        },
        child: BlocBuilder<ShareNotesEditDialogBloc, ShareNotesEditDialogState>(
            builder: (context, state) {
              return AlertDialog(
                insetPadding: 16.spMin.padding,
                contentPadding: 16.spMin.horizontalPadding.copyWith(bottom: 16.spMin),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
                alignment: Alignment.center,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                title: ListTile(
                  title: Text(context.read<ShareNotesEditDialogBloc>().title ?? ''),
                  contentPadding: 0.padding.copyWith(left: 16.spMin),
                  trailing: IconButton(onPressed: context.pop, icon: const Icon(Icons.close)),
                ),
                titlePadding: 0.padding,
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    spacing: 16.spMin,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Utils.getTextFormField(
                          null,
                          context.read<ShareNotesEditDialogBloc>().editProductController,
                          hintText: 'Edit Product',
                          maxLines: 2,
                          minLines: 2
                      ),
                      CustomDateTimePicker<DateTime>(
                          controller: context.read<ShareNotesEditDialogBloc>().dateController,
                        format: 'dd-MM-yyyy',
                        value: context.watch<ShareNotesEditDialogBloc>().selectedDate,
                        labelText: 'Select Date',
                        onChanged: (value)=> context.read<ShareNotesEditDialogBloc>().add(DateEvent(value)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 10,
                        children: [
                          SuccessButton(
                            text: 'Save',
                            icon: Icons.save_rounded,
                            foregroundColor: Colors.white,
                            onPressed: (){
                              context.read<ShareNotesEditDialogBloc>().add(SaveEvent());
                            },
                          ),
                          if(context.read<ShareNotesEditDialogBloc>().isDelete)
                          SuccessButton(
                            text: 'Delete',
                            backgroundColor: Colors.redAccent,
                            icon: Icons.delete_outline_rounded,
                            foregroundColor: Colors.white,
                            onPressed: (){
                              context.read<ShareNotesEditDialogBloc>().add(DeleteDialogEvent());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}
