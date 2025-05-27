import 'package:equatable/equatable.dart';

abstract class TRCDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TRCDInitialEvent extends TRCDEvents {
  final Map<String, dynamic>? model;
  final bool isCheckOut;
  TRCDInitialEvent({this.model, required this.isCheckOut});
  @override
  List<Object?> get props => [model, isCheckOut];
}

class TRCDMoveToRepairEvent extends TRCDEvents {
  final bool value;
  TRCDMoveToRepairEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class TRCDBlockCalendarEvent extends TRCDEvents {
  final bool value;
  TRCDBlockCalendarEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class TRCDMileageImagePickEvent extends TRCDEvents {}
class TRCDMileageAttachmentViewEvent extends TRCDEvents {}

class TRCDNotesImagePickEvent extends TRCDEvents {}
class TRCDNotesAttachmentViewEvent extends TRCDEvents {}

class TRCDVehicleCleaningNeedEvent extends TRCDEvents {
  final dynamic selected;
  TRCDVehicleCleaningNeedEvent({required this.selected});
  @override
  List<Object?> get props => [selected];
}

class TRCDPostCheckOutCheckEvent extends TRCDEvents {
  final String selected;
  TRCDPostCheckOutCheckEvent({required this.selected});
  @override
  List<Object?> get props => [selected];
}

class TRCDSubmitEvent extends TRCDEvents {}

class TRCDSubmitOverrideEvent extends TRCDEvents {}

class TRCDRemoveAttachmentEvent extends TRCDEvents {
  final dynamic attachment;
  final dynamic type;
  TRCDRemoveAttachmentEvent(this.attachment, this.type);
  @override
  List<Object?> get props => [attachment, type];
}

class TRCDNoCleanDialogEvent extends TRCDEvents {
  final bool isPositive;
  TRCDNoCleanDialogEvent({this.isPositive = true});
  @override
  List<Object?> get props => [isPositive];
}