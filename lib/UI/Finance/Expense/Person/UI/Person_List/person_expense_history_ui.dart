
import 'package:fairpytasker/UI/Finance/Expense/Person/Bloc/person_expense_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/Person/Bloc/person_expense_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/Person/Bloc/persion_expense_state.dart';
import 'package:fairpytasker/UI/Finance/Expense/Person/UI/Person_Edit/person_expense_edit_ui.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';


class PersonExpenseHistoryUI extends StatelessWidget {
  final String userId;
  final String userName;
  const PersonExpenseHistoryUI({super.key,required this.userId,required this.userName,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonExpenseBloc>(
      create: (context) => PersonExpenseBloc()
        ..add(GetPersonExpenseHistory(userId: userId)),
      child:
      BlocListener<PersonExpenseBloc,PersonExpenseState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
        },
        child:
        BlocBuilder<PersonExpenseBloc, PersonExpenseState>(
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    foregroundColor: Colors.white,
                    backgroundColor: AppC.appColor,
                    title: Text(userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18),
                      maxLines: 2,
                    ),
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  body: SafeArea(
                    minimum: 20.padding,
                    child: Column(
                      children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Total Expense Till Date: ', // Normal text
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                  ), // Regular style
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '\$ ${state.totalAmount}', // Bold amount
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 1,),
                        Expanded(
                          child: ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                height: 0.5,
                                color: Colors.grey.shade400,
                              ),
                              itemCount: state.personExpenseHistory.length,
                              itemBuilder: (context, index) {
                                var data =state.personExpenseHistory[index];
                                List<dynamic> images = data?['attachments'];
                                List<dynamic> todoImages = images
                                    .map((e) => e['path'].toString().toStorageURL)
                                    .toList();
                                return InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PersonExpenseEditUI(
                                          id: data['id'].toString(),
                                        ),
                                      ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            spacing: 5,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.calendar_month,
                                                      color: AppC.grey, size: 20),
                                                  10.width,
                                                  Utils.getText(
                                                      DateFormat('MM-dd-yy').format(DateTime.parse(data['expense_date']??''))),
                                                  const Spacer(),

                                                  if (images.isNotEmpty)
                                                    InkWell(
                                                      onTap: () =>
                                                          ShowAttachmentsDialog.of.show(
                                                              context,
                                                              attachments: todoImages,
                                                              title: 'Expense Image'),
                                                      child: const Icon(
                                                        Icons.remove_red_eye_outlined,
                                                        color: AppC.blue,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  20.width,
                                                  Utils.getText(
                                                      "\$ ${data['expense_amount'] ?? ''}",
                                                      color: AppC.green),
                                                ],
                                              ),
                                              Utils.getText(
                                                (data['expense_description']??'').toString().toSentenceCase(),)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ));
            }),
      ),
    );
  }
}
