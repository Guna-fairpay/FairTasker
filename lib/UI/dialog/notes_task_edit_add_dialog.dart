import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/notes/bloc/notes_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class NotesTaskAddEditDialog {
  NotesTaskAddEditDialog._();

  static void show(BuildContext context, {
    required Map<String, dynamic>? model,
    ValueChanged<String>? onChanged,
    bool isEdit = false,
    final VoidCallback? onDeletePressed,
    final Function(Map<String, dynamic>? value)? onTimePicker,
  }) async {
    await showDialog(
        context: context,
        builder: (dialogContext) => BlocProvider.value(
          value: BlocProvider.of<NotesBloc>(context),
            child: _NotesTaskAddEditDialogView(model: model, onChanged: onChanged, isEdit: isEdit, onDeletePressed: onDeletePressed, onTimePicker: onTimePicker,)),
        barrierDismissible: true);
  }
}

class _NotesTaskAddEditDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  final TextEditingController _controller = TextEditingController();
  final ValueChanged<String>? onChanged;
  final VoidCallback? onDeletePressed;
  final Function(Map<String, dynamic>? value)? onTimePicker;
  final bool isEdit;
  _NotesTaskAddEditDialogView({this.model, this.onChanged, required this.isEdit, this.onTimePicker, this.onDeletePressed}) {
    if (isEdit) _controller.text = model?['title'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      backgroundColor: Colors.white,
      title: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        trailing: IconButton(onPressed: context.popDialog, icon: const Icon(Icons.close_rounded)),
      ),
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      // contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      insetPadding: 10.padding,
      content: BlocBuilder<NotesBloc, NotesStates>(
        builder: (context, state) {
          return SizedBox(
            width: double.maxFinite,
            child: Column(
              spacing: 5.sp,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Flexible(child: Utils.getTextFormField("Notes", _controller)),
                    if(isEdit)...[
                      GestureDetector(
                        onTap: ()=> onTimePicker?.call(model),
                          child:context.read<NotesBloc>().editTaskTime != null
                              ? Text((context.watch<NotesBloc>().editTaskTime).toDateTime.toFormat(format: 'hh:mm a') ?? '')
                              : const Icon(Iconsax.clock, color: AppC.appColor)
                      ),
                    if(model?['note_time'] == null )...[
                      IconButton(
                        onPressed: onDeletePressed,
                        icon: const Icon(Iconsax.trash),
                        color: AppC.redAccent,
                        style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),),]
                    ]
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SuccessButton(
                      text: "Save",
                      onPressed: () {
                        if (_controller.text.trim().isNotNullOrEmpty) {
                          onChanged?.call(_controller.text);
                          context.popDialog();
                        }
                      },
                    ),
                  ],
                )
              ]
            ),
          );
        }
      ),
    );
  }
}
