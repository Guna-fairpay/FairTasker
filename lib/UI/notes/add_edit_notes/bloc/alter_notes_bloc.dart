import 'dart:async';
import 'dart:math';

import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:fairpytasker/UI/notes/add_edit_notes/bloc/alter_notes_events.dart';
import 'package:fairpytasker/UI/notes/add_edit_notes/bloc/alter_notes_states.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:flutter/material.dart';

class AlterNotesBloc extends Bloc<AlterNotesEvents, AlterNotesStates> {
  dynamic noteId;
  DateTime selectedDate = DateTime.now();
  Map<String, dynamic>? editModel;
  List<Map<String, dynamic>> noteItems = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final APiRepository _aPiRepository = APiRepository();
  final TextEditingController titleController = TextEditingController();

  int? get branchId => Session.of.getInt(Str.branchIdPrefText);

  AlterNotesBloc() : super(AlterNotesLoadingState()) {
    on<AlterNotesInitialEvent>(_onInitialEvent);
    on<AlterNotesAddEvent>(_onAddEvent);
    on<AlterNotesRemoveEvent>(_onRemoveEvent);
    on<AlterNotesDeleteEvent>(_onDeleteEvent);
    on<AlterNotesShowHideNotesEvent>(_onShowHideNotesEvent);
    on<AlterNotesCreateUpdateTaskEvent>(_onCreateUpdateTaskEvent);
    on<AlterNotesTapUserEvent>(_onTapUserEvent);
    on<AlterNotesUserSelectionEvent>(_onUserSelectionEvent);
    on<AlterNotesSaveEvent>(_onSaveEvent);
    on<AlterNotesCompleteEvent>(_onCompleteEvent);
  }

  Future<Map<String, dynamic>?> _getNote(dynamic id) async =>
      await _aPiRepository.getNote(id: id);

  Future<Map<String, dynamic>?> _createNotes(Map<String, dynamic> body) async =>
      await _aPiRepository.createNote(body: body);

  Future<Map<String, dynamic>?> _createTask(Map<String, dynamic> body) async =>
      await _aPiRepository.addToDo(body: body);

  Future<Map<String, dynamic>?> _updateTask(
          Map<String, dynamic> body, dynamic toDoId) async =>
      await _aPiRepository.updateToDo(body: body, toDoId: toDoId);

  Future<Map<String, dynamic>?> _updateNoteItem(
          Map<String, dynamic> body, dynamic id) async =>
      await _aPiRepository.updateNoteItem(body: body, id: id);

  Future<Map<String, dynamic>?> _updateNote(Map<String, dynamic> body, dynamic id) async =>
      await _aPiRepository.putNotes(id: id,body: body);

  Future<GeneralResponse?> _deleteTask(dynamic id) async =>
      await _aPiRepository.deleteToDo(id, "Deleted using notes delete option");

  Future<Map<String, dynamic>?> _deleteNote(dynamic id) async =>
      await _aPiRepository.removeNoteItem(id: id);

  int get _randomId => Random().nextInt(99999); // USING ONLY FOR NEW TASKS

  void _onInitialEvent(
      AlterNotesInitialEvent event, Emitter<AlterNotesStates> emit) async {
    noteId = event.noteId;
    selectedDate = event.selectedDate;
    if (noteId.toString().isNullOrEmpty) {
      noteItems.add({
        "id": _randomId,
        "note_id": 0,
        "todo_id": 0,
        "title": TextEditingController(),
        "description": TextEditingController(),
        "complete_status": 0,
        "showNotes": false,
        "selectedUsers": [],
      });
    } else {
      emit(AlterNotesLoadingState());
      var response = await _getNote(noteId);
      editModel = response?['data'];
      titleController.text = editModel?['title'] ?? "";
      selectedDate =
          editModel?['date'].toString().toDateTime() ?? DateTime.now();
      noteItems = List<Map<String, dynamic>>.from(editModel?['note_items'])
          .map(
            (e) => e
              ..['title'] = TextEditingController(text: e['title'])
              ..['description'] = TextEditingController(
                  text: (e['todos']?['notes'] ?? e['description']) ?? "")
              ..['selectedUsers'] =
                  ((e['todos'].toString().isNullOrEmpty) || (e['todos'] == null)) ? [] : ([e['todos']?['users']]),
          )
          .toList();
    }
    emit(AlterNotesCommonState());
  }

