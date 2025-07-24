import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState>{

  final APiRepository apiRepository = APiRepository();

  final TextEditingController notesController = TextEditingController();
  final TextEditingController initialPaymentController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();
  final TextEditingController transactionNumberController = TextEditingController();
  final TextEditingController imageNameController = TextEditingController();

  List<dynamic> licenseCheckList = [];
  List<dynamic> addressCheckList = [];
  List<dynamic> agreementCheckList = [];
  List<dynamic> licenseAttachments = [];
  List<dynamic> addressAttachments = [];
  List<dynamic> agreementAttachments = [];
  List<dynamic> paymentAttachments = [];
  List<dynamic> addPaymentAttachments = [];

  List<dynamic> paymentTypes = [{'id': 1, 'name': 'Initial'}, {'id': 2, 'name': 'Full'}];

  dynamic bookingDetails;
  dynamic model;
  dynamic selectedPaymentType;

  bool forceAction = false;

  String? token;

  int selectedValue = 1;

  Future<Map<String, dynamic>?> getCheckList({dynamic bookingId}) async => await apiRepository.rentalCheckList(bookingId: bookingId);
  Future<Map<String, dynamic>?> getToken() async => await apiRepository.getRentalToken();
  Future<Map<String, dynamic>?> updateVerificationStatus({dynamic body}) async => await apiRepository.verificationStatusUpdate(token: token,body: body);
  Future<Map<String, dynamic>?> _licenseVerify({dynamic body}) async => await apiRepository.licenseVerify(token: token,body: body);
  Future<Map<String, dynamic>?> _addressVerify({dynamic body}) async => await apiRepository.addressVerify(token: token,body: body);
  Future<Map<String, dynamic>?> _agreementVerify({dynamic body}) async => await apiRepository.agreementVerify(token: token,body: body);

  VerificationBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<TabChangeEvent>(_onTabChangeEvent);
    on<CheckListEvent>(_onCheckListEvent);
    on<ForceActionEvent>(_onForceActionEvent);
    on<ApproveEvent>(_onApproveEvent);
    on<RejectEvent>(_onRejectEvent);
    on<AddPaymentEvent>(_onAddPaymentEvent);
    on<PaymentAttachmentEvent>(_onPaymentAttachmentEvent);
    on<RemovePaymentAttachmentEvent>(_onRemovePaymentAttachmentEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<VerificationState> emit) async {
    try {
      emit(LoadingState());
      model = event.data;
      await fetchData();
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onTabChangeEvent(TabChangeEvent event, Emitter<VerificationState> emit){
    try {
      selectedValue = event.value;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onCheckListEvent(CheckListEvent event, Emitter<VerificationState> emit) async {
    try {
      emit(LoadingState());
      var body = {
        "booking_id": bookingDetails['id'],
        "entity_type": event.data['entity_type'],
        "statuses": [{
          "checklist_id": event.data['id'],
          "is_checked": event.data['is_checked'] == true ? 0 : 1,
        }]
      };
      Console.of.log(body, name: 'body');
      var response = await updateVerificationStatus(body: body);
      if(response?['success'] == true) {
        if (event.data['entity_type'] == 'license') {
          licenseCheckList.where((element) => element['id'] == event.data['id']).first['is_checked'] = !event.data['is_checked'];
        }
        if (event.data['entity_type'] == 'address_proof') {
          addressCheckList.where((element) => element['id'] == event.data['id']).first['is_checked'] = !event.data['is_checked'];
        }
        if (event.data['entity_type'] == 'agreement') {
          agreementCheckList.where((element) => element['id'] == event.data['id']).first['is_checked'] = !event.data['is_checked'];
        }
        emit(CommonState());
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onForceActionEvent(ForceActionEvent event, Emitter<VerificationState> emit) async {
    try{
      forceAction = !forceAction;
      Console.of.log(forceAction, name: 'forceAction');
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onApproveEvent(ApproveEvent event, Emitter<VerificationState> emit) async {
    try {
      var approveModel = event.data;
      Console.of.log(approveModel);
      if((approveModel?['label'] == 'address_proof') && (event.isDialog == false)){
        bool check = addressCheckList.any((element) => element['is_checked'] == false);
        if(check) return emit(ApproveWarningState(approveModel));
      }
      emit(LoadingState());
      var body = {
        'attachment_id':approveModel?['id'],
        'booking_id': approveModel?['booking_id'],
        'force_event': forceAction == true ? 1 : 0,
        'notes': (approveModel['controller'] as TextEditingController).text,
        'status': 'approved',
      };
      if(approveModel?['label'] == 'driving_license'){
        var response = await _licenseVerify(body: body);
        if(response?['success'] == true){
          licenseAttachments.where((element) => element['id'] == approveModel['id']).first['verification'] = response?['data'];
          emit(CommonState());
        }else{
          emit(ErrorState(response?['message']));
        }
      }
      if(approveModel?['label'] == 'address_proof'){
        var response = await _addressVerify(body: body);
        if(response?['success'] == true){
          addressAttachments.where((element) => element['id'] == approveModel['id']).first['verification'] = response?['data'];
          emit(CommonState());
        }else{
          emit(ErrorState(response?['message']));
        }
      }
      if(approveModel?['label'] == 'agreement'){
        var response = await _agreementVerify(body: body..["is_final_agreement"] = "0");
        if(response?['success'] == true){
          agreementAttachments.where((element) => element['id'] == approveModel['id']).first['verification'] = response?['data'];
          emit(CommonState());
        }else{
          emit(ErrorState(response?['message']));
        }
      }

    }catch (e){
      _onError(e, emit);
    }
  }

  void _onRejectEvent(RejectEvent event, Emitter<VerificationState> emit) async {
    try {
      var rejectModel = event.data;
      if((rejectModel['controller'] as TextEditingController).text.isEmpty) return emit(ErrorState('The notes field is required when status is rejected.'));
      emit(LoadingState());
      var body = {
        'attachment_id':rejectModel?['id'],
        'booking_id': rejectModel?['booking_id'],
        'force_event': forceAction == true ? 1 : 0,
        'notes': (rejectModel['controller'] as TextEditingController).text,
        'status': 'rejected',
      };
      if(rejectModel?['label'] == 'driving_license'){
        var response = await _licenseVerify(body: body);
        if(response?['success'] == true){
          licenseAttachments.where((element) => element['id'] == rejectModel['id']).first['verification'] = response?['data'];
          model?['bookingDetails']?['license_status'] = response?['data']?['license_status'];
          emit(CommonState());
        }else{
          emit(ErrorState(response?['message']));
        }
      }
      if(rejectModel?['label'] == 'address_proof'){
        var response = await _addressVerify(body: body);
        if(response?['success'] == true){
          addressAttachments.where((element) => element['id'] == rejectModel['id']).first['verification'] = response?['data'];
          model?['bookingDetails']?['address_proof_status'] = response?['data']?['address_proof_status'];
          emit(CommonState());
        }else{
          emit(ErrorState(response?['message']));
        }
      }
      if(rejectModel?['label'] == 'agreement'){
        var response = await _agreementVerify(body: body..["is_final_agreement"] = "0");
        if(response?['success'] == true){
          agreementAttachments.where((element) => element['id'] == rejectModel['id']).first['verification'] = response?['data'];
          model?['bookingDetails']?['agreement_status'] = response?['data']?['agreement_status'];
          emit(CommonState());
        }else{
          emit(ErrorState(response?['message']));
        }
      }


    }catch (e){
      _onError(e, emit);
    }
  }

  void _onAddPaymentEvent(AddPaymentEvent event, Emitter<VerificationState> emit) async {
    try {
      initialPaymentController.text = bookingDetails?['cost_summary']?['initialPayment'] ?? '';
      paymentMethodController.text = bookingDetails?['payment_request']?['payout_account']?['payment_method'] ?? '';
      selectedPaymentType = paymentTypes.first;
      emit(AddManualPaymentState());
    }catch (e){
      _onError(e, emit);
    }
  }

  void _onPaymentAttachmentEvent(PaymentAttachmentEvent event, Emitter<VerificationState> emit) async {
    try {
      var result = await _pickFiles();
      if (result.isNotEmpty) {
        var attachments = List.from(addPaymentAttachments);
        var existingAttachments = List.from(addPaymentAttachments)
            .whereType<File>()
            .map((e) => (e.path))
            .toList();
        for (var element in result) {
          if (!existingAttachments.contains(element.path)) {
            attachments.add(element);
          }
        }
        addPaymentAttachments = attachments;
        imageNameController.text = basename(addPaymentAttachments.lastOrNull?.path ?? "");
        emit(CommonState());
      }
      emit(CommonState());
    }catch (e){
      _onError(e, emit);
    }
  }

  void _onRemovePaymentAttachmentEvent(RemovePaymentAttachmentEvent event, Emitter<VerificationState> emit) async {
    try {
      if (event.data == null) return;
      addPaymentAttachments.remove(event.data);
      imageNameController.text = basename((addPaymentAttachments.lastOrNull is File)
          ? (addPaymentAttachments.lastOrNull as File).path
          : addPaymentAttachments.lastOrNull?.toString() ?? "");
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> fetchData() async {
    bookingDetails = model?['bookingDetails'];
    var tokenRes = await getToken();
    token = tokenRes?['data'];
    var response = await getCheckList(bookingId: model['bookingDetails']?['id']);
    if(response != null){
      licenseCheckList = List.from(response['data']?['license'] ?? []);
      addressCheckList = List.from(response['data']?['address_proof'] ?? []);
      agreementCheckList = List.from(response['data']?['agreement'] ?? []);
    }
    for (var item in licenseCheckList) {item['entity_type'] = 'license';}
    for (var item in addressCheckList) {item['entity_type'] = 'address_proof';}
    for (var item in agreementCheckList) {item['entity_type'] = 'agreement';}
    licenseAttachments = List.from(bookingDetails['bookingattachments'] ?? [])
        .where((element) => element['label'] == 'driving_license').toList();
    addressAttachments = List.from(bookingDetails['bookingattachments'] ?? [])
        .where((element) => element['label'] == 'address_proof').toList();
    agreementAttachments = List.from(bookingDetails['bookingattachments'] ?? [])
        .where((element) => element['label'] == 'agreement').toList();
    paymentAttachments = List.from(bookingDetails['bookingattachments'] ?? [])
        .where((element) => element['label'] == 'payment')
        .map((e) => e['file_url'])
        .toList();
    for (var item in licenseAttachments) {item['controller'] = TextEditingController();}
    for (var item in addressAttachments) {item['controller'] = TextEditingController();}
    for (var item in agreementAttachments) {item['controller'] = TextEditingController();}

    for (var element in licenseAttachments) {
      (element['controller'] as TextEditingController).text = element['reject_reason']?? '';
    }

    for (var element in addressAttachments) {
      (element['controller'] as TextEditingController).text = element['reject_reason']?? '';
    }

    for (var element in agreementAttachments) {
      (element['controller'] as TextEditingController).text = element['reject_reason']?? '';
    }

  }

  void _onError(dynamic error, Emitter<VerificationState> emit){
    Console.of.log(error);
    emit(ErrorState(error));
  }

  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf',]);
    return result?.paths
        .where((element) => (element?.isNotEmpty ?? false))
        .map((e) => File(e!))
        .toList() ??
        [];
  }

}