part of 'precheck_main_ui.dart';

class PrecheckListingUI extends StatelessWidget {
  const PrecheckListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrecheckBloc, PrecheckState>(
      builder: (context, state) => SafeArea(
        minimum: 10.spMin.verticalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...context.watch<PrecheckBloc>().precheckList.map((e) {
              var file = context.watch<PrecheckBloc>().attachmentPaths;
            return Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10.spMin,
                    children: [
                      FittedBox(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(14.spMin),
                          child: Checkbox(
                            activeColor: AppC.appColor,
                            value: e['check_value'] == 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: const BorderSide(width: 0.8, color: AppC.appColor),
                            onChanged:(v)=> context.read<PrecheckBloc>().add(
                                CheckEvent(payload: e,
                                    showDialog: (e['id'] == 4 && e['check_value'] == 1))),
                          ),
                        ),
                      ),
                      Expanded(child: InkWell(
                        onTap:()=> context.read<PrecheckBloc>().add(TextTapEvent(e)),
                          child: CompactText(e['title'], overflow: TextOverflow.visible,))),
                      // CustomCheckboxListTile(
                      //   title: CompactText(e['title']),
                      //   onChanged: (v)=> context.read<PrecheckBloc>().add(CheckEvent(payload: e, showDialog: (e['id'] == 4 && e['check_value'] == 1))),
                      //   value:e['check_value'] == 1,
                      //   padding: 0.padding,
                      //   wrapExpand: true,
                      //   useFlexible: true,
                      //   mainAxisSize: MainAxisSize.min,
                      //   radius: 8.spMin,
                      // ),
                      if(e['id'] == 6)...[
                        CustomDateTimePicker<DateTime>(
                          controller: context.read<PrecheckBloc>().dateController,
                          format: "MM-dd-yyyy",
                          labelText: "MM-dd-yyyy",
                          suffixIcon: Icon(Icons.calendar_month_rounded, size: 18.spMin, color: context.theme.hintColor),
                          textAlign: TextAlign.center,
                          value: context.read<PrecheckBloc>().selectedDate,
                          onChanged: (value) => context.read<PrecheckBloc>().add(DatePickEvent(value)),
                        ),
                      ],
                      if(e['id'] == 7)...[
                        Flexible(
                          child: Utils.getTextFormField(
                            null,
                            context.read<PrecheckBloc>().odometerController,
                            inputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if(e['id'] == 8)...[
                    Row(
                      spacing: 5,
                      children: [
                        SuccessButton(
                          isOutline: true,
                          foregroundColor: AppC.appColor,
                          icon: RemixIcons.upload_cloud_2_fill,
                          backgroundColor: Colors.transparent,
                          text: ' Upload pictures',
                          onPressed: ()=> context.read<PrecheckBloc>().add(UploadImageEvent()),
                        ),
                        if(file.isNotEmpty)...[
                        InkWell(
                          onTap:()=> ShowAttachmentsDialog.of.show(context,
                            attachments: file,
                            title: '',
                            showDeleteDialog: true,
                            onDeleted: (v)=> context.read<PrecheckBloc>().add(DeleteImageEvent(v)),
                          ),
                          child: IconAndText(
                            label: "(${file.length} files)",
                            icon: RemixIcons.eye_fill,
                            iconColor: AppC.appColor,
                            isExpanded: false,
                          ),
                        ),],
                      ],
                    ),
                  ],
                  if(e['check_value'] == 0 || e['isTap'])...[
                    Utils.getTextFormField(
                        null,
                        e['controller'] as TextEditingController,
                        minLines: 3,
                        maxLines: 3,
                        inputAction: TextInputAction.done),
                    SuccessButton(
                      text: (e?['existing_task'] == 1) ? 'Update Task' : 'Create Task',
                      onPressed: ()=> context.read<PrecheckBloc>().add(CreateOrUpdateEvent(e)),
                    ),
                    if([2,3,4,5].contains(e['id']))...[const CompactText('Note: Check Set Vehicle', color: AppC.redAccent,),],
                  ],
                  5.spMin.height,
                ],
              );
            }),
            SuccessButton(
              text: 'Save',
              onPressed: ()=> context.read<PrecheckBloc>().add(SaveEvent()),
            )
          ],
        ),
      ),
    );
  }
}
