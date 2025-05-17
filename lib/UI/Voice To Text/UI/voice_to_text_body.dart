
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/Voice%20To%20Text/Bloc/voice_to_text_bloc.dart';
import 'package:fairpytasker/UI/Voice%20To%20Text/Bloc/voice_to_text_state.dart';
import 'package:fairpytasker/UI/Voice%20To%20Text/Bloc/voice_to_text_event.dart';
import 'package:fairpytasker/UI/dialog/play_audio_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoiceToTextBody extends StatelessWidget {
   const VoiceToTextBody({super.key});

   @override
   Widget build(BuildContext context) {
     return BlocBuilder<VoiceToTextBloc, VoiceToTextState>(
       builder: (context, state) {
         return SafeArea(
           minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
           child: Column(
             children: [
               DateRangePicker(
                 selectedDateRange: context
                     .watch<VoiceToTextBloc>()
                     .selectedDateRange,
                 onDateRangeSelected: (range) {
                   context.read<VoiceToTextBloc>().add(
                       ChangeDateRangeEvent(range));
                   String startDate = range.start.toFormat() ?? "";
                   String endDate = range.end.toFormat() ?? "";
                   context.read<VoiceToTextBloc>().add(
                       VoiceToTextInitialEvent(startDate: startDate,endDate: endDate));
                 },
               ),
               10.height,
               Expanded(
                 child: ListView.separated(
                   separatorBuilder: (context, index) => const Divider(),
                   itemCount: context.watch<VoiceToTextBloc>().voiceData.length,
                   itemBuilder: (context,index) {
                     final voiceData = context.watch<VoiceToTextBloc>().voiceData[index];
                       return Row(
                         children: [
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Utils.getText(voiceData['transcribed_text'] ?? '',),

                               ],),
                           ),
                             10.width,
                             IconButton(onPressed: () =>  PlayAudioDialog.show(context, audioUrl:voiceData['attachment_path'] ?? '' ), icon: const Icon(Icons.play_arrow),),
                             10.width,
                             Utils.getText(
                               "${voiceData['user']['first_name'][0]}${voiceData['user']['last_name'][0]}" ?? '',),
                             10.width,
                             Utils.getText(
                        "${DateTime.parse(voiceData['created_at']).toFormat(format: 'MM-dd-yy')}",),

                         ],
                       );
                   },
                 ),
               ),
             ],
           ),
         );
       }
     );
   }
 }
