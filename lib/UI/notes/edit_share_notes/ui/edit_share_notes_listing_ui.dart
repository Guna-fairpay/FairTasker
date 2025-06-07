part of 'edit_share_notes_main_ui.dart';

class EditShareNotesListingUI extends StatelessWidget {
  const EditShareNotesListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditShareNotesBloc, EditShareNotesState>(
      builder: (context, state) {
        return Form(
          key: context.read<EditShareNotesBloc>().formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: 10.verticalPadding,
            children: [
              Utils.getTextFormField(
                  'Product Title',
                  context.read<EditShareNotesBloc>().titleController,
                autoValidate: context.watch<EditShareNotesBloc>().autoValidateMode,
                validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
              ),
              10.spMin.height,
              ListView.separated(
                separatorBuilder: (context, index) => 10.spMin.height,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: context.watch<EditShareNotesBloc>().noteItems.length,
                itemBuilder: (context,index) {
                  var model = context.watch<EditShareNotesBloc>().noteItems[index];
                 return  Row(
                    spacing: 10,
                    children: [
                      Checkbox(
                          value: model['complete_status'] == 1 ? true : false,
                          onChanged: (m) => context.read<EditShareNotesBloc>().add(CheckEvent(model: model, completeStatus: m))),
                      Expanded(
                          child: Utils.getTextFormField(
                            null,
                           (model['title'] as TextEditingController),
                            hintText: 'Enter Task/Products',
                            minLines: 2,
                            maxLines: 2,
                            autoValidate: context.watch<EditShareNotesBloc>().autoValidateMode,
                            validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                          )),
                      CustomDateTimePicker<DateTime>(
                        format: 'dd-MM-yyyy',
                        padding: 5.padding,
                        controller: (model['date'] as TextEditingController),
                        suffixIcon: Icon(
                          Icons.calendar_month_rounded, size: 12.spMin,),
                        value: (model['end_date']).toString().toDateTime() ?? DateTime.now(),
                        onChanged: (value) =>
                            context.read<EditShareNotesBloc>().add(
                                DatePickerEvent(date: value, model: model)),

                      ),
                      if(context.watch<EditShareNotesBloc>().noteItems.length > 1)
                      InkWell(
                        onTap: ()=> context.read<EditShareNotesBloc>().add(DeleteDialogEvent(model)),
                        child: const Icon(
                            Icons.remove_rounded, color: AppC.appColor),
                      ),
                    ],
                  );
                }
              ),
              10.spMin.height,
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => context.read<EditShareNotesBloc>().add(AddEvent()),
                  child: const Icon(Icons.add, color: AppC.appColor,),
                ),
              ),
              10.spMin.height,
              Align(
                alignment: Alignment.centerLeft,
                child: SuccessButton(
                  text: 'Save Product',
                  onPressed: () => context.read<EditShareNotesBloc>().add(SaveEvent( context.read<EditShareNotesBloc>().noteItems)),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
