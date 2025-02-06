import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/task_add_ui.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
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

  const TaskIdentifier(
      {super.key,
      required this.taskIdentifierController,
      required this.location,
      required this.persons,
      required this.tasks,
      required this.vehicles,
      required this.vendors});

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

  @override
  void initState() {
    updateCommonList();
    _focusNode = FocusNode();
    log("InitState", name: "TaskIdentifier");
    widget.taskIdentifierController.addListener(_checkHyphens);
    super.initState();
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

  void _checkHyphens() {
    var inputValue = widget.taskIdentifierController.text;
    var inputParts = inputValue.split("-");
    if (inputParts.length > 3) {
      widget.taskIdentifierController.text = inputValue.substring(0, inputValue.length - 1);
    }
    inputParts.forEachIndexed((index, element) {
      if (element.isEmpty) {
        selectedList.remove(index+1);
      }
    });
    log("InputPartsCount ${inputParts} ${inputParts.length}", name: "TaskIdentifier");
  }

  void updateCommonList() {
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
      "type": "vehicles",
      "partNumber" : 2,
      "value" : element
    }).toList();
    vPersons = [...persons, ...vehicles];
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
      "type": "location",
      "partNumber" : 3,
      "value" : element
    }).toList();
    vLocations = [...locations, ...vendors];
    commonList = tasks;
    log("UpdateCommonList", name: "TaskIdentifier");
    _setState;
  }

  void _setValue() {
    var keys = selectedList.keys.toList();
    keys.sort((a, b) => a.compareTo(b));
    var values = keys.map((e) => selectedList[e]['name'].toString()).toList();
    widget.taskIdentifierController.text = values.join("-");
    if ((selectedList.values.isNotEmpty) && (selectedList.values.length < 3)) widget.taskIdentifierController.text = "${widget.taskIdentifierController.text}-";
    widget.taskIdentifierController.value.copyWith(
        selection: TextSelection.collapsed(offset: widget.taskIdentifierController.text.length - 1)
    );
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
        itemAsString: (item) => item['name'].toString(),
        onTap: _requestFocus,
        onTapOutSide: _unRequestFocus,
        onSuggestionTap: (val) {
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
    if (val.isEmpty) selectedList.clear();
    var inputValue = val.toLowerCase();
    if (!inputValue.contains("-")) {
      commonList = tasks;
      return commonList.where((element) => element['name'].toString().toLowerCase().contains(val.toLowerCase())).map((e) => SearchFieldListItem(
          (e['name']),
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
    log("InputPartsCount ${inputParts} ${inputParts.length} $cursorPosition $hyphenPositions $typedPart $partNumber", name: "TaskIdentifier");
    return commonList.where((element) => element['name'].toString().toLowerCase().contains(typedPart.toLowerCase())).map((e) => SearchFieldListItem(
        (e['name']),
        item: e)).toList();
  }


}
