part of 'permission_add_edit_main_ui.dart';

class PermissionAddEditTextField extends StatelessWidget {
  const PermissionAddEditTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionAddEditBloc, PermissionAddEditState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title:  Text(context.read<PermissionAddEditBloc>().isEdit ? 'Edit Permission' : 'Add Permission' ),
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
                        key: context.read<PermissionAddEditBloc>().formKey,
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Permission Name'),
                            Utils.getTextFormField(
                              null, context.read<PermissionAddEditBloc>().nameController,
                              hintText: 'Enter Permission name',
                              autoValidate: context.watch<PermissionAddEditBloc>().autoValidateMode,
                              validator: (value)=>(value == null || value.isEmpty) ? 'Please Enter the Permission name' : null,),
                            Row(
                              children: [
                                Expanded(
                                  child: SuccessButton(
                                    text: context.read<PermissionAddEditBloc>().isEdit ? 'Update' : 'Save',
                                    onPressed: ()=>context.read<PermissionAddEditBloc>().add(SaveEvent()),
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
