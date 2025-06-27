part of 'leads_main_ui.dart';

class LeadsTextFormFieldUI extends StatelessWidget {
  const LeadsTextFormFieldUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeadsBloc, LeadsState>(
        builder: (context, state) {
          return Form(
            key: context.read<LeadsBloc>().formKey,
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getTextFormField('Customer Name', context.read<LeadsBloc>().customerNameController),
                Utils.getTextFormField(
                    'Email',
                    context.read<LeadsBloc>().emailController,
                    autoValidate: context.watch<LeadsBloc>().autoValidateMode,
                    validator: (value) => ((value ?? '').isNotEmpty && (value ?? '').isValidEmail()) ? null : 'Invalid Email'
                ),
                Utils.getTextFormField('Contact Number', context.read<LeadsBloc>().contactNumberController),
                Utils.getTextFormField('Notes', context.read<LeadsBloc>().notesController, maxLines: 3, minLines: 3),
               if(context.watch<LeadsBloc>().showMore)...[
                 Utils.getTextFormField('Car Name', context.read<LeadsBloc>().carNameController),
                 Utils.getTextFormField('Plate No', context.read<LeadsBloc>().plateNoController),
                 Utils.getTextFormField('Part Time/Full Time', context.read<LeadsBloc>().partOrFullTimeController),
                 Utils.getTextFormField('Available Days', context.read<LeadsBloc>().availableDaysController),
                 Utils.getTextFormField('Shift', context.read<LeadsBloc>().shiftController),
                 Utils.getTextFormField('Driver Rating', context.read<LeadsBloc>().driverRatingController),
                 Utils.getTextFormField('Satisfaction rate 100%', context.read<LeadsBloc>().satisfactionRateController),
                 Utils.getTextFormField('Acceptance rate 100%', context.read<LeadsBloc>().acceptanceRateController),
                 Utils.getTextFormField('Cancellation rate 100%', context.read<LeadsBloc>().cancellationRateController),
                 Utils.getTextFormField('Tenure', context.read<LeadsBloc>().tenureController),
                 Utils.getTextFormField('Rating', context.read<LeadsBloc>().ratingController),
                 Utils.getTextFormField('Total Trips', context.read<LeadsBloc>().totalTripsController),
                 Utils.getTextFormField('Uber Pro', context.read<LeadsBloc>().uberProController),
                 Utils.getTextFormField('Applied At', context.read<LeadsBloc>().appliedAtController),
                 Utils.getTextFormField('Day', context.read<LeadsBloc>().dayController),
                 Utils.getTextFormField('Location', context.read<LeadsBloc>().locationController),
                 Utils.getTextFormField('Rental Model', context.read<LeadsBloc>().rentalModelController),
                 Utils.getTextFormField('Invite State', context.read<LeadsBloc>().inviteStatusController),
                 Utils.dropdownBox(
                     'Select Active Status',
                     context.read<LeadsBloc>().activeStatus,
                     (value)=> context.read<LeadsBloc>().add(ActiveStatesEvent(value)),
                     labelKey: 'name',
                 ),
                 Utils.getTextFormField('Background Check', context.read<LeadsBloc>().backgroundCheckController),
                 Utils.getTextFormField("Driver's License", context.read<LeadsBloc>().driverLicenseController),
                 Utils.getTextFormField('Profile Picture', context.read<LeadsBloc>().profilePictureController),
               ],
                GestureDetector(
                    onTap: ()=> context.read<LeadsBloc>().add(ShowMoreEvent()),
                    child: Text(context.watch<LeadsBloc>().showMore ? 'Less ...' : 'More ...')
                ),
                Row(
                  spacing: 10,
                  children: [
                    if(!context.watch<LeadsBloc>().isEdit)...[
                      SuccessButton(
                        text: 'Save',
                        onPressed: () => context.read<LeadsBloc>().add(SaveEvent()),
                      ),
                      20.spMin.width
                    ],
                    if(context.watch<LeadsBloc>().isEdit)...[
                      CompactIconButton(
                        icon: RemixIcons.save_2_line,
                        iconSize: 18.spMin,
                        backgroundColor: AppC.green,
                        onPressed: () => context.read<LeadsBloc>().add(SaveEvent()),
                        shape: WidgetStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                      ),
                      CompactIconButton(
                        icon: RemixIcons.close_line,
                        iconSize: 18.spMin,
                        backgroundColor: AppC.redAccent,
                        onPressed: () => context.read<LeadsBloc>().add(CloseEvent()),
                        shape: WidgetStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                      ),
                    ],
                    Expanded(
                      flex: 3,
                      child: CompactSearchView(
                        controller: context.read<LeadsBloc>().searchController,
                        onChanged: (value) => context.read<LeadsBloc>().add(SearchEvent(value)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }
    );
  }
}
