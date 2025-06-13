part of 'department_add_edit_main_ui.dart';

class DepartmentAddEditTextFieldUI extends StatelessWidget {
  const DepartmentAddEditTextFieldUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentAddEditBloc, DepartmentAddEditState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title:  Text(context.read<DepartmentAddEditBloc>().isEdit ? 'Edit Department' : 'Add Department' ),
              titleTextStyle:
              context.textTheme.titleMedium?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),
              backgroundColor: AppC.appColor,
              foregroundColor: AppC.white,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: ()=>context.pop(),
                  icon: const Icon(Icons.close_outlined),
                ),
              ],
            ),
          body: SafeArea(
            minimum: const EdgeInsets.all(10),
            child: ListView(
              physics:const BouncingScrollPhysics(),
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all( color: AppC.grey,width: 0.5)
                    ),
                    padding: EdgeInsets.all(16.spMin),
                    child:  Form(
                      key: context.read<DepartmentAddEditBloc>().formKey,
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Department Name'),
                          Utils.getTextFormField(
                            null, context.read<DepartmentAddEditBloc>().nameController,
                            hintText: 'Enter Department name',
                            autoValidate: context.watch<DepartmentAddEditBloc>().autoValidateMode,
                            validator: (value)=>(value == null || value.isEmpty) ? 'Please Enter the name' : null,),
                          const Text('Head'),
                          Utils.dropdownBox(
                              'Select a head',
                              context.read<DepartmentAddEditBloc>().headsList,
                            (value)=> context.read<DepartmentAddEditBloc>().add(HeadSelectionEvent(value: value)),
                              labelKey: 'first_name',
                            labelKey2: 'last_name',
                            initialSelection: context.read<DepartmentAddEditBloc>().selectedHead,
                            autovalidateMode: context.watch<DepartmentAddEditBloc>().autoValidateMode,
                            validator: (value)=> (value == null || value.isEmpty) ?'Please select department head' : null,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SuccessButton(
                                  text: context.read<DepartmentAddEditBloc>().isEdit ? 'Update' : 'Save',
                                  onPressed: ()=>context.read<DepartmentAddEditBloc>().add(SaveEvent()),
                                  backgroundColor: AppC.appColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