  void _onAddEvent(AlterNotesAddEvent event, Emitter<AlterNotesStates> emit) {
    noteItems.add({
      "id": _randomId,
      "note_id": 0,
      "todo_id": 0,
      "title": TextEditingController(),
      "description": TextEditingController(),
      "complete_status": 0,
      "showNotes": false,
      "selectedUsers": [],
    });
    emit(AlterNotesCommonState());
  }

  void _onRemoveEvent(
      AlterNotesRemoveEvent event, Emitter<AlterNotesStates> emit) {
    var hasValue = (event.model?['title'] as TextEditingController)
        .text
        .trim()
        .isNotNullOrEmpty;
    var hasNoteId = (event.model?['note_id'] ?? 0) != 0;
    var hasToDoId = (event.model?['todo_id'] ?? 0) != 0;
    if (hasValue || hasNoteId || hasToDoId) {
      // ASK PERMISSION
      var hasNotes = (noteItems.length > 1);
      Console.of.log("NOTES $hasNotes TODO ${event.model?['todo_id']}");
      emit(AlterNotesRemovePermissionState(event.model, hasNotes, hasToDoId));
    } else {
      noteItems.remove(event.model);
      if (noteItems.isEmpty) add(AlterNotesAddEvent());
      emit(AlterNotesCommonState());
    }
  }

  void _onDeleteEvent(
      AlterNotesDeleteEvent event, Emitter<AlterNotesStates> emit) async {
    var hasValue = (event.model?['title'] as TextEditingController)
        .text
        .trim()
        .isNotNullOrEmpty;
    var hasNoteId = (event.model?['note_id'] ?? 0) != 0;
    var hasToDoId = ((event.model?['todos'] != null) && ((event.model?['todo_id'] ?? 0) != 0));
    if (event.type == "notes") {
      if (hasNoteId) {
        emit(AlterNotesLoadingState());
        var response = await _deleteNote(event.model?['id']);
        if (response != null) noteItems.remove(event.model);
      }
      if ((!hasNoteId) && hasValue) noteItems.remove(event.model);
    } else if ((event.type == "task") && hasToDoId) {
      emit(AlterNotesLoadingState());
      var response = await _deleteTask(event.model?['todo_id']);
      if (response != null) {
        for (var element in noteItems) {
          if (element['id'] == event.model?['id']) {
            element['todo_id'] = 0;
            element['todos'] = null;
            element['selectedUsers'] = [];
          }
        }
      }
    } else if (event.type == "both") {
      if (hasToDoId && hasNoteId) {
        emit(AlterNotesLoadingState());
        await Future.wait([
          _deleteTask(event.model?['todo_id']),
          _deleteNote(event.model?['id'])
        ]);
        noteItems.remove(event.model);
      }
    }
    FBroadcast.instance().broadcast("notes_view");
    if (noteItems.isEmpty) add(AlterNotesAddEvent());
    emit(AlterNotesCommonState());
  }

  void _onShowHideNotesEvent(
      AlterNotesShowHideNotesEvent event, Emitter<AlterNotesStates> emit) {
    var id = event.model?['id'];
    for (var element in noteItems) {
      if (element['id'] == id) element['showNotes'] = event.showNotes;
    }
    emit(AlterNotesCommonState());
  }

