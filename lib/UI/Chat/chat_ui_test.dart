import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fairpytasker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatUITest extends StatefulWidget {
  Map<String, dynamic>? resource;
  Color? appBarColor;

  ChatUITest({Key? key, this.appBarColor, required this.resource})
      : super(key: key);

  @override
  State<ChatUITest> createState() => _ChatUITestState();
}

class _ChatUITestState extends State<ChatUITest> {
  // ... (existing code)
  TodoViewBloc? todoBloc;

  // Color appBarColor = AppC.lowP;
  // String appBarTitle = 'Chats';
  List<Map<String, dynamic>> resourceList = [];
  List<Map<String, dynamic>> chatList = [];
  Map<String, List<Map<String, dynamic>>> groupedChats = {};
  TextEditingController chatEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // ... (existing code)
    todoBloc = TodoViewBloc();

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          titleTextStyle: const TextStyle(color: AppC.white),
          elevation: 0,
          backgroundColor: widget.appBarColor,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_sharp,
                color: AppC.white,
              )),
          title: Utils.getText(
              '${widget.resource!['first_name']} ${widget.resource!['last_name']}',
              size: 18,
              color: AppC.white,
              weight: FontWeight.w700),
          actions: [
            InkWell(
                onTap: () {
                  todoBloc!.add(GetChatMessagesList(
                      sender: getIt<CommonService>().userId,
                      receiver: widget.resource!['id']!));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(Icons.refresh, color: AppC.white),
                )),
          ]),
      body: BlocProvider<TodoViewBloc>(
        create: (context) => todoBloc!
          ..add(GetChatMessagesList(
              sender: getIt<CommonService>().userId,
              receiver: widget.resource!['id']!)),
        child: BlocConsumer<TodoViewBloc, TodoViewState>(
          listener: (context, state) async {
            if (state is ChatSendLoaded) {
              if (state.result != null && state.result!) {
                todoBloc!.add(GetChatMessagesList(
                    sender: getIt<CommonService>().userId,
                    receiver: widget.resource!['id']!));
              }
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          todoBloc!.add(GetChatMessagesList(
                              sender: getIt<CommonService>().userId,
                              receiver: widget.resource!['id']!));
                        },
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: StreamBuilder<TodoViewState>(
                            stream: todoBloc!.stream,
                            // Access the stream from your Bloc
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: Utils.getProgressIndicator(context));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                // Handle your data
/*
                                if (state.chatList != null) {
                                  groupedChats.clear();
                                  chatList.clear();
                                  chatList.addAll((state.chatList ?? []).reversed.toList());
                                  // Group chats by the created_at date
                                  for (Chats chat in chatList) {
                                    var dateKey = Utils.convertDateTimeToTheFormat(
                                        chat.createdAt!,
                                        formatToConvert: 'dd-MM-yyyy')
                                        .toString()
                                        .split(' ')[0];
                                    if (!groupedChats.containsKey(dateKey)) {
                                      groupedChats[dateKey] = [];
                                    }
                                    groupedChats[dateKey]!.add(chat);
                                  }
                                  // Print the grouped chats
                                  // groupedChats.forEach((key, value) {
                                  // print('Date: $key');
                                  // for (var chat in value) {
                                  // print('  ${chat.message}');
                                  // }
                                  // });
                                  Future.delayed(const Duration(milliseconds: 200), () {
                                    scrollController.animateTo(
                                      scrollController.position.maxScrollExtent,
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                }
*/
                                TodoViewState state = snapshot.data!;
                                if (state is ChatsLoaded) {
                                  groupedChats.clear();
                                  chatList.clear();
                                  chatList.addAll(
                                      (state.chatList ?? []).reversed.toList());
                                  // Group chats by the created_at date
                                  for (Map<String, dynamic> chat in chatList) {
                                    var dateKey =
                                        Utils.convertDateTimeToTheFormat(
                                                chat['created_at']!,
                                                formatToConvert: 'dd-MM-yyyy')
                                            .toString()
                                            .split(' ')[0];
                                    if (!groupedChats.containsKey(dateKey)) {
                                      groupedChats[dateKey] = [];
                                    }
                                    groupedChats[dateKey]!.add(chat);
                                  }
                                  // Print the grouped chats
                                  // groupedChats.forEach((key, value) {
                                  // print('Date: $key');
                                  // for (var chat in value) {
                                  // print('  ${chat.message}');
                                  // }
                                  // });
                                  Future.delayed(
                                      const Duration(milliseconds: 200), () {
                                    scrollController.animateTo(
                                      scrollController.position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                }
                                debugPrint('snapshot.data: ${snapshot.data}');
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: groupedChats.length,
                                  itemBuilder: (context, index) {
                                    String date =
                                        groupedChats.keys.toList()[index];
                                    List<Map<String, dynamic>> chats =
                                        groupedChats[date]!;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0, bottom: 12.0),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Utils.getText(date, size: 15),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: chats.length,
                                              itemBuilder:
                                                  (context, chatIndex) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Column(
                                                    children: [
                                                      Visibility(
                                                        visible: widget
                                                                .resource![
                                                                    'id']!
                                                                .toString() ==
                                                            chats[chatIndex]
                                                                ['sender'],
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            children: [
                                                              Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      right: 55,
                                                                      left: 12,
                                                                      bottom:
                                                                          12),
                                                                  padding: const EdgeInsets
                                                                      .fromLTRB(
                                                                      8,
                                                                      8,
                                                                      8,
                                                                      4),
                                                                  decoration: Utils.getBoxDecoration(
                                                                      bgColor: AppC
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.15),
                                                                      borderColor:
                                                                          AppC
                                                                              .trans,
                                                                      radius:
                                                                          2),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Utils.getText(
                                                                          chats[chatIndex]['message'] ??
                                                                              ''),
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                      Utils.getText(
                                                                          Utils.convertDateTimeToTheFormat(chats[chatIndex]['created_at'],
                                                                              formatToConvert:
                                                                                  'hh:mm a'),
                                                                          size:
                                                                              11,
                                                                          align:
                                                                              TextAlign.right),
                                                                    ],
                                                                  )),
                                                              Positioned(
                                                                bottom: -8,
                                                                right: -12,
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_drop_down,
                                                                  color: AppC
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.15),
                                                                  size: 35,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      // const Spacer(),
                                                      // const SizedBox(width: 12,),
                                                      Visibility(
                                                        visible: getIt<CommonService>().userId ==
                                                            chats[chatIndex]
                                                                ['sender'],
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            children: [
                                                              Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      left: 55,
                                                                      right: 12,
                                                                      bottom:
                                                                          12),
                                                                  padding: const EdgeInsets
                                                                      .fromLTRB(
                                                                      8,
                                                                      8,
                                                                      8,
                                                                      4),
                                                                  decoration: Utils.getBoxDecoration(
                                                                      bgColor: AppC
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.15),
                                                                      borderColor:
                                                                          AppC
                                                                              .trans,
                                                                      radius:
                                                                          2),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Utils.getText(
                                                                          chats[chatIndex]['message'] ??
                                                                              ''),
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                      Utils.getText(
                                                                          Utils.convertDateTimeToTheFormat(chats[chatIndex]['created_at'],
                                                                              formatToConvert:
                                                                                  'hh:mm a'),
                                                                          size:
                                                                              11,
                                                                          align:
                                                                              TextAlign.right),
                                                                    ],
                                                                  )),
                                                              Positioned(
                                                                bottom: -8,
                                                                right: 0,
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_drop_down,
                                                                  color: AppC
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.15),
                                                                  size: 35,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: Utils.getBorderedMultilineTextField(
                                  Str.yourMessageText, chatEditingController,
                                  // hintTextColor: AppC.grey,
                                  borderColor: AppC.trans,
                                  fillColor: AppC.grey.withOpacity(0.2),
                                  minLines: 1,
                                  onChangeCallback: (value) {},
                                  autofocus: true)),
                          const SizedBox(
                            width: 0,
                          ),
                          InkWell(
                            child: Container(
                              margin: const EdgeInsets.only(left: 12),
                              padding: const EdgeInsets.all(10),
                              decoration: Utils.getBoxDecoration(
                                  bgColor: widget.appBarColor!),
                              child: const Icon(
                                Icons.send,
                                color: AppC.white,
                                size: 22,
                              ),
                            ),
                            onTap: () async {
                              if (chatEditingController.text
                                  .trim()
                                  .isNotEmpty) {
                                todoBloc!.add(SendChatMessage(
                                    sender: getIt<CommonService>().userId,
                                    receiver: widget.resource!['id']!,
                                    createdAt:
                                        Utils.convertDateTimeToTheFormat(''),
                                    message: chatEditingController.text));
                                chatEditingController.clear();
                              } else {
                                Utils.showMobileToast(
                                    Str.chatMessageEmptyAlert);
                              }
                            },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: state is TodoListLoading,
                  child: Center(child: Utils.getProgressIndicator(context)),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
