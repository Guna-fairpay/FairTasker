
import 'package:fairpytasker/UI/Voice%20To%20Text/Bloc/voice_to_text_bloc.dart';
import 'package:fairpytasker/UI/Voice%20To%20Text/Bloc/voice_to_text_event.dart';
import 'package:fairpytasker/UI/Voice%20To%20Text/Bloc/voice_to_text_state.dart';
import 'package:fairpytasker/UI/Voice%20To%20Text/UI/voice_to_text_body.dart';
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


/*
import 'package:audioplayers/audioplayers.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Bloc/todo_view_bloc.dart';
import '../../../Component/audio_player_widget.dart';
import '../../../Utilities/Str.dart';
import '../../../Utilities/utils.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class VoiceToTextUi extends StatefulWidget {
  const VoiceToTextUi({super.key});

  @override
  State<VoiceToTextUi> createState() => _VoiceToTextUiState();
}

class _VoiceToTextUiState extends State<VoiceToTextUi> {

  late TodoViewBloc todoViewBloc = TodoViewBloc();
  TextEditingController dateController = TextEditingController();
  DateRange? selectedDateRange;
  List<Map<String, dynamic>> voiceData = [];
  List<Map<String, dynamic>> filteredData = [];
  Duration duration=const Duration();
  Duration position=const Duration();
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  bool isVolume = true;

  @override
  void initState() {

    DateTime now = DateTime.now();
    selectedDateRange = DateRange(
      now.subtract(const Duration(days: 7)),
      now,
    );
    String from = selectedDateRange!.start.toString();
    String to = selectedDateRange!.end.toString();
    todoViewBloc.add(GetVoiceData(from, to));
    filteredData = voiceData;

    player.onDurationChanged.listen((Duration newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    player.onPositionChanged.listen((Duration newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    player.onPlayerComplete.listen((_) {
      setState(() {
        position = Duration.zero;
        isPlaying = false;
      });
    });

    super.initState();
  }

  void filterDataByDateRange() {
    List<Map<String, dynamic>> result = voiceData;
    if (selectedDateRange != null) {
      result = result.where((item) {
        final dateParts = item['date']?.split(' to ');
        if (dateParts == null || dateParts.length != 2) return false;
        final startDate =
        DateTime.tryParse(dateParts[0].split('-').reversed.join('-'));
        final endDate =
        DateTime.tryParse(dateParts[1].split('-').reversed.join('-'));
        return startDate != null && endDate != null;
      }).toList();
    }
    setState(() {
      filteredData = result;
    });
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }




  String formatDate(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy-MM-dd').format(dateTime); // Formats the date as 'yyyy-MM-dd'
    } catch (e) {
      return '';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        foregroundColor: AppC.white,
        backgroundColor: AppC.appColor,
        title: const Text('Voice To Text'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close))
        ],
      ),
      body: BlocProvider(
        create: (context) =>
        todoViewBloc..add(GetVoiceData(selectedDateRange!.start.toString(),
          selectedDateRange!.end.toString(),)),
        child: BlocConsumer<TodoViewBloc, TodoViewState>(
            listener: (context, state) {
              if (state is TodoListLoading) {
                EasyLoading.show();
              } else {
                if(EasyLoading.isShow)EasyLoading.dismiss();
              if (state is VoiceListLoaded) {
                voiceData.clear();
                filteredData.clear();
                voiceData.addAll(state.data ?? []);
                filteredData=voiceData;
              }
            }
          },
          builder: (context,state) {
            return SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: DateRangeField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppC.fieldBase, width: Num.borderWidthField),
                                borderRadius: BorderRadius.circular(Num.subradiusButton),
                              ),
                              label: Utils.getText('Date Range',
                                  color: AppC.grey),
                            ),
                            selectedDateRange: selectedDateRange,
                            onDateRangeSelected: (DateRange? value) {
                              setState(() {
                                selectedDateRange = value;
                                String from = selectedDateRange!
                                    .start
                                    .toString();
                                String to =
                                selectedDateRange!.end.toString();
                                todoViewBloc.add(GetVoiceData(
                                    from, to));
                                filterDataByDateRange();
                              });
                            },
                            pickerBuilder: datePickerBuilder,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: (state is VoiceListLoaded) && filteredData.isEmpty
                        ? Center(child: Utils.getText('No data available', size: 16))
                        : ListView.separated(
                      separatorBuilder: (context, index) =>const Divider(height: 0.5),
                      itemCount: filteredData.length + 1,
                      itemBuilder: (context, index) {

                        final voiceData = ((filteredData.length) != index) ? filteredData[index] : null;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Utils.getText(
                                      voiceData == null ? "TESTING MP3 AUDIO" : voiceData['transcribed_text'] ?? '-NO TITLE-',
                                      weight: FontWeight.bold,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          width: 0.5,
                                          color: AppC.blue
                                        )
                                      ),
                                      child: (voiceData == null) ? AudioPlayerWidget(source: UrlSource('https://onlinetestcase.com/wp-content/uploads/2023/06/2-MB-MP3.mp3')) :  AudioPlayerWidget(source: UrlSource('${Str.TODO_ATTACHMENTS_URL}${voiceData?['attachment_path'] ?? ''}')),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Utils.getText(
                                          formatDate(voiceData?['created_at'] ?? ''),
                                          weight: FontWeight.bold,
                                        ),
                                        Utils.getText(
                                          "${voiceData?['user']['first_name'][0] ?? ''}${voiceData?['user']['last_name'][0] ?? ''}",
                                          weight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget datePickerBuilder(BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
      [bool doubleMonth = false]) {
    return DateRangePickerWidget(
      doubleMonth: doubleMonth,
      initialDateRange: selectedDateRange,
      disabledDates: const [],
      initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
      onDateRangeChanged: onDateRangeChanged,
      height: 338,
      displayMonthsSeparator: true,
    );
  }

}
*/
