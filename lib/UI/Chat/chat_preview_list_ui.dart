import 'package:fairpytasker/UI/Chat/chat_ui.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPreviewListUI extends StatefulWidget {
  const ChatPreviewListUI({Key? key}) : super(key: key);

  @override
  State<ChatPreviewListUI> createState() => _ChatPreviewListUIState();
}

class _ChatPreviewListUIState extends State<ChatPreviewListUI> {
  TodoViewBloc? todoBloc;
  Color appBarColor = AppC.lowP;
  String appBarTitle = 'Chats';
  List<Map<String, dynamic>> resourceList = [];

  @override
  void initState() {
    todoBloc = TodoViewBloc();
    todoBloc!.add(const GetAssignedToList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            titleTextStyle: const TextStyle(color: AppC.white),
            elevation: 0,
            backgroundColor: appBarColor,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: AppC.white,
                )),
            title: Utils.getText(appBarTitle,
                size: 18, color: AppC.white, weight: FontWeight.w700)),
        body: BlocProvider(
            create: (context) => todoBloc!..add(const TodoViewInitialEvent()),
            child: BlocConsumer<TodoViewBloc, TodoViewState>(
                listener: (context, state) async {
              print(state);
              if (state is AssignedToLoaded) {
                setState(() {
                  print(state.resource);
                  resourceList.clear();
                  resourceList.addAll(state.resource ?? []);
                });
              }
            }, builder: (context, state) {
              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      todoBloc!.add(const GetExpenseSummaryData());
                    },
                    child: SingleChildScrollView(
                      child: Visibility(
                        // visible: todoList != null && todoList!.isNotEmpty,
                        // replacement: Utils.getEmptyTextWidget(topPadding: 30),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: resourceList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
/*
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => ChatUITest(
                                        appBarColor: AppC.lowP,
                                        resource: resourceList[index],
                                      ),
                                    ),
                                  );
*/
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => ChatUI(
                                      appBarColor: AppC.lowP,
                                      resource: resourceList[index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: const BorderSide(
                                        color: AppC.white, width: 1),
                                    left: const BorderSide(
                                        color: AppC.white, width: 1),
                                    right: const BorderSide(
                                        color: AppC.white, width: 1),
                                    bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.1),
                                        width: 1),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0,
                                          5), // Adjust the offset for the side you want the shadow
                                    ),
                                  ],
                                  color: AppC.white,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                        height: 50,
                                        width: 50,
                                        decoration: Utils.getBoxDecoration(
                                            bgColor: AppC.lowP, radius: 25),
                                        margin:
                                            const EdgeInsets.only(right: 20),
                                        padding: const EdgeInsets.all(0),
                                        alignment: Alignment.center,
                                        child: Utils.getText(
                                            resourceList[index]
                                                    ['first_name']![0]
                                                .toUpperCase(),
                                            size: 22,
                                            color: AppC.white,
                                            weight: FontWeight.bold)),
                                    Utils.getText(
                                        resourceList[index]['first_name'] ?? '')
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: state is TodoListLoading,
                      child: Center(child: Utils.getProgressIndicator(context)))
                ],
              );
            })));
  }
}