  void _onCreateUpdateTaskEvent(AlterNotesCreateUpdateTaskEvent event,
      Emitter<AlterNotesStates> emit) async {
    try {
      if ((formKey.currentState?.validate() ?? false)) {
        if (List.from(event.model?['selectedUsers']).isEmpty) {
          emit(AlterNotesErrorState("Select at-least one task manager"));
          return;
        }
        var toDoId = (event.model?['todo_id'] ?? 0);
        var hasNoteId = (event.model?['note_id'] ?? 0) != 0;
        if ((toDoId == 0) || (event.model?['todos'] == null)) {
          // INSERT
          var body = {
            "title": (event.model?['title'] as TextEditingController).text,
            "todo_time": DateTime.now().toFormat(format: "HH:mm:ss"),
            "user_id": "",
            "time_sensitive": "false",
            "start_at": selectedDate.toFormat(),
            "notes":
                (event.model?['description'] as TextEditingController).text,
            "identifier_id": null,
            "branch_id": branchId,
            "assigned_to": (event.model?['selectedUsers'] ?? [])
                .map((e) => e['id'])
                .toList(),
          };
          emit(AlterNotesLoadingState());
          var response = await _createTask(body);
          var toDo = List<Map<String, dynamic>>.from(response?['todo']).lastOrNull;
          if (toDo != null) {
            var id = event.model?['id'];
            Console.of.log("HAS NOTE ID $hasNoteId");
            if (hasNoteId) {
              var updateToDoBody = {"complete_status": event.model?['complete_status'], "todo_id": toDo['id']};
              await _updateNoteItem(updateToDoBody, event.model?['id']);
            }
            for (var element in noteItems) {
              if (element['id'] == id) {
                element['todo_id'] = toDo['id'];
                element['todos'] = toDo;
              }
            }
          }
          emit(AlterNotesCommonState());
        } else {
          // UPDATE
          var body = {
            "title": (event.model?['title'] as TextEditingController).text,
            "notes":
                (event.model?['description'] as TextEditingController).text,
            "type": "inline"
          };
          emit(AlterNotesLoadingState());
          await _updateTask(body, toDoId);
          emit(AlterNotesCommonState());
        }
      }
      FBroadcast.instance().broadcast("notes_view");
    } catch (e) {
      Console.of.error(e);
      emit(AlterNotesErrorState(e));
    }
  }

  void _onTapUserEvent(
          AlterNotesTapUserEvent event, Emitter<AlterNotesStates> emit) =>
      emit(AlterNotesTapUserState(
          event.model,
          event.offset,
          (event.model?['selectedUsers'].toString().isNullOrEmpty ?? false)
              ? []
              : (List.from(event.model?['selectedUsers'] ?? ""))
                  .map((e) => e['id'])
                  .toList()));

  void _onUserSelectionEvent(
      AlterNotesUserSelectionEvent event, Emitter<AlterNotesStates> emit) {
    var id = event.model?['id'];
    for (var element in noteItems) {
      if (element['id'] == id) element['selectedUsers'] = event.selectedUsers;
    }
    emit(AlterNotesCommonState());
  }

  void _onSaveEvent(
      AlterNotesSaveEvent event, Emitter<AlterNotesStates> emit) async {
    try {
      if (formKey.currentState?.validate() ?? false) {
        var body = {
          "title": titleController.text,
          "branch_id": branchId,
          "sub_notes": noteItems
              .map((e) => {
                    "id": (e['note_id'] != 0) ? e['id'] : "",
                    "title": (e['title'] as TextEditingController).text,
                    "todo_id": (e['todo_id'] != 0) ? e['todo_id'] : "",
                    "description":
                        (e['description'] as TextEditingController).text,
                    "complete_status": e['complete_status']
                  })
              .toList(),
          "date": selectedDate.toFormat()
        };
        emit(AlterNotesLoadingState());
        ((editModel != null) && (editModel?.isNotEmpty ?? false))
        ? await _updateNote(body..remove("date"), editModel?['id'])
        : await _createNotes(body);
        FBroadcast.instance().broadcast("notes_view");
        emit(AlterNotesCloseState());
      }
    } catch (e) {
      Console.of.error(e);
      emit(AlterNotesErrorState(e));
    }
  }

  void _onCompleteEvent(AlterNotesCompleteEvent event, Emitter<AlterNotesStates> emit) async {
    try {
      var body = {"complete_status": (event.status ?? false) ? 1 : 0 };
      emit(AlterNotesLoadingState());
      await _updateNoteItem(body, event.model?['id']);
      for (var element in noteItems) {
        if (element['id'] == event.model?['id']) element['complete_status'] = body['complete_status'];
      }
      emit(AlterNotesCommonState());
    } catch (e) {
      Console.of.error(e);
      emit(AlterNotesErrorState(e));
    }
  }
}
