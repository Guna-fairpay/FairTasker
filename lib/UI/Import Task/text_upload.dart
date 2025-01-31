import 'package:fairpytasker/Bloc/text_upload_bloc.dart';
import 'package:fairpytasker/Event/text_upload_event.dart';
import 'package:fairpytasker/Response/text_upload_response.dart';
import 'package:fairpytasker/State/text_upload_state.dart';
import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Component/bottom_nav_for_task.dart';
import 'turo_reservation.dart';

class UploadText extends StatefulWidget {
  const UploadText({super.key});

  @override
  State<UploadText> createState() => _UploadTextState();
}

class _UploadTextState extends State<UploadText> {
  late TextUploadBloc textUploadBloc;
  final TextEditingController uploadTaskController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    textUploadBloc = TextUploadBloc();
    super.initState();
  }

  @override
  void dispose() {
    textUploadBloc.close(); // Close the bloc to prevent memory leaks
    uploadTaskController.dispose(); // Dispose of the controller as well
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppC.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Column(
            children: [
              const HeaderView(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    tabs: const [
                      Tab(text: 'Task Upload', height: 30),
                      Tab(text: 'Turo Reservation', height: 30),
                    ],
                    dividerColor: AppC.trans,
                    labelStyle: const TextStyle(fontSize: 16),
                    labelColor: AppC.white,
                    unselectedLabelColor: AppC.appColor,
                    indicator: BoxDecoration(
                      color: AppC.appColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create: (context) => textUploadBloc,
          child: BlocConsumer<TextUploadBloc, TextUploadState>(
            listener: (context, state) {
              if (state is TextUploadLoading) {
                loading = true;
              } else if (state is TextUploadLoaded) {
                loading = false;
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
            },
            builder: (context, state) {
              return Stack(
                children: [
                  TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child:
                                          Utils.getBorderedMultilineTextField(
                                        'Paste your text here...',
                                        uploadTaskController,
                                        minLines: 35,
                                        fillColor: AppC.white,
                                        autofocus: false,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          child: Utils.getAddFilledButton(
                                              'Upload', () {
                                            final task = UploadTextData(
                                              text: uploadTaskController.text,
                                            );
                                            if (uploadTaskController
                                                .text.isEmpty) {
                                              Utils.showMobileToast(
                                                  'Please Upload Data');
                                            } else {
                                              context
                                                  .read<TextUploadBloc>()
                                                  .add(CreateTextUpload(
                                                    text: uploadTaskController
                                                        .text,
                                                    id: task
                                                        .id, // Ensure `id` is correct
                                                  ));
                                            }
                                          }),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TuroReservation(),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: loading,
                      child:
                          Center(child: Utils.getProgressIndicator(context))),
                ],
              );
            },
          ),
        ),
        drawer: const DrawerView(),
      ),
    );
  }
}
