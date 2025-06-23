
import 'package:fairpytasker/Component/compact_file_picker.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bill/Bloc/bill_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bill/Bloc/bill_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bill/Bloc/bill_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../utilities/Utils.dart';

class BillTextFormPage extends StatelessWidget {
  const BillTextFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillBloc, BillState>(
         builder: (context,state) {
           return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CompactFilePicker(
                  controller:context.read<BillBloc>().filePickerController,
                  onPressed:()=> context.read<BillBloc>().add(FilePickerEvent()),
                ),
                ImageUploadSection(
                  title: '',
                  borderColor: Colors.blue,
                  onRemove: (file)=> context.read<BillBloc>().add(RemoveImageEvent(data:file)),
                  images: context.watch<BillBloc>().files,
                  logName: "BillImageEvent",
                  isRequired: false,
                ),
                Row(
                  spacing: 10,
                  children: [
                    if(!context.read<BillBloc>().isEdit)
                    SuccessButton(
                      text: 'Save',
                      onPressed: ()=>context.read<BillBloc>().add(AddBillEvent()),
                    ),
                   if(context.read<BillBloc>().isEdit)...[
                     SuccessButton(
                      text: 'Update',
                      onPressed: ()=>context.read<BillBloc>().add(EditBillEvent()),
                    ),
                    SuccessButton(
                      text: 'cancel',
                      backgroundColor: AppC.redAccent,
                      onPressed: ()=>context.read<BillBloc>().add(ClearAllEvent()),
                    ),
                   ],
                  ],
                ),
                Utils.getTextFormField('Title', context.read<BillBloc>().titleController,),
                Utils.getTextFormField('Amount', context.read<BillBloc>().amountController,),
                Utils.getTextFormField('Description', context.read<BillBloc>().descriptionController,minLines: 2,maxLines: 2,inputAction: TextInputAction.done,),
                const Divider(thickness: 1,height: 0.1,),
              ]
                 );
         }
    );
  }
}
