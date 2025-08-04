
import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Todo/private_rental/Bloc/private_renal_check_list_bloc.dart';
import 'package:fairpytasker/UI/Todo/private_rental/Bloc/private_rental_check_list_event.dart';
import 'package:fairpytasker/UI/Todo/private_rental/Bloc/private_rental_check_list_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivateRentalCheckListingPage extends StatelessWidget {
  const PrivateRentalCheckListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivateRenalCheckBloc,PrivateRentalCheckState>(
        builder: (context,state) => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(color: Colors.grey[300],),
          itemCount: context.watch<PrivateRenalCheckBloc>().checkLists.length,
          itemBuilder: (context, index) {
            var model = context.watch<PrivateRenalCheckBloc>().checkLists[index];
            return
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  key: UniqueKey(),
                  side: const BorderSide(width: Num.borderWidthThinField),
                  activeColor: AppC.grey,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: (model['checked'] ?? false),
                  onChanged:(value)=> context.read<PrivateRenalCheckBloc>().add(RentalCheckEvent(model, value)),
                  title: Text("${model['title'] ?? ""}",style: TextStyle(fontSize: 12.spMin),),

                  subtitle: (model['description']
                      .toString()
                      .isNotNullOrEmpty) ? Text(
                      "${model['description'] ?? ""}") : null,
                ),
                if ((model['checked'] == false) ||
                    ((model['fix_task'] != null)))
                  Padding(padding: 16.spMin.horizontalPadding,
                      child: Column(
                        spacing: 10.spMin,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CompactTextField(
                            minLines: 3,
                            maxLines: 7,
                            hintText: "Notes",
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            controller: model['notes'] ??
                                TextEditingController(),
                          ),
                          SuccessButton(
                            text: "${(model['fix_task'] != null)
                                ? "Update"
                                : "Crate"} Task",
                            onPressed: () => context.read<PrivateRenalCheckBloc>().add(PrivateRentalCheckSubmitEvent(model)),
                          )
                        ],
                      ))
              ],
            );
          }
        )
    );
  }
}
