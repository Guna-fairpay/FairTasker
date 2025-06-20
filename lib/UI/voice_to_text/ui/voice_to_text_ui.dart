
import 'package:fairpytasker/UI/voice_to_text/bloc/voice_to_text_bloc.dart';
import 'package:fairpytasker/UI/voice_to_text/ui/voice_to_text_body.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VoiceToTextUI extends StatelessWidget {
  const VoiceToTextUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VoiceToTextBloc>(
      create: (context) => VoiceToTextBloc()..add(VoiceToTextInitialEvent()),
      child: BlocListener<VoiceToTextBloc, VoiceToTextState>(
        listener: (context, state) {
          if(state is VoiceToTextLoadingState){
            if (!EasyLoading.isShow) EasyLoading.show();
          }
          else{
            if(EasyLoading.isShow)EasyLoading.dismiss();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Voice To Text'),
            foregroundColor: AppC.white,
            backgroundColor: AppC.appColor,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close))
            ],
          ),
          body: const VoiceToTextBody(),
        ),
      ),
    );
  }
}