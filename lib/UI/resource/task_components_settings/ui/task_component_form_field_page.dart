import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/resource/task_components_settings/bloc/task_components_bloc.dart';
import 'package:fairpytasker/UI/resource/task_components_settings/bloc/task_components_event.dart';
import 'package:fairpytasker/UI/resource/task_components_settings/bloc/task_components_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskComponentFormFieldPage extends StatelessWidget {
  const TaskComponentFormFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskComponentBloc, TaskComponentState>(
        builder: (context, state) {
          return Form(
            key: context.read<TaskComponentBloc>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Utils.dropdownBox('',
                    context.read<TaskComponentBloc>().baseList,
                    (value) => context.read<TaskComponentBloc>().add(TaskComponentDropdownBaseEvent(value: value)),
                    labelKey: 'title',
                  initialSelection: context.read<TaskComponentBloc>().selectedBase,
                ),
                if(context.read<TaskComponentBloc>().isHourBased)
                Utils.dropdownBox('Select User',
                    context.read<TaskComponentBloc>().resourceList,
                    (value) => context.read<TaskComponentBloc>().add(TaskComponentResourceDropdownEvent(value: value)),
                    initialSelection: context.read<TaskComponentBloc>().selectedResource,
                    selectedKey: context.read<TaskComponentBloc>().selectedResource,
                    labelKey: 'first_name',
                  labelKey2: 'last_name',
                  autovalidateMode: context.watch<TaskComponentBloc>().autoValidateMode,
                  validator: (value) => (context.read<TaskComponentBloc>().selectedResource == null) ? 'Select User' : null,
                ),
                if(!context.read<TaskComponentBloc>().isHourBased)
                Utils.getTextFormField(
                  'Task Name',
                  context.read<TaskComponentBloc>().taskNameController,
                  autoValidate: context.watch<TaskComponentBloc>().autoValidateMode,
                  validator: (value) => (value == null || value.isEmpty) ? 'Enter Task Name' : null,
                ),
                Utils.getTextFormField(
                    'Amount per hour (\$)',
                    context.read<TaskComponentBloc>().amountController,
                    textType: const TextInputType.numberWithOptions(decimal: true),
                    textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    autoValidate: context.watch<TaskComponentBloc>().autoValidateMode,
                    validator: (value) => (value == null || value.isEmpty) ? 'Enter Amount' : null,
                  inputAction: TextInputAction.done,
                ),
                Row(
                  spacing: 10,
                  children: [
                    if(!context.read<TaskComponentBloc>().isEdit)...[
                      SuccessButton(
                      text: 'Save',
                      onPressed: () => context.read<TaskComponentBloc>().add(TaskComponentSaveEvent()),
                    ),],
                    if(context.read<TaskComponentBloc>().isEdit)...[SuccessButton(
                      text: 'Update',
                      onPressed: () => context.read<TaskComponentBloc>().add(TaskComponentSaveEvent()),
                    ),
                    SuccessButton(
                      text: 'Cancel',
                      backgroundColor: AppC.redAccent,
                      onPressed: () => context.read<TaskComponentBloc>().add(TaskComponentClearAllFieldEvent()),
                    ),]
                  ],
                ),
              ],
            ),
          );
        }
    );
  }
}
