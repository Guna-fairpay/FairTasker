part of 'checkout_main_ui.dart';

class CheckoutListingUI extends StatelessWidget {
  const CheckoutListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        String amount = List.from(context.read<CheckoutBloc>().bookingDetails?['cost_summary']?['feeTypes'] ?? []).firstOrNull?['amount'] ?? '';
        dynamic checkOutData = context.read<CheckoutBloc>().bookingDetails?['customer_checkout'];
        return SafeArea(
          minimum: 10.verticalPadding,
          child: Column(
            spacing: 10,
            children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(checkOutData != null)...[
                    IconAndText(
                      label: "${checkOutData?['odometer_reading'] ?? ''}",
                      icon: Icons.speed_rounded,
                      iconColor: AppC.appColor,
                      isExpanded: false,),
                    IconAndText(
                      label: checkOutData?['key_handover'] == 1 ? 'Yes' : 'NO',
                      icon: RemixIcons.key_2_fill,
                      iconColor: AppC.appColor,
                      isExpanded: false,),
                  ],
                  IconAndText(label: amount, icon: Icons.monetization_on_rounded, iconColor: AppC.appColor, isExpanded: false,),
                  if(checkOutData != null)
                  InkWell(
                    onTap: ()=> ImageViewDialog.show(context,
                      attachments: context.read<CheckoutBloc>().checkOtuAttachmentPaths,
                      title: 'Checkout Image'
                    ),
                      child: const Icon(Icons.remove_red_eye_rounded, color: AppC.appColor,),),
                ],
              ),
              const Divider(thickness: 0.4, height: 0.5,),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: context.watch<CheckoutBloc>().checkOutValues.length,
                itemBuilder: (context, index) {
                  var data = context.watch<CheckoutBloc>().checkOutValues[index];
                  bool isChecked = data?['isCheck'];
                  String label = data?['label'];
                  List<dynamic> children = List.from(data?['children'] ?? []);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (List.from(data['children']).isEmpty) ?
                      Column(
                        children: [
                          CustomCheckboxListTile(
                              title: Text(label),
                              value: isChecked,
                              onChanged: (v)=> context.read<CheckoutBloc>().add(ParentCheckEvent(data)),
                            padding: 5.verticalPadding,
                            radius: 8,
                          ),
                          if(data['isCheck'])...[
                            Utils.getTextFormField(
                                null,
                                data['controller'] as TextEditingController,
                              textType: data['type'] == 'text'? TextInputType.text : TextInputType.number,
                              textInputFormatter: data['type'] == 'text'?[] : [FilteringTextInputFormatter.digitsOnly],
                              inputAction: TextInputAction.done,
                            ),
                          ],
                        ],
                      ): Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.height,
                        CompactText(label, styleType: TextStyleType.labelLarge, fontWeight: FontWeight.bold,),
                        ...children.map((e) => Padding(
                          padding: 20.leftPadding,
                          child: Column(
                            children: [
                              CustomCheckboxListTile(
                                  title: Text(e['label']),
                                  value: e['isCheck'],
                                  onChanged: (v)=> context.read<CheckoutBloc>().add(ChildCheckEvent(e)),
                                padding: 5.verticalPadding,
                                radius: 8,
                              ),
                              if(e['isCheck'])...[
                                e['type'] == 'boolean' ?
                                Row(
                                  children: [
                                    CustomCheckboxListTile(
                                      title: const Text('Yes'),
                                      value: e['value'] == "true",
                                      onChanged: (v)=> context.read<CheckoutBloc>().add(YesNoEvent(data: e, isYes: true)),
                                      useExpand: false,
                                    ),
                                    CustomCheckboxListTile(
                                      title: const Text('No'),
                                      value: e['value'] == "false",
                                      onChanged: (v)=> context.read<CheckoutBloc>().add(YesNoEvent(data: e, isYes: false)),
                                      useExpand: false,
                                    ),
                                  ],
                                ): e['type'] == 'select' ?
                                CompactDropDown<String>(
                                  items: List<String>.from(e['options']),
                                  initialSelection: e['value'],
                                  onChanged: (value)=> context.read<CheckoutBloc>().add(DropdownEvent(data: e, selectedData: value)),
                                ): e['type'] == 'file' ?
                                Column(
                                  spacing: 5.spMin,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CompactFilePicker(
                                      controller:context.read<CheckoutBloc>().fileNameController,
                                      onPressed:()=> context.read<CheckoutBloc>().add(FilePickerEvent()),
                                    ),
                                    if(context.read<CheckoutBloc>().attachmentPaths.isNotEmpty)
                                    InkWell(
                                      onTap: ()=> ImageViewDialog.show(context,
                                          attachments: context.read<CheckoutBloc>().attachmentPaths,
                                          onDelete: (value)=> context.read<CheckoutBloc>().add(DeleteImageEvent(value)),
                                      ),
                                      child: Text.rich(
                                        TextSpan(
                                          style: Theme.of(context).textTheme.bodySmall,
                                          children: [
                                            WidgetSpan(
                                              child: Icon(Icons.remove_red_eye, color: AppC.appColor, size: 18.spMin,)
                                            ),
                                            TextSpan(
                                              text: " ${context.read<CheckoutBloc>().attachmentPaths.length} file(s) selected",
                                            ),
                                          ],
                                        )
                                      ),
                                    ),
                                  ],
                                )
                                : Utils.getTextFormField(
                                    null,
                                    e['controller'] as TextEditingController,
                                  textType: e['type'] == 'text'? TextInputType.text : TextInputType.number,
                                  textInputFormatter: e['type'] == 'text'?[] : [FilteringTextInputFormatter.digitsOnly],
                                  inputAction: TextInputAction.done,
                                ),
                              ],
                              10.spMin.height
                            ],
                          ),
                        ),) ,
                      ],),
                    ],
                  );
                },
              ),
               Row(
                spacing: 10,
                children: [
                  if(context.read<CheckoutBloc>().model?['bookingDetails']?['status_name'] != 'completed' )
                  SuccessButton(
                    text: 'Approve & Close',
                    backgroundColor: AppC.appColor,
                    onPressed: ()=> context.read<CheckoutBloc>().add(ApproveAndCloseEvent()),
                  ),
                  SuccessButton(text: 'Save', onPressed:()=> context.read<CheckoutBloc>().add(SaveEvent()),),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
