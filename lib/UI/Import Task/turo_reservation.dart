
import 'package:fairpytasker/Bloc/text_upload_bloc.dart';
import 'package:fairpytasker/Event/text_upload_event.dart';
import 'package:fairpytasker/State/text_upload_state.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Component/bottom_nav_for_task.dart';

class TuroReservation extends StatefulWidget {
  const TuroReservation({super.key});

  @override
  State<TuroReservation> createState() => _TuroReservationState();
}

class _TuroReservationState extends State<TuroReservation> {

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
    textUploadBloc.add(TuroReservationEvent(text: uploadTaskController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: BlocProvider(
        create: (context) => textUploadBloc,
        child: BlocConsumer<TextUploadBloc, TextUploadState>(
          listener: (context, state) {
            if (state is TextUploadLoading) {
              EasyLoading.show();
            } else {
              if(EasyLoading.isShow)EasyLoading.dismiss();
              if (state is TextUploadLoaded) {
                uploadTaskController.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavigationForTaskView(
                      selectedIndex: 1,
                      message: '',
                    ),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            return SafeArea(
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
                          text: 'Submit',
                           ()=>_uploadTask()
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
