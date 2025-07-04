part of 'task_component_main_page.dart';

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
                    (value) => context.read<TaskComponentBloc>().add(DropdownBaseEvent(value: value)),
                    labelKey: 'title',
                  initialSelection: context.read<TaskComponentBloc>().selectedBase,
                ),
                if(context.read<TaskComponentBloc>().isHourBased)
                Utils.dropdownBox('Select User',
                    context.read<TaskComponentBloc>().resourceList,
                    (value) => context.read<TaskComponentBloc>().add(ResourceDropdownEvent(value: value)),
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
                      onPressed: () => context.read<TaskComponentBloc>().add(SaveEvent()),
                    ),],
                    if(context.read<TaskComponentBloc>().isEdit)...[SuccessButton(
                      text: 'Update',
                      onPressed: () => context.read<TaskComponentBloc>().add(SaveEvent()),
                    ),
                    SuccessButton(
                      text: 'Cancel',
                      backgroundColor: AppC.redAccent,
                      onPressed: () => context.read<TaskComponentBloc>().add(ClearAllFieldEvent()),
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
