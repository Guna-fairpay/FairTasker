//
// import 'package:fairpytasker/Repository/todo_list_repository.dart';
// import 'package:fairpytasker/Response/TodoListResponse.dart';
// import 'package:fairpytasker/Todo/user_group_response.dart';
// import 'package:fairpytasker/Utilities/appC.dart';
// import 'package:fairpytasker/Utilities/utils.dart';
// import 'package:fairpytasker/Vehicle/vehicle_history_module_ui.dart';
// import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
// import 'package:fairpytasker/upcoming_task/assigned_to_response.dart';
// import 'package:flutter/material.dart';
//
// class VehicleHistoryUI extends StatefulWidget {
//   final Map<String,dynamic>? outerTodos;
//   final List<UserGroupData>? userGroupList;
//   final List<Resource>? resourceList;
//   const VehicleHistoryUI({required this.outerTodos, required this.userGroupList, required this.resourceList, Key? key}) : super(key: key);
//
//   @override
//   State<VehicleHistoryUI> createState() => _VehicleUIState();
// }
//
// class _VehicleUIState extends State<VehicleHistoryUI> with TickerProviderStateMixin {
//
//   late VehicleDataBloc vehicleDataBloc;
//   // List<Todos> todoList = [];
//   // List<Todos> tempSearchList = [];
//   Color textColors = AppC.text;
//   String lastEditedId = '';
//   OverlayEntry? overlay;
//   TodoListRepo? todoListRepo;
//
// /*  void show(BuildContext context, String message, String status) {
//     overlay = OverlayEntry(
//       builder: (context) => Positioned(
//         bottom: 16.0,
//         left: MediaQuery.of(context).size.width * 0.1,
//         child: ToastWidget(message, () {
//           if(overlay != null) {
//             overlay?.remove();
//           }
//           vehicleDataBloc.add(
//               CompleteTodoItem(todoId: lastEditedId, status: status));
//         }),
//       ),
//     );
//     Overlay.of(context).insert(overlay!);
//     Timer(const Duration(seconds: 3), () {
//       if(overlay != null) {
//         overlay?.remove();
//       }
//     });
//   }*/
//
//   @override
//   void initState() {
//     super.initState();
//     vehicleDataBloc = VehicleDataBloc();
//     todoListRepo = TodoListRepo();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             centerTitle: true,
//             elevation: 0,
//             backgroundColor: AppC.trans,
//             leading: IconButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 icon: const Icon(
//                   Icons.arrow_back_sharp,
//                   color: AppC.black,
//                 )),
//             title: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Expanded(
//                   child: Utils.getText(widget.outerTodos?['vin'] != null ?
//                   widget.outerTodos != null?['vehicle_name'] : widget.outerTodos!['vehicleGroupName']??'',
//                       size: 18, weight: FontWeight.w700),
//                 ),
//                 const SizedBox(width: 12,),
//                 InkWell(
//                   onTap: (){
//                     Utils.getImageTitleDialog(context, widget.outerTodos!['vehicle_name'], widget.outerTodos!['vehicleImage']);
//                   },
//                   child:  Icon(Icons.remove_red_eye,
//                     color: AppC().base,
//                     size: 18,),
//                 ),
//               ],
//             )),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5.0),
//           child: VehicleHistoryModuleUI(
//               todoListRepo: todoListRepo!/*.vehicleHistoryTempSearchList*/,
//               outerTodos: widget.outerTodos, resourceList: widget.resourceList, userGroupList: widget.userGroupList),
//         )
//     );
//   }
//
// /*
//   Widget vehicleHistoryUIWithoutScaffold(){
//     return BlocProvider(
//         create: (context) => vehicleDataBloc..add(
//             GetVehicleHistoryEvent(vin: widget.outerTodos!.vin, vehicleGroupId: widget.outerTodos!.vehicleGroupId)),
//         child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
//             listener: (context, state) async {
//               if(state is TodoItemCompleted){
//                 show(
//                     context,
//                     (state.status) == 'In Progress' ? 'The todo marked as In Progress.' : 'The todo marked as Completed.',
//                     (state.status) == 'In Progress' ? 'Completed' : 'In Progress'
//                 );
//                 if(state.result != null && state.result!){
//                   vehicleDataBloc.add(
//                       GetVehicleHistoryEvent(vin: widget.outerTodos!.vin, vehicleGroupId: widget.outerTodos!.vehicleGroupId));
//                 }
//               }else if(state is VehicleHistoryLoaded){
//                 if(state.vehicleHistoryList != null){
//                   todoList.clear();
//                   tempSearchList.clear();
//                   for(Todos todos in state.vehicleHistoryList!){
//                     if(todos.status == 'Completed'){
//                       todos.textColors = AppC().base;
//                     }else{
//                       todos.textColors = AppC.text;
//                     }
//                   }
//                   todoList.addAll(state.vehicleHistoryList!);
//                   tempSearchList.addAll(state.vehicleHistoryList!);
//                 }
//               }
//             },
//             builder: (context, state) {
//               return Stack(
//                 children: [
//                   RefreshIndicator(
//                     color: AppC().base,
//                     onRefresh: () async {
//                       vehicleDataBloc.add(GetVehicleHistoryEvent(vin: widget.outerTodos!.vin, vehicleGroupId: widget.outerTodos!.vehicleGroupId));
//                     },
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                         child: Column(
//                           children: [
//                             Visibility(
//                               visible: tempSearchList.isNotEmpty,
//                               child: Utils.getSearchBarUI(
//                                       () {
//                                     //onTap
//                                   },
//                                       (value) {
//                                     //    onChange
//                                     todoList.clear();
//                                     if(value.isEmpty){
//                                       todoList.addAll(tempSearchList);
//                                     }else{
//                                       for(Todos data in tempSearchList) {
//                                         if (((data.title??'').toLowerCase()).contains(value.toLowerCase())){
//                                           todoList.add(data);
//                                         }
//                                       }
//                                     }
//                                     setState(() {});
//                                   },
//                                   searchController),
//                             ),
//                             const SizedBox(height: 8,),
//                             Visibility(
//                               visible: todoList.isNotEmpty,
//                               replacement: Center(child: Utils.getEmptyTextWidget(topPadding: 30)),
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                                 child: ListView.builder(
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemCount: todoList.length,
//                                   itemBuilder: (context, index) {
//                                     return InkWell(
//                                         onTap: () async {
//                                           bool? result = await Navigator.of(context).push(MaterialPageRoute(
//                                             builder: (context) => VehicleHistoryDetailUI(outerTodos: widget.outerTodos,
//                                                 todos: todoList[index]),
//                                           ));
//                                           if(result != null){
//                                             vehicleDataBloc.add(GetVehicleHistoryEvent(vin: widget.outerTodos!.vin, vehicleGroupId: widget.outerTodos!.vehicleGroupId));
//                                           }
//                                         },
//                                         child: listItem(todoList[index], index));
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Visibility(
//                       visible: state is VehicleDataLoading,
//                       child: Center(child: Utils.getProgressIndicator(context)))
//                 ],
//               );
//             }));
//   }
//
//   TextEditingController searchController = TextEditingController();
//   Widget listItem(Todos todos, int index) {
//     return Row(
//       children: [
//         Utils.getText(todos.todoDate??'', weight: FontWeight.bold, color: todos.textColors!),
//         const SizedBox(width: 8,),
//         Expanded(
//           child: Slidable(
//             key: ValueKey(index),
//             endActionPane: ActionPane(
//               motion: const ScrollMotion(),
//               children: [
//                 SlidableAction(
//                   onPressed: (context){
//                     lastEditedId = todos.id.toString();
//                     vehicleDataBloc.add(
//                         CompleteTodoItem(
//                             todoId: lastEditedId,
//                             status: (todos.status=='In Progress') ? 'Completed' : 'In Progress'));
//                   },
//                   foregroundColor: todos.status=='In Progress' ? AppC.green : AppC.black,
//                   label: todos.status=='In Progress' ? 'Complete' : 'In Progress',
//                 ),
//               ],
//             ),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               decoration: BoxDecoration(
//                 border: Border(
//                   top: const BorderSide(color: AppC.white, width: 1),
//                   left: const BorderSide(color: AppC.white, width: 1),
//                   right: const BorderSide(color: AppC.white, width: 1),
//                   bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 1,
//                     offset: const Offset(0, 5), // Adjust the offset for the side you want the shadow
//                   ),
//                 ],
//                 color: AppC.white,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Utils.getText(
//                             '${todos.title}', weight: FontWeight.bold, color: todos.textColors!),
//                       ),
//                       Utils.getText(Utils.convertString24HTo12H(todos.todoTime), color: todos.textColors!)
//                     ],
//                   ),
//                   const SizedBox(height: 5,),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         child: Visibility(
//                           visible: (todos.vehicleName != null && todos.vehicleName != 'null') ||
//                               (todos.person != null && todos.person != 'null') ||
//                               (todos.isPartsEdit != null && todos.isPartsEdit!) ||
//                               (todos.isSupplyEdit != null && todos.isSupplyEdit!) ||
//                               (todos.vehicleGroupId != null && todos.vehicleGroupId != 0),
//                           child: InkWell(
//                               onTap: (){
//                               },
//                               child: todos.isPartsEdit! ?
//                               getDetailsInWraps((todos.parts??[]).map((e) => (e.partsName??'')).toList(), '') : todos.isSupplyEdit! ?
//                               getDetailsInWraps((todos.supplies??[]).map((e) => (e.supplyName??'')).toList(), '') : todos.isVehicleGroupEdit! ?
//                               getDetailsInWraps((todos.vehicleGroupList??[]).map((e) => (e.vehicleName??'')).toList(), todos.vehicleGroupName??'') :
//                               Utils.getText('')
//                             // : Utils.getText(''),
//                           ),
//                         ),
//                       ),
//                       Visibility(
//                         visible:  todos.isPartsEdit! || todos.isSupplyEdit! || todos.isVehicleGroupEdit!,
//                         child: InkWell(
//                           onTap: (){
//                             todos.isPartsEdit = false;
//                             todos.isSupplyEdit = false;
//                             todos.isVehicleGroupEdit = false;
//                             setState(() {});
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
//                             decoration: BoxDecoration(
//                                 borderRadius: const BorderRadius.all(Radius.circular(0)),
//                                 border: Border.all(color: AppC.fieldBase*/
// /*, width: 0.2*//*
// )
//                             ),
//                             child: const Icon(Icons.clear_rounded,
//                               color: AppC.red,
//                               size: 18,),
//                           ),
//                         ),
//                       ),
//                       // TODO: show parts and supply
//                       const SizedBox(width: 12,),
//                       Visibility(
//                         visible: (todos.parts??[]).isNotEmpty,
//                         child: InkWell(
//                             onTap: () {
//                               todos.isPartsEdit = true;
//                               setState(() {});
//                             },
//                             child: Utils.getText('P', size: 15, weight: FontWeight.bold, color: todos.textColors!)),
//                       ),
//                       const SizedBox(width: 12,),
//                       Visibility(
//                         visible: (todos.supplies??[]).isNotEmpty,
//                         child: InkWell(
//                             onTap: () {
//                               todos.isSupplyEdit = true;
//                               setState(() {});
//                             },
//                             child: Utils.getText('S',  size: 15, weight: FontWeight.bold, color: todos.textColors!)),
//                       ),
//                       const SizedBox(width: 12,),
//                       Visibility(
//                         visible: (todos.vehicleGroupId != null && todos.vehicleGroupId!=0),
//                         child: InkWell(
//                             onTap: () {
//                               todos.isVehicleGroupEdit = true;
//                               setState(() {});
//                             },
//                             child: Utils.getText('G',  size: 15, weight: FontWeight.bold, color: todos.textColors!)),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 5,),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Utils.getText(
//                                 todos.vendorName != null && todos.vendorName != 'null' ? '${todos.vendorName}':
//                                 todos.location != null && todos.location != 'null' ? '${todos.location}' : '', color: todos.textColors!),
//                             Expanded(
//                               child: Utils.getText(
//                                   todos.notes != null && todos.notes != 'null' ? ' (${todos.notes??''}) ': '',
//                                   overFlow: TextOverflow.ellipsis, color: todos.textColors!),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Visibility(
//                         visible: todos.users != null || todos.userGroupId != null,
//                         child: todos.users != null ? Utils.getText(
//                             '${todos.users?.firstName?.characters.first.toUpperCase()}'
//                                 '${todos.users?.lastName?.characters.first.toUpperCase()}',
//                             weight: FontWeight.bold, color: todos.textColors!)
//                             : getUserGroupDataById(todos),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget getUserGroupDataById(Todos todos) {
//     todos.userGroupConcatenationName = '';
//     for(UserGroupData u in (widget.userGroupList??[])){
//       if(u.id==todos.userGroupId){
//         List<dynamic> jsonList = json.decode(u.userId??'');
//         List<dynamic> resultList = jsonList.cast<dynamic>();
//         for(dynamic userId in resultList){
//           for(Resource res in (widget.resourceList??[])){
//             if(userId.toString() == res.id.toString()) {
//               todos.userGroupConcatenationName = (todos.userGroupConcatenationName??'') + '${res.firstName?.characters.first.toUpperCase()}${res.firstName?.characters.first.toUpperCase()}, ';
//             }
//           }
//         }
//       }
//     }
//     return Utils.getText(todos.userGroupConcatenationName??'',
//         color: todos.textColors!, weight: FontWeight.bold);
//   }
//
//   Widget getDetailsInWraps(List<String> list, String title){
//     return Container(
//       padding: const EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
//       decoration: BoxDecoration(
//           border: Border.all(color: AppC.fieldBase, width: Num.borderWidthField,),
//           borderRadius: const BorderRadius.all(Radius.circular(Num.radiusButton))
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Utils.getText(title),
//           const SizedBox(height: 5,),
//           Wrap(
//             children: List<Widget>.generate(
//               list.length,
//                   (int idx) {
//                 return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2),
//                     child: Chip(
//                       padding: EdgeInsets.zero,
//                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       labelPadding: const EdgeInsets.symmetric(horizontal: 4),
//                       backgroundColor:
//                       AppC().bottomIconColor.withOpacity(0.1),
//                       shape: RoundedRectangleBorder(
//                       borderRadius:BorderRadius.circular(5)),
//                       label: Utils.getText(
//                           list[idx]??'',
//                           color: AppC.text, size: 13),
//                     ));
//               },
//             ).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// */
// }
//
// /*class ToastWidget extends StatelessWidget {
//   final String message;
//   final VoidCallback undoCallback;
//
//   const ToastWidget(this.message, this.undoCallback, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppC.trans,
//       child: Card(
//         elevation: 8,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
//           decoration: BoxDecoration(
//             color: AppC.grey.withOpacity(0.3),
//             borderRadius: BorderRadius.circular(Num.radiusButton),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Utils.getText(
//                 message,
//                 size: 16,
//                 color: AppC.text,
//               ),
//               const SizedBox(width: 8.0),
//               Utils.getFilledButton('Undo', undoCallback, verticalPadding: 2)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }*/
//
