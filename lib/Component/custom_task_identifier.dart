import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/task_add_ui.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class TaskIdentifier extends StatefulWidget {
  final List<dynamic> tasks;
  final List<dynamic> vehicles;
  final List<dynamic> persons;
  final List<dynamic> vendors;
  final List<dynamic> location;
  final TextEditingController taskIdentifierController;
  final ValueNotifier<Map<String, dynamic>>? selectedTask;
  final ValueNotifier<List<Map<String, dynamic>>>? selectedVPersons;
  final ValueNotifier<Map<String, dynamic>>? selectedVLocations;

  const TaskIdentifier(
      {super.key,
      required this.taskIdentifierController,
      required this.location,
      required this.persons,
      required this.tasks,
      required this.vehicles,
      required this.vendors,
      this.selectedTask,
      this.selectedVPersons,
      this.selectedVLocations});

  @override
  State<TaskIdentifier> createState() => _TaskIdentifierState();
}

class _TaskIdentifierState extends State<TaskIdentifier> {
  String type = "task";
  int partNumber = 1;
  late FocusNode _focusNode;
  Map<int, dynamic> selectedList = {};
  List<Map<String, dynamic>> commonList = [];
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> vPersons = [];
  List<Map<String, dynamic>> vLocations = [];
  int trigger = 0;

