
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_bloc.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_event.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/Bloc/transport_car_complete_state.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/UI/category_selection_field.dart';
import 'package:fairpytasker/UI/dialog/transport_car_dialog/UI/next_task_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransportCarPopup {
  TransportCarPopup._();
  static void show(BuildContext context,
      Map<String, dynamic>? model,{
    VoidCallback? onSave,
    VoidCallback? onIgnore,
        VoidCallback? onConfirm,
        VoidCallback? onCancel,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _TransportCarPopView(
        onSave: onSave,
        onIgnore: onIgnore,
        model: model,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}

class _TransportCarPopView extends StatelessWidget {
  final VoidCallback? onSave;
  final VoidCallback? onIgnore;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Map<String, dynamic>? model;
  const _TransportCarPopView({Key? key, this.onSave, this.onIgnore, this.model,this.onConfirm,this.onCancel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TCCDBloc>(
      create: (context) => TCCDBloc()..add(TCCDInitialEvents(model: model)),
      child: BlocListener<TCCDBloc, TCCDState>(
        listener: (context, state) {
          if(state is TCCDLoadingState)EasyLoading.show();
          if(state is TOCDCommonState)EasyLoading.dismiss();
        },
        child: AlertDialog(
            alignment: Alignment.topCenter,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
            backgroundColor: AppC.white,
            insetPadding: 10.sp.padding,
            titlePadding: EdgeInsets.zero,
            contentPadding: 5.sp.padding.copyWith(left: 20.sp, right: 20.sp, bottom: 20.sp),
            title: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () =>context.pop(),
                  icon: const Icon(Icons.close_outlined)),
            ),
            content: BlocBuilder<TCCDBloc, TCCDState>(
              builder: (context,state) {
                return SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CategorySelectionField(
                            model: model,
                            onConfirm: onConfirm,
                            onCancel: onCancel,
                          ),
                          NextTaskUI(
                            onSave: onSave,
                            onIgnore: onIgnore,
                          )
                        ]
                    ),
                  ),
                );
              }
            )
        ),
      ),
    );
  }
}
