
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class TaskComponentsSettingUI extends StatefulWidget {
  const TaskComponentsSettingUI({super.key});

  @override
  State<TaskComponentsSettingUI> createState() =>
      _TaskComponentsSettingUIState();
}

class _TaskComponentsSettingUIState extends State<TaskComponentsSettingUI>
    with SingleTickerProviderStateMixin {
  late TodoViewBloc taskBloc;
  late TabController _tabController;
  TextEditingController taskNameCtrl=TextEditingController();
  TextEditingController amountCtrl=TextEditingController();
  List<Map<String, String>> taskBase = [];
  List<Map<String, String>> filterTaskBase = [];
  List<Map<String, String>> hourBased = [];
  List<Map<String, String>> filterHourBased = [];
  List<Map<String, dynamic>> taskbased=[];
  List<Map<String, dynamic>> hourlybased=[];
  List<Map<String, dynamic>> resources=[];
  List<Map<String, dynamic>> formattedResources=[];
  List<Map<String, dynamic>> taskDatas=[];
  List<Map<String, String>> baseOption = [
    {"base": "Task based"},
    {"base": "Hourly based"},
  ];
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final Map<String, int> tabMapping = {
    "Task based": 0,
    "Hourly based": 1,
  };
  dynamic selectedBase;
  dynamic selectedTasks;
  dynamic selectedPerson;
  dynamic selectedBases;
  dynamic selectedBase1 = {"base": "Task based"};
  dynamic selectedUserId;
  int? editingIndex;
  int? selectPersonID;
  bool loading=false;
  bool isEditing = false;




  @override
  void initState() {
    super.initState();
    taskBloc=TodoViewBloc();
    taskBloc.add(const GetAssignedToList());
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0;
    taskBloc.add(const GetTaskHistoryConfiguration());
  }

  @override
  void dispose() {
    _tabController.dispose();
    taskBloc.close();
    super.dispose();
  }

//Task
  void startEditingHourly(int? id,int? userid,String? amount, String? type) {
    var editResource = formattedResources.firstWhere(
          (element) => element['id'] == id,
      orElse: () => {},
    );
    setState(() {
      editingIndex = id;
      _amountController.text = amount!;
      // selectedTasks= type;
    });
  }
  void startEditingTask(int? id,String? amount, String? taskName, String? type) {
    if(type=='task')
    {
      var editData = taskDatas.firstWhere(
            (element) => element['id'] == id,
        orElse: () => {},
      );
      setState(() {
        editingIndex = editData['id'];
        _taskNameController.text = editData['task_name'];
        _amountController.text = editData['amount'];
        // selectedTasks= type;
      });
    }
  }
  void stopEditing() {
    setState(() {
      editingIndex = null;
      _taskNameController.clear();
      _amountController.clear();
      selectedBase1 = {};
      selectedUserId = null;
      selectedPerson = null;
    });
  }
  void _addTask() {
    if(_amountController.text.isNotEmpty && selectedBases!=null)
    {
      if(selectedBases['base']=='Task based' && _taskNameController.text.isNotEmpty)
      {

        setState(() {
          taskBloc.add(AddConfigurationEvent(
            id: null,
            userId: null,
            name: _taskNameController.text,
            amount: _amountController.text,
            task: 'task',
          ));
          _taskNameController.clear();
          _amountController.clear();
          taskBloc.add(const GetTaskHistoryConfiguration());
        });
      }
      else
      {
        if (_amountController.text.isNotEmpty && selectedBases['base'] != null && selectedUserId != null) {
          setState(() {
            taskBloc.add(AddConfigurationEvent(
              id: null,
              userId: selectedUserId,
              name: '',
              amount: _amountController.text,
              task: 'hourly',
            ));
            _taskNameController.clear();
            _amountController.clear();
            taskBloc.add(const GetTaskHistoryConfiguration());
          });
        }
        else
        {
          print("Error in saving");
        }
      }
    }
    else{
      Utils.showMobileToast("Select all values");
    }
  }

  Future<bool?> showCustomDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppC.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              const Icon(Icons.help_outline_sharp,size: 50,color: Colors.blue,),
              const SizedBox(height: 16),
              // Title
              Utils.getText(
                "Are you sure?",
                size: 18,
                weight: FontWeight.bold,
                align: TextAlign.center,
                color: AppC.black,
              ),
              const SizedBox(height: 8),
              // Subtitle
              Utils.getText(
                "Do you want to delete?",
                align: TextAlign.center,
                color: AppC.black,
              ),
              const SizedBox(height: 8),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Utils.getAddFilledButton("Yes, delete it!", (){
                    Navigator.pop(context, true);
                  },bgColor:  AppC.blue),
                  Utils.getAddFilledButton("Cancel", (){
                    Navigator.pop(context, false);
                  },bgColor:  AppC.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppC.white,
        appBar: PreferredSize(preferredSize: const Size.fromHeight(56), child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppC.appColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Utils.getText("Task Components - Settings",color: AppC.white,weight: FontWeight.bold,size: 18),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close_sharp,color: AppC.white,),
              )
            ],
          ),
        )),
        body: BlocProvider(
          create: (context) => taskBloc..add(const GetTaskHistoryConfiguration()),
          child: BlocConsumer<TodoViewBloc,TodoViewState>(listener: (context, state)
          {
            if (state is TodoListLoading)
            {
              setState(() {
                loading=true;
              });
            }
            else if(state is TaskHistoryConfigurationLoaded)
            {
              setState(() {
                loading=false;
                taskDatas=state.taskHistoryConfigurationList!;
                taskbased=taskDatas
                    .where((task) => task['type'] == 'task')
                    .toList();
                hourlybased=taskDatas.where((task)=> task['type']=='hourly').toList();
              });
            }
            else if(state is AssignedToLoaded)
            {
              setState(() {
                loading = false;
                resources=state.resource!;
                formattedResources = resources.map((resource) {
                  return {
                    'id': resource['id'],
                    'full_name': "${resource['first_name']} ${resource['last_name']}",
                  };
                }).toList();
              });
            }
            else {
              setState(() {
                taskBloc.add(const GetTaskHistoryConfiguration());
                loading = true;
              });
            }
          },
              builder: (context, state)
              {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Utils.dropdownBox(
                            selectedBase1['base'] ?? 'Task based',
                            baseOption,
                                (value) {
                              setState(() {
                                selectedBase1=value;
                                selectedBases=value;
                                _tabController.animateTo(tabMapping[selectedBase1['base']]!);
                              });
                            },
                            labelKey: 'base',initialSelection: selectedBase1,
                          ),
                          const SizedBox(height: 16),
                          selectedBase1['base']=='Task based'?Utils.getTextFormField('Task Name',_taskNameController):
                          Utils.dropdownBox(
                            selectedPerson == null ? 'Select person' : selectedPerson['full_name'],
                            formattedResources ,(value) {
                            setState(() {
                              selectedBase1=value;
                              selectedUserId = value['id'];
                              if (tabMapping[selectedBase1['base']] != null) {
                                _tabController.animateTo(tabMapping[selectedBase1?['base']]!);
                              }
                            });
                          }, labelKey: 'full_name',
                            initialSelection: selectedPerson,
                          ),
                          const SizedBox(height: 16),
                          Utils.getTextFormField('Amount (\$)',_amountController),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              if (isEditing) ...[
                                //update code
                                Utils.getAddFilledButton("Update", (){
                                  setState(() {
                                    if (editingIndex!=null && _amountController.text.isNotEmpty)
                                    {
                                      if(_taskNameController.text.isNotEmpty && _amountController.text.isNotEmpty)
                                      {
                                        setState(() {
                                          isEditing = false;
                                          taskBloc.add(AddConfigurationEvent(
                                            id: editingIndex,
                                            userId: null,
                                            name: _taskNameController.text,
                                            amount: _amountController.text,
                                            task: 'task',
                                          ));
                                          taskBloc.add(const GetTaskHistoryConfiguration());
                                        });
                                        _taskNameController.clear();
                                        _amountController.clear();
                                      }
                                      else{
                                        setState(() {
                                          isEditing = false;
                                          taskBloc.add(AddConfigurationEvent(
                                            id: editingIndex,
                                            userId: selectedPerson['id'],
                                            name: null,
                                            amount: _amountController.text,
                                            task: 'hourly',
                                          ));
                                          taskBloc.add(const GetTaskHistoryConfiguration());
                                        });
                                        _amountController.clear();
                                      }
                                    }
                                    else
                                    {

                                    }
                                  });
                                },bgColor: AppC.green),
                                const SizedBox(width: 8),
                                //cancel code
                                Utils.getAddFilledButton("Cancel", (){
                                  setState(() {
                                    isEditing = false; // Cancel editing mode
                                    _taskNameController.clear();
                                    _amountController.clear();
                                  });
                                },bgColor: AppC.red)
                              ] else ...[
                                //save code
                                Utils.getAddFilledButton("Save", (){
                                  _addTask();
                                },bgColor: AppC.green)
                              ],
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(bottom: BorderSide(color: Colors.black,width: 0.5))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10*9, 0),
                              child: TabBar(
                                controller: _tabController,
                                tabs: const [
                                  Tab(text: 'Task Based', height: 30,),
                                  Tab(text: 'Hourly Based', height: 30),
                                ],
                                dividerColor: AppC.trans,
                                labelStyle: const TextStyle(fontSize: 12),
                                labelColor: AppC.appColor,
                                unselectedLabelColor: AppC.black,
                                indicator: BoxDecoration(
                                  //color: AppC.appColor,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(width: 1, color: AppC.appColor)
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                overlayColor: WidgetStateProperty.all(Colors.transparent),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: TabBarView(controller: _tabController,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            topRight: Radius.circular(4),
                                          )
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Row(
                                            children: [
                                              Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                                              SizedBox(width: 30*2,),
                                              Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: taskbased.length,
                                        itemBuilder: (context, index) {
                                          final task = taskbased[index];
                                          return
                                            Column(
                                              children: [
                                                Center(
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border(bottom: BorderSide(color: Colors.black,width: 0.2))
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(8, 8, 10, 8),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Utils.getText("${task['task_name']}"),
                                                          Row(
                                                            children: [
                                                              Utils.getText("\$${task['amount']}"),
                                                              const SizedBox(width: 30*3,),
                                                              GestureDetector(
                                                                  onTap: () => {
                                                                    setState(() {
                                                                      isEditing = true;
                                                                      selectedBase1={"base": "Task based"};
                                                                      startEditingTask(task['id'],task['amount'],task['task_name'],task['type']);
                                                                    })
                                                                  },
                                                                  child: const Icon(
                                                                    Icons.edit_outlined,
                                                                    size: 16,
                                                                    color: Colors.blue,
                                                                  )
                                                              ),
                                                              const SizedBox(width: 6,),
                                                              GestureDetector(
                                                                  onTap: () async {
                                                                    final confirm = await showCustomDeleteDialog(context);
                                                                    if(confirm == true)
                                                                    {
                                                                      setState(() {
                                                                        context.read<TodoViewBloc>().add(DeleteTaskConfigurationEvent(id: task['id']));
                                                                        taskBloc.add(GetTaskHistoryConfiguration());
                                                                      });
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        const SnackBar(content: Text('Task deleted successfully')),
                                                                      );
                                                                    }else{
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        const SnackBar(content: Text('Deletion cancelled.')),
                                                                      );
                                                                    }
                                                                  },
                                                                  child: const Icon(
                                                                    Icons.delete_outline,
                                                                    size: 16,
                                                                    color: Colors.red,
                                                                  )
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                        },
                                      ),
                                    ),
                                  ],
                                ),


                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            topRight: Radius.circular(4),
                                          )
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Row(
                                            children: [
                                              Text('Amount/hr', style: TextStyle(fontWeight: FontWeight.bold)),
                                              const SizedBox(width: 30*2,),
                                              Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: hourlybased.length,
                                        itemBuilder: (context, index) {
                                          final task = hourlybased[index];
                                          return
                                            Column(
                                              children: [
                                                Center(
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border(bottom: BorderSide(color: Colors.black,width: 0.2))
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(8, 8, 10, 8),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Utils.getText("${formattedResources.firstWhere((user) => user['id'] == task['user_id'], orElse: () => {'full_name': 'Unknown'})['full_name']}"),
                                                          Row(
                                                            children: [
                                                              Utils.getText("\$${task['amount']}"),
                                                              const SizedBox(width: 30*3,),
                                                              GestureDetector(
                                                                  onTap: () => {
                                                                    setState(() {
                                                                      selectedPerson=formattedResources.firstWhere((user) => user['id'] == task['user_id']);
                                                                      isEditing = true;
                                                                      selectedBase1={"base": "Hourly based"};
                                                                      startEditingHourly(task['id'],task['user_id'],task['amount'],task['type']);
                                                                    })
                                                                  },
                                                                  child: const Icon(
                                                                    Icons.edit_outlined,
                                                                    size: 16,
                                                                    color: Colors.blue,
                                                                  )
                                                              ),
                                                              SizedBox(width: 6,),
                                                              GestureDetector(
                                                                  onTap: () async {
                                                                    final confirm = await showCustomDeleteDialog(context);
                                                                    if(confirm == true)
                                                                    {
                                                                      setState(() {
                                                                        context.read<TodoViewBloc>().add(DeleteTaskConfigurationEvent(id: task['id']));
                                                                      });
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        const SnackBar(content: Text('Task deleted successfully')),
                                                                      );
                                                                    }else{
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        const SnackBar(content: Text('Deletion cancelled.')),
                                                                      );
                                                                    }
                                                                  },
                                                                  child: const Icon(
                                                                    Icons.delete_outline,
                                                                    size: 16,
                                                                    color: Colors.red,
                                                                  )
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: loading,
                        child: Center(child: Utils.getProgressIndicator(context)))
                  ],
                );
              }
          ),
        )
    );
  }
}
