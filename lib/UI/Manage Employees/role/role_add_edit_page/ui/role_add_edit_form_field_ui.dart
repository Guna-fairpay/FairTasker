part of 'role_add_edit_main_ui.dart';

class RoleAddEditFormFieldUI extends StatelessWidget {
  const RoleAddEditFormFieldUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleAddEditBloc, RoleAddEditState>(
      builder: (context, state) {
        return  Scaffold(
          appBar: CompactAppBar(
            titleWidget: Utils.getText(
              context.watch<RoleAddEditBloc>().isEdit == false ? 'Add Role' : 'Edit Role', style: context.textTheme.titleMedium?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),),
            foregroundColour: AppC.white,
            onClose: ()=> context.pop(),
          ),
          body: state is LoadingState ? Container(
            color: AppC.white,
          ): SafeArea(
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
                      key: context.read<RoleAddEditBloc>().formKey,
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(context.watch<RoleAddEditBloc>().isEdit == false)...[
                            const Text('Base On'),
                          Utils.dropdownBox(
                              'select base',
                              context.read<RoleAddEditBloc>().basedOn,
                              (value) => context.read<RoleAddEditBloc>().add(BaseOnEvent(value)),
                              labelKey: 'name',
                              initialSelection: context.read<RoleAddEditBloc>().selectedBase,
                          ),
                          ],
                         if(context.watch<RoleAddEditBloc>().selectedBase?['id'] == 2)...[
                           const Text('Users'),
                           Utils.dropdownBox(
                            'select a users',
                            context.read<RoleAddEditBloc>().user,
                                (value) => context.read<RoleAddEditBloc>().add(UserEvent(value)),
                            labelKey: 'first_name',
                            labelKey2: 'last_name',
                            initialSelection: context.read<RoleAddEditBloc>().selectedUser,
                             validator: (value)=>(value == null || value.isEmpty) ? 'Please Select the User' : null,
                             autovalidateMode: context.read<RoleAddEditBloc>().autoValidateMode,
                           ),
                         ],
                          if(context.watch<RoleAddEditBloc>().isUserEdit)...[
                            const Text('Users'),
                            Utils.getTextFormField(
                              readOnly: true,
                              fillColor: AppC.lightGray,
                              null, context.read<RoleAddEditBloc>().userController,
                              hintText: 'Enter Role',
                              autoValidate: context.watch<RoleAddEditBloc>().autoValidateMode,
                              validator: (value)=>(value == null || value.isEmpty) ? 'Please Enter the Role' : null,
                            ),
                          ],
                          if(context.watch<RoleAddEditBloc>().selectedBase?['id'] == 1
                          || context.watch<RoleAddEditBloc>().isRoleEdit)...[
                            const Text('Role'),
                            Utils.getTextFormField(
                              readOnly: context.watch<RoleAddEditBloc>().isEdit,
                              fillColor: context.watch<RoleAddEditBloc>().isEdit ? AppC.lightGray : AppC.white,
                              null, context.read<RoleAddEditBloc>().roleController,
                              hintText: 'Enter Role',
                              autoValidate: context.watch<RoleAddEditBloc>().autoValidateMode,
                              validator: (value)=>(value == null || value.isEmpty) ? 'Please Enter the Role' : null,
                            ),
                          ],
                          const Text('Permissions'),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: context.read<RoleAddEditBloc>().permission.length,
                            itemBuilder: (context, index) {
                              var item = context.read<RoleAddEditBloc>().permission[index];
                              return CustomCheckboxListTile(
                                borderColor: AppC.grey,
                                radius: 8,
                                title: Text(item['name']),
                                value: context.read<RoleAddEditBloc>().selectedPermissionId.contains(item['id']),
                                onChanged: (value) => context.read<RoleAddEditBloc>().add(PermissionEvent(item)),
                              );
                            }
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SuccessButton(
                                  text: context.watch<RoleAddEditBloc>().isEdit == false ? 'Save' : 'Update',
                                  onPressed: ()=>context.read<RoleAddEditBloc>().add(SaveEvent()),
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
