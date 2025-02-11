import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/Response/cohorts_response.dart';
import 'package:fairpytasker/Response/expense_summary_response.dart';
import 'package:fairpytasker/Response/payment_response.dart';
import 'package:fairpytasker/Response/task_response.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../event/todo_edit_expense_event.dart';
import '../repository/todo_edit_expense_repository.dart';
import '../state/todo_edit_expense_state.dart';

class TodoEditExpenseBloc extends Bloc<TodoEditExpenseEvent, TodoExpenseState> {
  final TodoEditExpenseRepository todoEditExpenseRepository =
      TodoEditExpenseRepository();
  dynamic expenseId = "";
  List<Map<String, dynamic>>? categories = [];
  List<dynamic>? ogAttachments = [];
  List<dynamic>? attachments = [];
  final TodoListRepo todoListRepo = TodoListRepo();
  final TextEditingController amountTextController = TextEditingController();
  final TextEditingController descriptionTextController =
      TextEditingController();
  final TextEditingController odometerTextController = TextEditingController();

  TodoEditExpenseBloc()
      : super(const TodoExpenseState(
            taskList: [],
            paymentMethods: [],
            mainCategories: [],
            subCategories: [],
            expenseAttachments: [],
            apiResponse: {},
            isLoading: false,
            selectedPayment: {},
            selectedMainCategory: {},
            selectedSubCategory: {})) {
    on<GetTodoExpenseInitialEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        expenseId = event.expenseId;
        var response = await Future.wait([
          _getTaskLists(),
          _getPaymentMethods(),
          _getExpenseCategories(),
        ]);
        ExpenseSummaryResponse? expenseDetailResponse =
            await _getExpenseDetails(expenseId);
        TaskExpenseResponse? taskExpenseResponse = (response[0] is TaskExpenseResponse)
            ?(response[0] as TaskExpenseResponse)
            :null;
        PaymentResponse? paymentResponse = (response[1] is PaymentResponse)
            ? (response[0] as PaymentResponse)
            : null;
        CohortsResponse? cohortsResponse = (response[2] is CohortsResponse)
            ? (response[1] as CohortsResponse)
            : null;
        ogAttachments = expenseDetailResponse?.expense?['attachments'];
        categories = cohortsResponse?.expenseData;
        attachments = ogAttachments
                ?.map((e) => e['path'].toString().toStorageURL)
                .toList() ??
            [];
        emit(state.copyWith(
            isLoading: false,
            apiResponse: expenseDetailResponse?.expense,
            taskList: taskExpenseResponse?.data,
            paymentMethods: paymentResponse?.data,
            mainCategories: categories,
            expenseAttachments: attachments));
      } catch (e) {
        Utils.showMobileToast(e.toString());
        emit(state.copyWith(isLoading: false));
      }
    });

    on<PickImageEvent>((event, emit) async {
      var result = await _pickFiles();
      if (result.isNotEmpty) {
        attachments?.addAll(result);
       /* log("Attachment Count: ${attachments?.length} ${result.length}",
            name: "Attachment_Count");*/
        emit(state.copyWith(expenseAttachments: attachments));
      }
    });

    on<RemoveImageEvent>((event, emit) {
      if (event.data == null) return;
      if (event.data is File) {
        // LOCAL SELECTION REMOVE
        attachments?.remove(event.data);
      } else if (event.data is String) {
        // REMOTE SELECTION REMOVE
        var data = attachments?.firstWhereOrNull(
            (element) => element == event.data.toString().removeStorageUrl);
        var attachmentId = ogAttachments
            ?.where((element) => element['path'] == data)
            .map((e) => e['id'])
            .firstOrNull;
        // {API CALL HERE }// PASS INTO API TO DELETE ATTACHMENT
        // once success remove from attachments
        attachments?.remove(event.data);
      }
      emit(state.copyWith(expenseAttachments: attachments));
    });

    on<CaptureImageEvent>((event, emit) async {
      var result = await _pickImages();
      if (result != null) {
        attachments?.add(result);
        emit(state.copyWith(expenseAttachments: attachments));
      }
    });

    on<PaymentListEvent>((event, emit) =>
        emit(state.copyWith(selectedPayment: event.paymentType)));

    on<TaskListEvent>((event, emit) =>
        emit(state.copyWith(taskList: event.taskList)));

    on<CategoryListEvent>((event, emit) {
      if (event.mainCategory != null) {
        var subCategories = event.mainCategory?['sub_categories'];
        var id = event.mainCategory?['id'];
        emit(state.copyWith(
            selectedMainCategory: event.mainCategory,
            subCategories: subCategories,
            selectedSubCategory: null));
      }
    });

    on<SubCategoryListEvent>((event, emit) =>
        emit(state.copyWith(selectedSubCategory: event.subCategory)));
  }

  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov']);
    return result?.paths
            .where((element) => (element?.isNotEmpty ?? false))
            .map((e) => File(e!))
            .toList() ??
        [];
  }

  Future<File?> _pickImages() async {
    final XFile? pickedFiles =
        await ImagePicker().pickImage(source: ImageSource.camera);
    return (pickedFiles != null) ? File(pickedFiles.path) : null;
  }



  Future<PaymentResponse?> _getPaymentMethods() async {
    return await todoListRepo.getPayment();
  }

  Future<TaskExpenseResponse?> _getTaskLists() async {
    return await todoListRepo.getTaskExpense();
  }

  Future<ExpenseSummaryResponse?> _getExpenseDetails(dynamic expenseId) async {
    return await todoEditExpenseRepository.getEditExpenseTodo(expenseId);
  }

  Future<CohortsResponse?> _getExpenseCategories() async {
    return await todoListRepo.getCohorts();
  }
}
