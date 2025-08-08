import 'dart:io';
import 'dart:math';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode;

  final TextEditingController notesController = TextEditingController();
  final TextEditingController initialPaymentController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();
  final TextEditingController transactionNumberController = TextEditingController();
  final TextEditingController imageNameController = TextEditingController();
  final TextEditingController adminNotesController = TextEditingController();
  final TextEditingController insuranceCompanyNameController = TextEditingController();
  final TextEditingController insuranceTypeController = TextEditingController();
  final TextEditingController paidByController = TextEditingController();
  final TextEditingController insuranceAmountController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController insuranceFileNameController = TextEditingController();

  List<dynamic> licenseCheckList = [];
  List<dynamic> addressCheckList = [];
  List<dynamic> agreementCheckList = [];
  List<dynamic> finalAgreementCheckList = [];
  List<dynamic> licenseAttachments = [];
  List<dynamic> addressAttachments = [];
  List<dynamic> agreementAttachments = [];
  List<dynamic> finalAgreementAttachments = [];
  List<dynamic> paymentAttachments = [];
  List<dynamic> addPaymentAttachments = [];
  List<dynamic> insuranceAttachments = [];

  List<dynamic> paymentTypes = [{'id': 1, 'name': 'Initial'}, {'id': 2, 'name': 'Full'}];
  List<dynamic> updatePaymentMethod= [
    {'id': 0, 'name': 'Select Payment Model', 'value': ''},
    {'id': 1, 'name': 'Direct (Option 1)', 'value': 'direct'},
    {'id': 2, 'name': 'Fleet Program (Option 2)', 'value': 'fleet_program'},
  ];

  dynamic bookingDetails;
  dynamic model;
  dynamic selectedPaymentType;
  dynamic selectedPaymentMethod;

  DateTime? selectedInsuranceExpiryDate;

  bool forceAction = false;
  bool insuranceInfo = false;

  String? token;

  int selectedValue = 1;

  Future<Map<String, dynamic>?> getCheckList({dynamic bookingId}) async => await apiRepository.rentalCheckList(bookingId: bookingId);
  Future<Map<String, dynamic>?> getToken() async => await apiRepository.getRentalToken();
  Future<Map<String, dynamic>?> updateVerificationStatus({dynamic body}) async => await apiRepository.verificationStatusUpdate(token: token,body: body);
  Future<Map<String, dynamic>?> _licenseVerify({dynamic body}) async => await apiRepository.licenseVerify(token: token,body: body);
  Future<Map<String, dynamic>?> _addressVerify({dynamic body}) async => await apiRepository.addressVerify(token: token,body: body);
  Future<Map<String, dynamic>?> _agreementVerify({dynamic body}) async => await apiRepository.agreementVerify(token: token,body: body);
  Future<Map<String, dynamic>?> _getAgreementPdf({dynamic body}) async => await apiRepository.getAgreementPdf(token: token, body: body);
  Future<Map<String, dynamic>?> _createPayment({dynamic body, dynamic files,}) async => await apiRepository.createPayment(token: token, body: body, images: files);
  Future<Map<String, dynamic>?> _updatePayment({dynamic body,}) async => await apiRepository.updatePayment(token: token, body: body,);
  Future<Map<String, dynamic>?> _updateInsuranceRequirement({dynamic body,}) async => await apiRepository.updateInsuranceRequirement(token: token, body: body,);
  Future<Map<String, dynamic>?> _updateInsurance({dynamic body, dynamic image}) async => await apiRepository.updateInsurance(token: token, body: body, images: image);
  Future<Map<String, dynamic>?> _deleteInsurance({dynamic id,}) async => await apiRepository.deleteInsurance(token: token, id: id,);

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
    on<GenerateAgreementEvent>(_onGenerateAgreementEvent);
    on<GenerateFinalAgreementEvent>(_onGenerateFinalAgreementEvent);
    on<ViewAgreementEvent>(_onViewAgreementEvent);
    on<SavePaymentEvent>(_onSavePaymentEvent);
    on<PaymentTypeEvent>(_onPaymentTypeEvent);
    on<UpdatePaymentMethodEvent>(_onUpdatePaymentMethodEvent);
    on<InsuranceInformationCheckEvent>(_onInsuranceInformationCheckEvent);
    on<InsuranceInformationSaveEvent>(_onInsuranceInformationSaveEvent);
    on<InsuranceDeleteEvent>(_onInsuranceDeleteEvent);
    on<InsuranceSaveEvent>(_onInsuranceSaveEvent);
    on<InsuranceExpiryDateEvent>(_onInsuranceExpiryDateEvent);
    on<ChooseInsuranceFileEvent>(_onChooseInsuranceFileEvent);
    on<RemoveInsuranceFileEvent>(_onRemoveInsuranceFileEvent);
    on<DeleteAlertDialogEvent>(_onDeleteAlertDialogEvent);

  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<VerificationState> emit) async {
    try {
      emit(LoadingState());
      model = event.data;
      if(model?['identifier_id'] == 407){
        selectedValue = 6;
      }
      Console.of.log(model);
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
        if (event.data['entity_type'] == 'final_agreement') {
          finalAgreementCheckList.where((element) => element['id'] == event.data['id']).first['is_checked'] = !event.data['is_checked'];
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
          model?['bookingDetails']?['license_status'] = response?['data']?['license_status'];
          emit(CommonState());
        }else{
          emit(ErrorState(response?['message']));
        }
      }
      if(approveModel?['label'] == 'address_proof'){
        var response = await _addressVerify(body: body);
        if(response?['success'] == true){
          addressAttachments.where((element) => element['id'] == approveModel['id']).first['verification'] = response?['data'];
          model?['bookingDetails']?['address_proof_status'] = response?['data']?['address_proof_status'];
          emit(CommonState());
        }else{
          emit(ErrorState(response?['message']));
        }
      }
      if(approveModel?['label'] == 'agreement'){
        var response = await _agreementVerify(body: body..["is_final_agreement"] = "0");
        if(response?['success'] == true){
          agreementAttachments.where((element) => element['id'] == approveModel['id']).first['verification'] = response?['data'];
          model?['bookingDetails']?['agreement_status'] = response?['data']?['agreement_status'];
          emit(CommonState());
        }else{
          emit(ErrorState(response?['message']));
        }
      }
      if(approveModel?['label'] == 'final_agreement'){
        var response = await _agreementVerify(body: body..["is_final_agreement"] = "1");
        if(response?['success'] == true){
          finalAgreementAttachments.where((element) => element['id'] == approveModel['id']).first['verification'] = response?['data'];
          model?['bookingDetails']?['final_agreement_status'] = response?['data']?['agreement_status'];
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
      if(rejectModel?['label'] == 'final_agreement'){
        var response = await _agreementVerify(body: body..["is_final_agreement"] = "1");
        if(response?['success'] == true){
          finalAgreementAttachments.where((element) => element['id'] == rejectModel['id']).first['verification'] = response?['data'];
          model?['bookingDetails']?['final_agreement_status'] = response?['data']?['agreement_status'];
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
      selectedPaymentType = bookingDetails?['cost_summary']?['paymentMethod']?['slug'] == 'pay_now' ? paymentTypes.lastOrNull  : paymentTypes.firstOrNull;
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

  void _onGenerateAgreementEvent(GenerateAgreementEvent event, Emitter<VerificationState> emit) async {
    try {
      if(bookingDetails['payment_model'] == null && event.isChecked == false) return emit(UpdatePaymentModelState());
      if(event.isChecked == true && selectedPaymentMethod['id'] == 0) return emit(ErrorState('Please select a payment model'));
      emit(LoadingState());
      if(event.isChecked == true){
       var response = await _updatePayment(body: {
          'booking_id': bookingDetails?['id'],
          'payment_model': selectedPaymentMethod['value'],
        });
        if(response?['success'] == true){
          model?['bookingDetails']?['payment_model'] = selectedPaymentMethod?['value'];
          bookingDetails?['payment_model'] = selectedPaymentMethod?['value'];
        }
      }
      var response = await _getAgreementPdf(body: {'booking_id': model?['bookingDetails']?['id']} );
      if(response?['success'] == true){
        agreementAttachments.clear();
        agreementAttachments.add(response?['data']);
        Console.of.log(agreementAttachments);
        for (var element in agreementAttachments) {
          (element['controller'] = TextEditingController());
        }
        model?['bookingDetails']?['agreement_status'] = response?['data']?['booking']?['agreement_status'];
        emit(CommonState());
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch (e){
      _onError(e, emit);
    }
  }

  void _onGenerateFinalAgreementEvent(GenerateFinalAgreementEvent event, Emitter<VerificationState> emit) async {
    try {
      if(bookingDetails['payment_model'] == null && event.isChecked == false) return emit(UpdatePaymentModelState());
      if(event.isChecked == true && selectedPaymentMethod['id'] == 0) return emit(ErrorState('Please select a payment model'));
      emit(LoadingState());
      if(event.isChecked == true){
       var response = await _updatePayment(body: {
          'booking_id': bookingDetails?['id'],
          'payment_model': selectedPaymentMethod['value'],
        });
        if(response?['success'] == true){
          model?['bookingDetails']?['payment_model'] = selectedPaymentMethod?['value'];
          bookingDetails?['payment_model'] = selectedPaymentMethod?['value'];
        }
      }
      var response = await _getAgreementPdf(body: {
        'booking_id': model?['bookingDetails']?['id'],
        'is_final_agreement': '1'
      } );
      if(response?['success'] == true){
        finalAgreementAttachments.clear();
        finalAgreementAttachments.add(response?['data']);
        Console.of.log(finalAgreementAttachments);
        for (var element in finalAgreementAttachments) {
          (element['controller'] = TextEditingController());
        }
        model?['bookingDetails']?['final_agreement_status'] = response?['data']?['booking']?['final_agreement_status'];
        emit(CommonState());
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch (e){
      _onError(e, emit);
    }
  }

  void _onViewAgreementEvent(ViewAgreementEvent event, Emitter<VerificationState> emit) async {
    try {
      Utils.openURL(event.data?['file_url']);
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onSavePaymentEvent(SavePaymentEvent event, Emitter<VerificationState> emit) async {
    try{
      List<Map<String, String?>> infusedFiles = paymentAttachments.whereType<File>().map((e) => {"attachments" : e.path }).toList();
      emit(LoadingState());
      var body = {
        'booking_id': bookingDetails?['id'],
        'payment_type': selectedPaymentType?['name'].toString().toLowerCase(),
        'transaction_no': transactionNumberController.text,
      };
      var response = await _createPayment(
        body: body,
        files: infusedFiles,
      );
      if(response?['success'] == true){
        model?['bookingDetails']?['payment_status'] = response?['data']?['payment_status'];
        model?['bookingDetails']?['payments'] = [response?['data']?['payment']];
        bookingDetails?['payments'] = [response?['data']?['payment']];
        bookingDetails?['payment_status'] = response?['data']?['payment_status'];
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }

  void _onPaymentTypeEvent(PaymentTypeEvent event, Emitter<VerificationState> emit) async {
    try{
      selectedPaymentType = event.data;
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }

  void _onUpdatePaymentMethodEvent(UpdatePaymentMethodEvent event, Emitter<VerificationState> emit) async {
    try{
      selectedPaymentMethod = event.data;
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }

  void _onInsuranceInformationCheckEvent(InsuranceInformationCheckEvent event, Emitter<VerificationState> emit) async {
    try{
      insuranceInfo = !insuranceInfo;
      bookingDetails['insurance_info_required'] = insuranceInfo ? 1 : 0;
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }

  void _onInsuranceInformationSaveEvent(InsuranceInformationSaveEvent event, Emitter<VerificationState> emit) async {
    try{
      if(adminNotesController.text.isEmpty) return emit(ErrorState('Please enter a note.'));
      emit(LoadingState());
      var response = await _updateInsuranceRequirement(body: {
        'booking_id': bookingDetails?['id'],
        'insurance_admin_notes': adminNotesController.text,
        'insurance_info_required': bookingDetails['insurance_info_required'],
      });
      if(response?['success'] == true){
        model?['bookingDetails']?['insurance_info_required'] = response?['data']?['insurance_info_required'];
        model?['bookingDetails']?['insurance_admin_notes'] = response?['data']?['insurance_admin_notes'];
        model?['bookingDetails']?['insurance_status'] = response?['data']?['insurance_status'];
        bookingDetails['insurance_admin_notes'] = response?['data']?['insurance_admin_notes'];
        bookingDetails?['insurance_status'] = response?['data']?['insurance_status'];
        bookingDetails?['insurance_info_required'] = response?['data']?['insurance_info_required'];
        Console.of.log(response?['data']);
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    } catch(e){
      _onError(e, emit);
    }
  }

  void _onDeleteAlertDialogEvent(DeleteAlertDialogEvent event, Emitter<VerificationState> emit) async {
    try{
      emit(InsuranceDeleteState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onInsuranceDeleteEvent(InsuranceDeleteEvent event, Emitter<VerificationState> emit) async {
    try{
      emit(LoadingState());
      var response = await _deleteInsurance(id: bookingDetails?['insurance']?['id']);
      if(response?['success'] == true){
        model?['bookingDetails']?['insurance_status'] = 'pending_admin_action';
        bookingDetails?['insurance_status'] = 'pending_admin_action';
        model?['bookingDetails']?['insurance'] = null;
        bookingDetails?['insurance'] = null;
        insuranceAttachments.clear();
        insuranceFileNameController.clear();
        insuranceCompanyNameController.clear();
        insuranceTypeController.clear();
        paidByController.clear();
        expiryDateController.clear();
        insuranceAmountController.clear();
        selectedInsuranceExpiryDate = null;
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }

  void _onInsuranceSaveEvent(InsuranceSaveEvent event, Emitter<VerificationState> emit) async {
    try{
      autoValidateMode = AutovalidateMode.onUserInteraction;
      if(formKey.currentState?.validate() == false) return emit(CommonState());
      emit(LoadingState());
      autoValidateMode = null;
      var input = _updateData();
      var response = await _updateInsurance(
        body: input['data'],
        image: input['image'],
      );
      if(response?['success'] == true){
        model?['bookingDetails']?['insurance_status'] = response?['data']?['insurance_status'];
        bookingDetails?['insurance_status'] = response?['data']?['insurance_status'];
        model?['bookingDetails']?['insurance'] = response?['data'];
        bookingDetails?['insurance'] = response?['data'];
        insuranceAttachments.clear();
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    } catch(e){
      _onError(e, emit);
    }
  }

  void _onInsuranceExpiryDateEvent(InsuranceExpiryDateEvent event, Emitter<VerificationState> emit) async {
    try{
      selectedInsuranceExpiryDate = event.data;
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }

  void _onChooseInsuranceFileEvent(ChooseInsuranceFileEvent event, Emitter<VerificationState> emit) async {
    try{
      var result = await _pickFiles(allowMultiple: false);
      if (result.isNotEmpty) {
        insuranceAttachments.clear();
        insuranceAttachments = result;
        insuranceFileNameController.text = basename(insuranceAttachments.lastOrNull?.path ?? "");
      }
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }

  void _onRemoveInsuranceFileEvent(RemoveInsuranceFileEvent event, Emitter<VerificationState> emit) async {
    try{
      if (event.data == null) return;
      insuranceAttachments.remove(event.data);
      insuranceFileNameController.text = basename((insuranceAttachments.lastOrNull is File)
          ? (insuranceAttachments.lastOrNull as File).path
          : insuranceAttachments.lastOrNull?.toString() ?? "");
      emit(CommonState());
    } catch(e){
      _onError(e, emit);
    }
  }

  Future<void> fetchData() async {
    bookingDetails = model?['bookingDetails'];
    adminNotesController.text = bookingDetails?['insurance_admin_notes'] ?? '';
    insuranceCompanyNameController.text = bookingDetails?['insurance']?['company_name'] ?? '';
    insuranceTypeController.text = bookingDetails?['insurance']?['insurance_type'] ?? '';
    paidByController.text = bookingDetails?['insurance']?['paid_by'] ?? '';
    expiryDateController.text = bookingDetails?['insurance']?['expiry_date'] ?? '';
    insuranceAmountController.text = bookingDetails?['insurance']?['amount'] ?? '';
    selectedInsuranceExpiryDate = bookingDetails?['insurance']?['expiry_date'] != null ? DateTime.parse(bookingDetails?['insurance']?['expiry_date']) : null;

    insuranceInfo = bookingDetails?['insurance_info_required'] == 1;

    var tokenRes = await getToken();
    token = tokenRes?['data'];
    var response = await getCheckList(bookingId: model['bookingDetails']?['id']);
    if(response != null){
      licenseCheckList = List.from(response['data']?['license'] ?? []);
      addressCheckList = List.from(response['data']?['address_proof'] ?? []);
      agreementCheckList = List.from(response['data']?['agreement'] ?? []);
      finalAgreementCheckList = List.from(response['data']?['final_agreement'] ?? []);
    }
    for (var item in licenseCheckList) {item['entity_type'] = 'license';}
    for (var item in addressCheckList) {item['entity_type'] = 'address_proof';}
    for (var item in agreementCheckList) {item['entity_type'] = 'agreement';}
    for (var item in finalAgreementCheckList) {item['entity_type'] = 'final_agreement';}
    licenseAttachments = List.from(bookingDetails['bookingattachments'] ?? [])
        .where((element) => element['label'] == 'driving_license').toList();
    addressAttachments = List.from(bookingDetails['bookingattachments'] ?? [])
        .where((element) => element['label'] == 'address_proof').toList();
    agreementAttachments = List.from(bookingDetails['bookingattachments'] ?? [])
        .where((element) => element['label'] == 'agreement').toList();
    finalAgreementAttachments = List.from(bookingDetails['bookingattachments'] ?? [])
        .where((element) => element['label'] == 'final_agreement').toList();
    paymentAttachments = List.from(bookingDetails['bookingattachments'] ?? [])
        .where((element) => element['label'] == 'payment')
        .map((e) => e['file_url'])
        .toList();
    for (var item in licenseAttachments) {item['controller'] = TextEditingController();}
    for (var item in addressAttachments) {item['controller'] = TextEditingController();}
    for (var item in agreementAttachments) {item['controller'] = TextEditingController();}
    for (var item in finalAgreementAttachments) {item['controller'] = TextEditingController();}

    for (var element in licenseAttachments) {
      (element['controller'] as TextEditingController).text = element['reject_reason']?? '';
    }

    for (var element in addressAttachments) {
      (element['controller'] as TextEditingController).text = element['reject_reason']?? '';
    }

    for (var element in agreementAttachments) {
      (element['controller'] as TextEditingController).text = element['reject_reason']?? '';
    }

    for (var element in finalAgreementAttachments) {
      (element['controller'] as TextEditingController).text = element['reject_reason']?? '';
    }

    selectedPaymentMethod = updatePaymentMethod.lastOrNull;

  }

  void _onError(dynamic error, Emitter<VerificationState> emit){
    Console.of.log(error);
    emit(ErrorState(error));
  }

  Future<List<File>> _pickFiles({bool? allowMultiple}) async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple ?? true,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf',]);
    return result?.paths
        .where((element) => (element?.isNotEmpty ?? false))
        .map((e) => File(e!))
        .toList() ??
        [];
  }

  Map<String, dynamic> _updateData(){
    Map<String, dynamic> data = {
      'booking_id': bookingDetails?['id'],
      'user_id': bookingDetails?['user_id'],
      'company_name': insuranceCompanyNameController.text,
      'insurance_type': insuranceTypeController.text,
      'paid_by': paidByController.text,
      'amount': insuranceAmountController.text,
      'expiry_date': selectedInsuranceExpiryDate.toFormat(),
    };
    List<dynamic> attachments = insuranceAttachments.whereType<File>().map((e) => {"document" : e.path }).toList();
    Console.of.log(data);
    Console.of.log(attachments);
    return {'data': data, 'image': attachments};
  }

}