import 'dart:async';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/custom_auto_search_field.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/UI/task_main_page.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class TaskIdentifier extends StatelessWidget {
  final List<dynamic> tasks;
  final List<dynamic> vehicles;
  final List<dynamic> gVehicles;
  final List<dynamic> persons;
  final List<dynamic> vendors;
  final List<dynamic> location;
  final Map<int, dynamic>? selected;
  final void Function(Map<int, dynamic> val)? onSelected;
  final TextEditingController taskIdentifierController;

  TaskIdentifier(
      {super.key,
      required this.taskIdentifierController,
      required this.location,
      required this.persons,
      required this.tasks,
      required this.vehicles,
      required this.gVehicles,
      required this.vendors,
      this.onSelected,
      this.selected}) {
    initState();
  }

  Timer? _debounce;

  String type = "task";
  int partNumber = 1;
  final FocusNode _focusNode = FocusNode();
  Map<int, dynamic> selectedList = {};
  List<Map<String, dynamic>> commonList = [];
  List<Map<String, dynamic>> vTasks = [];
  List<Map<String, dynamic>> vPersons = [];
  List<Map<String, dynamic>> vLocations = [];
  int trigger = 0;
  String _previousText = "";
  ValueNotifier<bool> showEmptyNotifier = ValueNotifier(false);

  void initState() {
    updateCommonList();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _listenNotifiers());
  }

  void _listenNotifiers() {
    if ((selected != null) && (selected?.isNotEmpty ?? false)) {
      if (selected![1] != null) selectedList[1] = selected![1];
      if (selected![2] != null) selectedList[2] = selected![2];
      if (selected![3] != null) selectedList[3] = selected![3];
      if (selected?.containsKey(1) == false) selectedList.remove(1);
      if (selected?.containsKey(2) == false) selectedList.remove(2);
      if (selected?.containsKey(3) == false) selectedList.remove(3);
      _setValue(emit: false);
    } else {
      taskIdentifierController.clear();
    }
  }

  void updateCommonList() {
    vTasks = CustomSearchDataConverter.convertTasks(tasks: tasks);
    vPersons = CustomSearchDataConverter.convertVPerson(vehicles: vehicles, persons: persons, groupVehicles: gVehicles);
    vLocations = CustomSearchDataConverter.convertVLocation(vendors: vendors, locations: location);
    commonList = vTasks;
  }

  void _setValue({bool emit = true}) {
    Console.of.warning("SetValue:	$emit", name: "TaskIdentifier");
    if (emit) {
      onSelected?.call(selectedList);
    }
    Console.of.log(formatMapData(selectedList), name: "TaskIdentifier");
     taskIdentifierController.text = formatMapData(selectedList);
     taskIdentifierController.value.copyWith(selection: TextSelection.collapsed(offset:  formatMapData(selectedList).length - 1));
     Console.of.log("${_isHavingHypen()} ${taskIdentifierController.text}", name: "TaskIdentifier");
    // _onSearch(taskIdentifierController.value);
  }

  bool _isHavingHypen() {
    var value = taskIdentifierController.text.split("-");
    value.removeWhere((element) => element.isEmpty);
    return value.length < 3;
  }

  String formatMapData(Map<int, dynamic> mapData) {
    List<String> names = [];
    // Sorting the map by keys
    var sortedEntries = mapData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Convert back to a Map
    Map sortedMap = Map.fromEntries(sortedEntries);


    // Extract names from mapData
    sortedMap.forEach((key, value) {
      if (value?.containsKey('name') ?? false) {
        names.add(value['name']);
      }
    });

    // Convert to string with conditions
    String result = names.join('-');
    if (names.length == 3) return names.join("-");
    if (mapData.containsKey(2) && !mapData.containsKey(3)) {
      return '${mapData.containsKey(1) ? "" : "-"}$result-'; // Wrap with '-'
    } else if (mapData.containsKey(3) && !mapData.containsKey(2) && !mapData.containsKey(1)) {
      return '-$result'; // Start with '-'
    } else if (mapData.containsKey(2) && !mapData.containsKey(1) && mapData.containsKey(3)) {
      return '-$result'; // Start with '-'
    } else if (mapData.containsKey(1) && !mapData.containsKey(3)) {
      return '$result-';
    }

    return result; // Default case
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, value, child) {
        return CustomAutoSearchField<Map<String, dynamic>>(
          controller: taskIdentifierController,
          labelText: "Task Identifier",
          onEmptyWidgetTap: () => context.push(TaskMainPage(title: taskIdentifierController.text), fullscreenDialog: true),
          onSelected: (value) {
            selectedList[value['partNumber']] = value;
            log("onSelected:	$value", name: "TaskIdentifier");
            onSelected?.call(selectedList);
            Utils.dismissKeyboard(context);
          },
          showEmptyWidget: value,
          itemAsString: (item) => (item.containsKey("subname")) ? "${item['name']}${item['subname']}" : item['name'].toString(),
          optionsBuilder: _onSearch,
        );
      }, valueListenable: showEmptyNotifier,
    );
  }

  FutureOr<Iterable<Map<String, dynamic>>> onSearch(TextEditingValue textEditingValue) async {
    var val = taskIdentifierController.text;
    if (val.isEmpty) {
      selectedList.clear();
      onSelected?.call({});
      showEmptyNotifier.value = false;
      return [];
    }
    var inputValue = val.toLowerCase();
    if (!inputValue.contains("-")) {
      commonList = vTasks;
      var list = commonList.where((element) => isExist(element, val));
      showEmptyNotifier.value = list.isEmpty;
      return list;
    }
    var inputParts = inputValue.split("-");
    var cursorPosition =  taskIdentifierController.selection.start;
    var filteredRecords = [];
    List<int> hyphenPositions = [];
    for (int i = 0; i < inputValue.length; i++) {
      if (inputValue[i] == "-") hyphenPositions.add(i);
    }
    var typedPart = '';
    if (hyphenPositions.isEmpty) {
      typedPart = inputValue;
      partNumber = 1;
    } else {
      for (int i = 0; i < hyphenPositions.length; i++) {
        if (cursorPosition > hyphenPositions[i]) {
          if (i == hyphenPositions.length - 1) {
            typedPart = inputValue.substring(hyphenPositions[i] + 1);
            partNumber = i + 2;
          }
        } else {
          if (i == 0) {
            typedPart = inputValue.substring(0, hyphenPositions[i]);
            partNumber = 1;
          } else {
            typedPart = inputValue.substring(hyphenPositions[i - 1] + 1, hyphenPositions[i]);
            partNumber = i + 1;
          }
          break;
        }
      }
    }
    switch(partNumber) {
      case 1: {
        type = "task";
        commonList = vTasks;
      }
      break;
      case 2:
        {
          if (typedPart.isEmpty) {
            // PART 1
            filteredRecords = vTasks.where((element) => element['name'].toString().toLowerCase().contains(inputParts[0].toLowerCase())).toList();
            selectedList[1] = filteredRecords.firstOrNull;
          }
          type = "vperson";
          commonList = vPersons;
        }
        break;
      case 3:
        {
          if (typedPart.isEmpty) {
            // PART 2
            filteredRecords = vPersons.where((element) => element['name'].toString().toLowerCase().contains(inputParts[1].toLowerCase())).toList();
            selectedList[2] = filteredRecords.firstOrNull;
          }
          type = "vlocation";
          commonList = vLocations;
        }
        break;
      default:
        commonList = [];
        break;
    }
    if (typedPart.isEmpty && partNumber == 3 && inputParts.length == 3) {
      filteredRecords = vLocations.where((element) => element['name'].toString().toLowerCase().contains(inputParts[2].toLowerCase())).toList();
      selectedList[3] = filteredRecords.firstOrNull;
    }
    inputParts.forEachIndexed((index, element) {
      if (element.isEmpty) {
        selectedList.remove(index+1);
      }
    });
    log("$selectedList", name: "SELECTED_LIST");
    Console.of.log("PartNumber $partNumber $cursorPosition $inputParts");
    _debounce?.cancel();
    _debounce = Timer(Durations.extralong4, updateToFunction);
    var inputted = (taskIdentifierController.text.split("-"));
    List<String> omitted = (inputted).length <= 3 ? inputted : [];
    omitted.removeWhere((element) => element.isNullOrEmpty);
    if (omitted.length == 3) {
      omitted.removeWhere((element) => ![
        ...(vTasks.map((e) => e['name'])),
        ...(vPersons.map((e) => e['name'])),
        ...(vLocations.map((e) => e['name']))
      ].contains(element));
    }
    if (inputParts.length > 3) commonList.clear();
    log("$omitted ${omitted.length}", name: "OMITTED");
    var list = commonList.where((element) => !omitted.contains(element['name'])).where((element) => isExist(element, typedPart) ).toList();
    return ((omitted.length == 3) || (selectedList.values.map((e) => e['name']) == inputted)) ? [] : list;
  }

  List<String> get _inputParts {
    return taskIdentifierController.text.split("-");
  }

  List<SearchFieldListItem<Map<String, dynamic>>>? onSearchOld(String val) {
    if (val.isEmpty) {
      selectedList.clear();
      onSelected?.call({});
    }
    var inputValue = val.toLowerCase();
    if (!inputValue.contains("-")) {
      commonList = vTasks;
      return commonList.where((element) => isExist(element, val) ).map((e) => SearchFieldListItem(
          e['name'],
          item: e)).toList();
    }
    var inputParts = inputValue.split("-");
    var cursorPosition =  taskIdentifierController.selection.start;
    var filteredRecords = [];
    List<int> hyphenPositions = [];
    for (int i = 0; i < inputValue.length; i++) {
      if (inputValue[i] == "-") hyphenPositions.add(i);
    }
    var typedPart = '';
    if (hyphenPositions.isEmpty) {
      typedPart = inputValue;
      partNumber = 1;
    } else {
      for (int i = 0; i < hyphenPositions.length; i++) {
        if (cursorPosition > hyphenPositions[i]) {
          if (i == hyphenPositions.length - 1) {
            typedPart = inputValue.substring(hyphenPositions[i] + 1);
            partNumber = i + 2;
          }
        } else {
          if (i == 0) {
            typedPart = inputValue.substring(0, hyphenPositions[i]);
            partNumber = 1;
          } else {
            typedPart = inputValue.substring(hyphenPositions[i - 1] + 1, hyphenPositions[i]);
            partNumber = i + 1;
          }
          break;
        }
      }
    }
    switch(partNumber) {
      case 1: {
        type = "task";
        commonList = vTasks;
      }
      break;
      case 2:
        {
          if (typedPart.isEmpty) {
            // PART 1
            filteredRecords = vTasks.where((element) => element['name'].toString().toLowerCase().contains(inputParts[0].toLowerCase())).toList();
            selectedList[1] = filteredRecords.firstOrNull;
          }
          type = "vperson";
          commonList = vPersons;
        }
        break;
      case 3:
        {
          if (typedPart.isEmpty) {
            // PART 2
            filteredRecords = vPersons.where((element) => element['name'].toString().toLowerCase().contains(inputParts[1].toLowerCase())).toList();
            selectedList[2] = filteredRecords.firstOrNull;
          }
          type = "vlocation";
          commonList = vLocations;
        }
        break;
      default:
        commonList = [];
        break;
    }
    if (typedPart.isEmpty && partNumber == 3 && inputParts.length == 3) {
      filteredRecords = vLocations.where((element) => element['name'].toString().toLowerCase().contains(inputParts[2].toLowerCase())).toList();
      selectedList[3] = filteredRecords.firstOrNull;
    }
    inputParts.forEachIndexed((index, element) {
      if (element.isEmpty) {
        selectedList.remove(index+1);
      }
    });
    log("$selectedList", name: "SELECTED_LIST");
    _debounce?.cancel();
    _debounce = Timer(Durations.extralong4, updateToFunction);
    return commonList.where((element) => isExist(element, typedPart) ).map((e) => SearchFieldListItem(
        (e.containsKey("subname") ? "${e['name']}${e['subname']}" : e['name'].toString()),
        item: e)).toList();
  }

  void updateToFunction() {
    Console.of.log("PART NUMBER #$partNumber $_inputParts", name: "TASK_IDENTIFIER");
    var currentText = taskIdentifierController.text;
    var formattedText = formatMapData(selectedList);
    log("${selected != selectedList} ${formattedText.length > taskIdentifierController.text.length}", name: "updateToFunction");
    if (_previousText.isNotEmpty && currentText.length < _previousText.length) {
      log("Removing chars",name: "updateToFunction");
      onSelected?.call(selectedList);
    }
    _previousText = currentText;
  }

  bool isExist(Map<String, dynamic> data, String input) {
    if (data.containsKey("subname")) {
      return data['name'].toString().toLowerCase().contains(input.toLowerCase()) || data['subname'].toString().toLowerCase().contains(input.toLowerCase());
    } else {
      return data['name'].toString().toLowerCase().contains(input.toLowerCase());
    }
  }

  FutureOr<Iterable<Map<String, dynamic>>> _onSearch(TextEditingValue textEditingValue) {
    return onSearch(textEditingValue);
  }
}
