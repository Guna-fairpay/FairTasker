
import 'package:fairpytasker/Bloc/text_upload_bloc.dart';
import 'package:fairpytasker/State/text_upload_state.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Component/bottom_nav_for_task.dart';
import '../../Event/text_upload_event.dart';
import 'turo_reservation.dart';

class UploadText extends StatefulWidget {
  const UploadText({super.key});

  @override
  State<UploadText> createState() => _UploadTextState();
}

class _UploadTextState extends State<UploadText> {

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextUploadBloc textUploadBloc = TextUploadBloc();
  final TextEditingController uploadTaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textUploadBloc.close();
    uploadTaskController.dispose();
    super.dispose();
  }

  void _uploadTask() {
    _key.currentState!.validate();
    if (uploadTaskController.text.isEmpty) {
      return;
    }
    textUploadBloc.add(TextUpload(text: uploadTaskController.text));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppC.white,
        appBar: AppBar(
          leadingWidth: 20,
          foregroundColor: AppC.white,
          backgroundColor: AppC.appColor,
          title: TabBar(
            tabs: const [
              Tab(text: 'Task Upload', height: 30),
              Tab(text: 'Turo Reservation', height: 30),
            ],
            dividerColor: AppC.trans,
            labelStyle: const TextStyle(fontSize: 16),
            labelColor: AppC.appColor,
            unselectedLabelColor: AppC.white,
            indicator: BoxDecoration(
              color: AppC.white,
              borderRadius: BorderRadius.circular(4),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
        body: BlocProvider(
          create: (context) => textUploadBloc,
          child: BlocConsumer<TextUploadBloc, TextUploadState>(
            listener: (context, state) {
              if (state is TextUploadLoading) {
                EasyLoading.show();
              } else {
                if (EasyLoading.isShow) EasyLoading.dismiss();
                if (state is TextUploadLoaded) {
                  uploadTaskController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomNavigationForTaskView(
                        selectedIndex: 0,
                        message: '',
                      ),
                    ),
                  );
                }
              }
            },
            builder: (context, state) {
              return TabBarView(
                children: [
                  SafeArea(
                    minimum: 10.padding,
                    child: Form(
                      key: _key,
                      child: ListView(
                        children: [
                          Utils.getBorderedMultilineTextField(
                            'Paste your text here...',
                            uploadTaskController,
                            minLines: 22,
                            maxLines: 22,
                            inputAction: TextInputAction.done,
                            autoValidate: AutovalidateMode.onUserInteraction,
                            validator: (val)=>val!.isEmpty?'Please enter text to upload':null,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Utils.getElevatedButton(
                                  text: 'Submit', () => _uploadTask()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SafeArea(
                    minimum: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: TuroReservation(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
