
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/image_pick_helper.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleGroupingUI extends StatefulWidget {

  List<Map<String,dynamic>>? list;

  VehicleGroupingUI({Key? key, this.list}) : super(key: key);

  @override
  State<VehicleGroupingUI> createState() => _VehicleGroupingUIState();
}

class _VehicleGroupingUIState extends State<VehicleGroupingUI> with TickerProviderStateMixin {

  late VehicleDataBloc vehicleDataBloc;
  final FocusNode searchFocusNode = FocusNode();

  TextEditingController vehicleNameController = TextEditingController();
  List<String> vehicleStatusList = ['Active', 'InActive'];
  String? selectedVehicleStatus;
  AnimationController? animationController;
  ImagePickHelper imagePickHelper = ImagePickHelper();
  bool goBack = false;
  // int? editedVehicleId;
  int? editedVehicleItemId;
  List<Map<String,dynamic>> tempSearchList = [];
  List<Map<String,dynamic>> selectedVehicleList = [];
  List<Map<String,dynamic>> editVehicleList = [];
  TextEditingController editVehicleController = TextEditingController();
  List<dynamic> editVehicleSuggestionList = [];
  bool editShowVehicleList = false;
bool isSelected=false;
  @override
  void dispose() {
    if (animationController != null) {
      animationController!.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
    animationController = BottomSheet.createAnimationController(this);
    animationController!.duration = Num.bottomSheetStartDuration;
    animationController!.reverseDuration = Num.bottomSheetEndDuration;
    animationController!.drive(CurveTween(curve: Curves.easeIn));
    vehicleDataBloc.add(const GetAddedVehicleListData());
    if(widget.list != null){
      for(Map<String,dynamic> vehicleData in widget.list!) {
        if(isSelected) {
          isSelected = true;
          selectedVehicleList.add(vehicleData);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppC.trans,
            leading: IconButton(
                onPressed: () {
                  Utils.hideKeyboard(context);
                  if(goBack) {
                    Navigator.of(context).pop();
                  }
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: AppC.black,
                )),
            title: Utils.getText('Add Vehicle Group',
                size: 18, weight: FontWeight.w700)),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return true;
          },
          child: BlocProvider(
              create: (context) => vehicleDataBloc..add(const GetVehicleGroupingListV()),
              child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
                  listener: (context, state) async {
                    if (state is VehicleGroupListLoadedV) {
                      editedVehicleItemId = null;
                      tempSearchList.clear();
                      tempSearchList.addAll(state.vehicleGroupDataList??[]);
                      List<Map<String,dynamic>> list = [];
                      list.addAll(state.vehicleGroupDataList??[]);
                      list.sort((a, b) => DateTime.parse(a['created_at']??'').compareTo(DateTime.parse(b['created_at']??'')));
                      Utils.showListAsSheet(context, animationController, listWidget(list.reversed.toList()), (){});
                      goBack = true;
                    }else if (state is VehicleListLoaded) {
                      if (state.vehicleDataList != null) {
                        editVehicleList.addAll(state.vehicleDataList!);
                        for (var editVehicle in editVehicleList) {
                          if (selectedVehicleList.any((selectedVehicle) => selectedVehicle['id'] == editVehicle['id'])) {
                            isSelected = true;
                          }
                        }
                      }
                    }else if (state is AddVehicleGroupDataLoaded) {
                      localId = 0;
                      vehicleNameController.clear();
                      vehicleDataBloc.add(const GetVehicleGroupingListV());
                    }else if (state is VehicleDataLoadedV) {
                      if(state.result != null) {
                    vehicleDataBloc.add(const GetVehicleGroupingListV());
                  }
                }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        editShowVehicleList = false;
                        setState(() {});
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.2),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 15,),
                                    Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                                        'Group Name', vehicleNameController,
                                        label: Utils.getText('Group Name')),
                                    const SizedBox(height: 15,),
                                    Container(
                                      padding: const EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: AppC.fieldBase, width: Num.borderWidthField,),
                                          borderRadius: const BorderRadius.all(Radius.circular(Num.radiusButton))
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            children: List<Widget>.generate(
                                              selectedVehicleList.length,
                                                  (int idx) {
                                                return Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                    child: Chip(
                                                      onDeleted: (){
                                                        for (var element in editVehicleList) {
                                                          if(element['id'] == selectedVehicleList[idx]['id']){
                                                            isSelected = false;
                                                            // return;
                                                          }
                                                        }
                                                        selectedVehicleList.removeAt(idx);
                                                        setState(() {});
                                                      },
                                                      deleteIcon: const Icon(Icons.close, color: AppC.red, size: 18,),
                                                      backgroundColor:
                                                      AppC().bottomIconColor.withOpacity(0.1),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(5)),
                                                      // side: BorderSide(),
                                                      label: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Utils.getText(
                                                              selectedVehicleList[idx]['vehicle_name']??'',
                                                              color: AppC.text),

                                                        ],
                                                      ),
                                                    ));
                                              },
                                            ).toList(),
                                          ),
                                          const SizedBox(height: 15),
                                          Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                                              'Vehicle', editVehicleController,
                                              label: Utils.getText('Vehicle'),
                                              readOnly: false,
                                              onChangeCallback: (value){
                                                editVehicleSuggestionList.clear();
                                                List<dynamic> vehiclesList = editVehicleList/*.map((e) =>'${e.name}').toList()*/;
                                                editVehicleSuggestionList.addAll(Utils.searchObjectList(vehiclesList, value, isVehicleData: true));
                                                editShowVehicleList = editVehicleSuggestionList.isNotEmpty;
                                                setState(() {});
                                              }),
                                        ],
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        Column(
                                          children: [
                                            const SizedBox(height: 15,),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Utils.getFilledButton('Save', () {
                                                    if(vehicleNameController.text.isEmpty) {
                                                      // Utils.showMobileToast(Str.createTodoAlertText("Vehicle Group Name"));
                                                      vehicleNameController.text = 'Multiple Vehicles';
                                                    }
                                                   if(selectedVehicleList.isEmpty) {
                                                      Utils.showMobileToast(Str.createTodoAlertText("Adding any one vehicle"));
                                                    }else {
                                                      vehicleDataBloc.add(AddVehicleGroupingData(
                                                          id: editedVehicleItemId,
                                                          name: vehicleNameController.text,
                                                          // address: selectedAddressesList.where((e) => e.id == null).map((e) => e.address!).toList(),
                                                          selectedList: selectedVehicleList.map((e) => e['vin']!as String).toList()
                                                      ));
                                                    }
                                                  }),
                                                ),
                                                Visibility(
                                                  visible: editedVehicleItemId != null,
                                                  child: Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 15.0),
                                                      child: Utils.getFilledButton('Cancel', () {
                                                        editedVehicleItemId = null;
                                                        vehicleNameController.clear();
                                                        selectedVehicleList.clear();
                                                        localId = 0;
                                                      }),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15,),
                                          ],
                                        ),
                                        Visibility(
                                            visible: editShowVehicleList,
                                            child: Utils.customAutoCompleteWithUnSelectedOption(editVehicleSuggestionList, (index)
                                            {
                                              editShowVehicleList = false;
                                              selectedVehicleList.add(editVehicleSuggestionList[index]);
                                              editVehicleSuggestionList[index].isSelected = true;
                                              editVehicleController.selection = TextSelection.fromPosition(
                                                TextPosition(offset: (editVehicleController.text.length)),
                                              );
                                              setState(() {});
                                              editVehicleController.selection = TextSelection.fromPosition(
                                                TextPosition(offset: (editVehicleController.text.length)),
                                              );
                                            }, isVehicleData: true)
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: state is VehicleDataLoading,
                              child: Center(child: Utils.getProgressIndicator(context)))
                        ],
                      ),
                    );
                  })),
        ));
  }

  int localId = 0;
  TextEditingController searchController = TextEditingController();
  Widget listWidget(List<Map<String,dynamic>> list){
    debugPrint('vehiclegroup.list.length: ${list.length}');
    return
      StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Utils.getSearchBarUI(
                      () {//onTap
                  },
                      (value) {
                    //    onChange
                    list.clear();
                    if(value.isEmpty){
                      list.addAll(tempSearchList);
                    }else{
                      // tempSearchList.map((e) => e.);
                      for(Map<String,dynamic> data in tempSearchList) {
                        if (((data['name']??'').toLowerCase()).contains(value.toLowerCase())){
                          list.add(data);
                        }
                      }
                    }
                    setState(() {});
                  },
                  searchController),
            ),
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Utils.commonListItem(index, list[index]['name']??'',
                              () {
                            //item tap
                          },  () {
                            //edit tap
                            editedVehicleItemId = list[index]['id'];
                            vehicleNameController.text = list[index]['name']??'';
                            if(list[index]['vin'] != null){
                              debugPrint('list[index].vin: ${list[index]['vin']}');
                              List<String> resultList = Utils.parseVinList(list[index]['vin']!);
/*
                              String vinListWithoutBrackets = list[index].vin!.substring(1, list[index].vin!.length - 1);
                              List<String> resultList = vinListWithoutBrackets.split(', ');
                              resultList = resultList.map((vin) => vin.replaceAll('[', '').replaceAll(']', '')).toList();
*/
/*                        List<dynamic> jsonList = json.decode(list[index].vin!);
                           List<dynamic> resultList = jsonList;
                           List vinSplit = temp.split(',');
                            debugPrint('vinSplit.vin: ${list[index].vin??''}');
                            debugPrint('vinSplit: $vinSplit');
                            debugPrint('vinSplit: ${vinSplit.length}');
                            */
                              selectedVehicleList.clear();
                              for (String vin in resultList) {
                                for (Map<String,dynamic> vd in editVehicleList) {
                                  if (vin.trim().toString() ==
                                      (vd['vin'] ?? '').trim().toString()) {
                                    isSelected = true;
                                    selectedVehicleList.add(vd);
                                  }
                                }
                              }
                              debugPrint(
                                  'selectedVehicleList: ${selectedVehicleList
                                      .length}');
                              setState(() {});
                              doSetState();
                            }
                          }, () {
                            //delete tap
                            setState((){});
                            Utils.getAlertDialog(context, () {
                              localId = list[index]['id']!;
                              Navigator.of(context).pop();
                              setState((){});
                              vehicleDataBloc.add(DeleteVehicleGroupEvent(id: list[index]['id']));
                            }, content: 'Are you sure want to delete a Vehicle Group?');
                          }
                      ),
                      Visibility(
                          visible: localId == list[index]['id']!,
                          child: Center(child: Utils.getProgressIndicator(context, height: 35, width: 35)))
                    ],
                  );
                }
            ),
          ],
        );
      }
      );

  }

  void doSetState(){
    setState((){});
  }


}