  @override
  void initState() {
    updateCommonList();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _listenNotifiers());
    super.initState();
  }

  void _listenNotifiers() {
    widget.selectedTask?.addListener(() {
      if (widget.selectedTask?.value != null) {
        selectedList[1] = widget.selectedTask?.value;
        _setValue(emit: false);
      }
    });
    widget.selectedVPersons?.addListener(() {
      if ((widget.selectedVPersons?.value != null) && (widget.selectedVPersons?.value.isNotEmpty ?? false)) {
        var value = widget.selectedVPersons?.value.lastOrNull;
        if (value == null) selectedList.remove(2); _setValue(emit: false);
        if ((selectedList[2] == null) || (selectedList[2] != value)) {
          selectedList[2] = value;
          _setValue(emit: false);
        }
      }
    });
    widget.selectedVLocations?.addListener(() {
      if (widget.selectedVLocations?.value != null) {
        selectedList[3] = widget.selectedVLocations?.value;
        _setValue(emit: false);
      }
    });
  }

  @override
  void didUpdateWidget(covariant TaskIdentifier oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.tasks != widget.tasks) ||
        (oldWidget.vendors != widget.vendors) ||
        (oldWidget.persons != widget.persons) ||
        (oldWidget.vehicles != widget.vehicles) ||
        (oldWidget.location != widget.location)) {
      updateCommonList();
    }
  }

  void updateCommonList() {
    log("UpdateCommonList (${trigger++}) ${widget.tasks.length} ${widget.vehicles.length} ${widget.persons.length} ${widget.vendors.length} ${widget.location.length}", name: "TRIGGER_IDENTIFIER");
    tasks = widget.tasks
        .map((e) => {"id": e['id'], "name": e['task'], "type": "task", "partNumber" : 1, "value" : e})
        .toList();
    var persons = widget.persons.map((element) =>
    {
      "id": element['id'],
      "name": [element['first_name'], element['last_name']].join(" "),
      "type": "person",
      "partNumber" : 2,
      "value" : element
    }).toList();
    var vehicles = widget.vehicles.map((element) =>
    {
      "id": element['id'],
      "name": element['vehicle_name'],
      "subname" : "\t(${element['vehicle_number']})",
      "type": "vehicles",
      "partNumber" : 2,
      "value" : element
    }).toList();
    vPersons = [...vehicles, ...persons];
    var locations = widget.location.map((element) =>
    {
      "id": element['id'],
      "name": element['name'],
      "type": "location",
      "partNumber" : 3,
      "value" : element
    }).toList();
    var vendors = widget.vendors.map((element) => {
      "id": element['id'],
      "name": element['name'],
      "type": "vendors",
      "partNumber" : 3,
      "value" : element
    }).toList();
    vLocations = [...vendors, ...locations];
    commonList = tasks;
    log("UpdateCommonList ${commonList.length} ${tasks.length} ${vPersons.length} ${vLocations.length}", name: "TRIGGER_IDENTIFIER_COMMON");
    _setState;
  }

  void _setValue({bool emit = true}) {
    log("setValue:\t$selectedList", name: "TaskIdentifier");
    if (emit) {
      try {
        selectedList.forEach((key, value) {
          log("setValue(b):	$key $value", name: "TaskIdentifier");
          if (key == 1) {
            widget.selectedTask?.value = value;
          } else if (key == 2) {
            try {
              if (value['type'] == "person") widget.selectedVPersons?.value = [value];
              if (value['type'] == "vehicles") {
                widget.selectedVPersons?.value.removeWhere((
                    element) => element.containsKey('type') && (element['type'] == "person"));
                if (widget.selectedVPersons?.value.contains(value) == false) widget.selectedVPersons?.value = [...(widget.selectedVPersons?.value ?? []), ...[value] ];
              }
              widget.selectedVPersons?.notifyListeners();
            } on Exception catch (e) {
              log("Exception:	$e", name: "TaskIdentifier");
            }
          } else if (key == 3) {
            widget.selectedVLocations?.value = value;
          }
        });
      } on Exception catch (e) {
        log("Exception(b):	$e", name: "TaskIdentifier");
      }
    }
    widget.taskIdentifierController.text = formatMapData(selectedList);
    widget.taskIdentifierController.value.copyWith(selection: TextSelection.collapsed(offset: widget.taskIdentifierController.text.length - 1));
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
    if (names.length < 2) {
    if (mapData.containsKey(2)) {
      return '-$result-'; // Wrap with '-'
    } else if (mapData.containsKey(3)) {
      return '-$result'; // Start with '-'
    }
    }

    return result; // Default case
  }

  get _setState => setState(() { });

  void _requestFocus() {
    _focusNode.requestFocus();
  }

  void _unRequestFocus() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSearchField<Map<String, dynamic>>(
      key: UniqueKey(),
        suggestions: commonList,
        focusNode: _focusNode,
        itemAsString: (item) => (item.containsKey("subname")) ? "${item['name']}${item['subname']}" : item['name'].toString(),
        onTap: _requestFocus,
        onTapOutSide: _unRequestFocus,
        onSuggestionTap: (val) {
        log("PartNumber:\t${val['partNumber']}", name: "VALUE_NUMBER");
          selectedList[val['partNumber']] = val;
          _setValue();
          _requestFocus();
        },
        onSearchTextChanged: onSearch,
        controller: widget.taskIdentifierController,
        suggestionState: Suggestion.hidden,
        labelText: "Task Identifier",
        onEmptyTap: () =>
            context.push(const TaskAddUI(), fullscreenDialog: true));
  }

 List<SearchFieldListItem<Map<String, dynamic>>>? onSearch(String val) {
    if (val.isEmpty) {
      selectedList.clear();
      // _unRequestFocus();
      // return null;
    }
    var inputValue = val.toLowerCase();
    if (!inputValue.contains("-")) {
      commonList = tasks;
      return commonList.where((element) => isExist(element, val) ).map((e) => SearchFieldListItem(
          e['name'],
          item: e)).toList();
    }
    var inputParts = inputValue.split("-");
    var cursorPosition = widget.taskIdentifierController.selection.start;
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
        commonList = tasks;
      }
      break;
      case 2:
        {
          if (typedPart.isEmpty) {
            // PART 1
            filteredRecords = tasks.where((element) => element['name'].toString().toLowerCase().contains(inputParts[0].toLowerCase())).toList();
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
    log("InputPartsCount(s) ${inputParts} ${inputParts.length} $cursorPosition $hyphenPositions $typedPart $partNumber", name: "TaskIdentifier");
    return commonList.where((element) => isExist(element, typedPart) ).map((e) => SearchFieldListItem(
        (e.containsKey("subname") ? "${e['name']}${e['subname']}" : e['name'].toString()),
        item: e)).toList();
  }

  bool isExist(Map<String, dynamic> data, String input) {
    if (data.containsKey("subname")) {
      return data['name'].toString().toLowerCase().contains(input.toLowerCase()) || data['subname'].toString().toLowerCase().contains(input.toLowerCase());
    } else {
      return data['name'].toString().toLowerCase().contains(input.toLowerCase());
    }
  }


}
