import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:flutter/material.dart';

/*
enum VerificationEnum{
  pending,
  pending_request,
  submitted,
  approved,
  rejected,
  partially_approved,
  partially_rejected,
  pending_action,
  pending_admin_action,
  awaiting_payment,
  booking_cancelled,
  canceled_and_closed,
  awaiting_confirmation,
  unknown
}

List<String> verificationStatus = [
  'Pending',
  'Pending Request',
  'Submitted',
  'Approved',
  'Rejected',
  'Partially Approved',
  'Partially Rejected',
  'Pending Action',
  'Pending Action',
  'Awaiting Payment',
  'Booking Canceled',
  'Canceled and Closed',
  'Awaiting Confirmation',
  'Unknown'
];

extension VerificationStatusExtension on String?{
  VerificationEnum get type => VerificationEnum.values.firstWhere((element) => element.name == (this ?? "unknown"));
  String get label => verificationStatus[VerificationEnum.values.indexWhere((element) => element.name == (this ?? "unknown"))];

  Color get color => switch(type) {
    VerificationEnum.pending => Colors.amber,
    VerificationEnum.pending_request => Colors.amber,
    VerificationEnum.submitted => AppC.blue,
    VerificationEnum.approved => AppC.green,
    VerificationEnum.rejected => AppC.redAccent,
    VerificationEnum.partially_approved => AppC.grey,
    VerificationEnum.partially_rejected => Colors.amber,
    VerificationEnum.pending_action => Colors.amber,
    VerificationEnum.pending_admin_action => Colors.amber,
    VerificationEnum.awaiting_payment => AppC.grey,
    VerificationEnum.booking_cancelled => Colors.amber,
    VerificationEnum.canceled_and_closed => AppC.redAccent,
    VerificationEnum.awaiting_confirmation => Colors.amber,
    VerificationEnum.unknown => Colors.amber,
    _=> Colors.amber
  };
}
*/

enum VerificationEnum{
  pending,
  pending_request,
  submitted,
  approved,
  rejected,
  partially_approved,
  partially_rejected,
  pending_action,
  pending_admin_action,
  awaiting_payment,
  booking_cancelled,
  canceled_and_closed,
  awaiting_confirmation,
  collection_pending,
  canceled,
  confirmed,
  completed,
  in_progress,
  returned,
  claim_pending,
  unknown
}

List<String> verificationStatus = [
  'Pending',
  'Pending Request',
  'Submitted',
  'Approved',
  'Rejected',
  'Partially Approved',
  'Partially Rejected',
  'Pending Action',
  'Pending Action',
  'Awaiting Payment',
  'Booking Canceled',
  'Canceled and Closed',
  'Awaiting Confirmation',
  'Payment Collection Pending',
  'Canceled',
  'Ready for Pickup',
  "End Rental",
  "Ongoing",
  "Returned - Under Review",
  "Claims Pending",
  'Unknown'
];

extension VerificationStatusExtension on String?{
  VerificationEnum? get type => VerificationEnum.values.firstWhereOrNull((element) => element.name == (this ?? "unknown"));
  String get label => verificationStatus[VerificationEnum.values.indexWhere((element) => element.name == (this ?? "unknown"))];
  VerificationEnum get status => verificationStatus.contains(this) ? VerificationEnum.values[verificationStatus.indexOf(this ?? 'Unknown')] : VerificationEnum.unknown;

}

extension VerificationStatusExtensionByType on VerificationEnum {
  Color get color => switch(this) {
    VerificationEnum.pending => Colors.amber,
    VerificationEnum.pending_request => Colors.amber,
    VerificationEnum.submitted => AppC.appColor,
    VerificationEnum.approved => AppC.green,
    VerificationEnum.rejected => AppC.redAccent,
    VerificationEnum.partially_approved => AppC.blue,
    VerificationEnum.partially_rejected => Colors.amber,
    VerificationEnum.pending_action => Colors.amber,
    VerificationEnum.pending_admin_action => Colors.amber,
    VerificationEnum.awaiting_payment => AppC.grey,
    VerificationEnum.booking_cancelled => Colors.amber,
    VerificationEnum.canceled_and_closed => AppC.redAccent,
    VerificationEnum.awaiting_confirmation => Colors.amber,
    VerificationEnum.collection_pending => Colors.amber,
    VerificationEnum.canceled => AppC.redAccent,
    VerificationEnum.confirmed => AppC.green,
    VerificationEnum.completed =>  AppC.blue,
    VerificationEnum.in_progress => AppC.blue,
    VerificationEnum.returned => Colors.amber,
    VerificationEnum.claim_pending => Colors.amber,
    VerificationEnum.unknown => AppC.blue,
    _=> AppC.blue
  };
}